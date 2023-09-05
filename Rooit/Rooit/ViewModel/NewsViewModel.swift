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

class NewsViewModel {

  private let service: MoyaProvider<MoyaService>
  private var bag = DisposeBag()
  var newsData = PublishSubject<NewsData>()

  init(service: MoyaProvider<MoyaService>) {
    self.service = service
  }

  func fetchNews(country: String) {
    service.rx.request(.topHeadlines(country: country))
      .subscribe { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
          do {
            let filterResponse = try response.filterSuccessfulStatusCodes()
            let decodedData = try filterResponse.map(NewsData.self)
            self.newsData.onNext(decodedData.self)
          } catch let error {
            print(error.localizedDescription)
          }
        case .failure(let error):
          print(error.localizedDescription)
        }
      }.disposed(by: bag)
  }
}
