//
//  NewsViewModel.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/4.
//

import Foundation
import RxMoya
import Moya
import RxSwift
import RealmSwift

class NewsViewModel {

  private let service: MoyaProvider<MoyaService>
  private var bag = DisposeBag()
  var newsData = BehaviorSubject(value: [Article]())

  init(service: MoyaProvider<MoyaService>) {
    self.service = service
  }

  weak var delegate: NewsViewModelDelegate?

  func fetchNews(country: String) {
    service.rx.request(.topHeadlines(country: country))
      .subscribe { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
          do {
            let filterResponse = try response.filterSuccessfulStatusCodes()
            let decodedData = try filterResponse.map(NewsData.self)
            //            self.newsData.onNext(decodedData.articles)
            addToRealm(newsData: decodedData)
          } catch let error {
            print(error.localizedDescription)
          }
        case .failure(let error):
          print(error.localizedDescription)
        }
      }.disposed(by: bag)
  }

  func addToRealm(newsData: NewsData) {
    let realm = try! Realm()
    do {
      try realm.write {
        // Iterate through the articles in newsData
        for article in newsData.articles {
          // Check if a similar article already exists in Realm based on a unique identifier (e.g., article URL)
          if let existingArticle = realm.objects(RealmArticle.self).filter("url == %@", article.url).first {
            // Update the existing article with new data
            existingArticle.source?.id = article.source.id
            existingArticle.source?.name = article.source.name
            existingArticle.author = article.author
            existingArticle.title = article.title
            existingArticle.descript = article.description
            existingArticle.url = article.url
            existingArticle.urlToImage = article.urlToImage
            existingArticle.publishedAt = article.publishedAt
            existingArticle.content = article.content
          } else {
            // Create a new RealmArticle if it doesn't exist
            let realmArticle = RealmArticle()
            realmArticle.source = RealmSource()
            realmArticle.source?.id = article.source.id
            realmArticle.source?.name = article.source.name
            realmArticle.author = article.author
            realmArticle.title = article.title
            realmArticle.descript = article.description
            realmArticle.url = article.url
            realmArticle.urlToImage = article.urlToImage
            realmArticle.publishedAt = article.publishedAt
            realmArticle.content = article.content
            realm.add(realmArticle)
          }
        }
      }
      DispatchQueue.main.async {
        self.delegate?.updateInitial()
      }
    } catch {
      print("Error adding data to Realm: \(error.localizedDescription)")
    }
  }

  private var notificationToken: NotificationToken?

  // Function to set up the Realm observer
  func observeRealmChanges() {
    let realm = try! Realm()
    let realmNewsData = realm.objects(RealmNewsData.self)

    // Add an observer for changes to Realm data
    notificationToken = realmNewsData.observe { [weak self] (changes: RealmCollectionChange) in
      guard let self = self else { return }

      switch changes {
      case .initial:
        self.delegate?.updateInitial()
      case .update(_, let deletions, let insertions, let modifications):
        self.delegate?.updateUIWithChanges(deletions: deletions, insertions: insertions, modifications: modifications)
      case .error(let error):
        print("Error observing Realm changes: \(error)")
      }
    }
  }

  // Function to stop observing Realm changes (optional, for cleanup)
  func stopObservingRealmChanges() {
    notificationToken?.invalidate()
  }
}


// Protocol for notifying the view controller of data changes
protocol NewsViewModelDelegate: AnyObject {
  func updateInitial()
  func updateUIWithChanges(deletions: [Int], insertions: [Int], modifications: [Int])
}
