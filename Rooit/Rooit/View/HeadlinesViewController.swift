//
//  ViewController.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/4.
//

import UIKit
import Moya
import RxSwift

class HeadlinesViewController: UIViewController {

  lazy var tableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    return tableView
  }()

  private var viewModel = NewsViewModel(service: MoyaProvider<MoyaService>())
  private var bag = DisposeBag()
  private var headlines = [Article]()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    fetchNews()
    binding()
  }

  func setupUI() {
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  func fetchNews() {
    viewModel.fetchNews(country: "us")
  }

  func binding() {
    viewModel.newsData.subscribe { newsData in
      self.headlines = newsData
      self.tableView.reloadData()
    }.disposed(by: bag)
  }

}

extension HeadlinesViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    headlines.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else { fatalError("Cannot Down casting")}
    let item = headlines[indexPath.row]
    cell.config(image: item.urlToImage, title: item.title)
    return cell
  }

}


