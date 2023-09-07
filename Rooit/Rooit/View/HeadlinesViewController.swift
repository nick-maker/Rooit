//
//  ViewController.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/4.
//

import UIKit
import Moya
import RxSwift
import RealmSwift

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
  private var headlines = try! Realm().objects(RealmArticle.self)
  private var refreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    addPullToRefresh()
    setupUI()
    fetchNews()
    viewModel.observeRealmChanges()
  }

  private func setupUI() {
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func addPullToRefresh() {
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.addSubview(refreshControl)
  }

  @objc private func refresh(sender:AnyObject) {
    tableView.reloadData()
  }

  private func fetchNews() {
    viewModel.fetchNews(country: "us")
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
    refreshControl.endRefreshing()
    return cell
  }

}

extension HeadlinesViewController: NewsViewModelDelegate {

  func updateInitial() {
    tableView.reloadData()
  }

  func updateUIWithChanges(deletions: [Int], insertions: [Int], modifications: [Int]) {
    
    self.tableView.beginUpdates()
    self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
    self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
    self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
    self.tableView.endUpdates()
  }

}

