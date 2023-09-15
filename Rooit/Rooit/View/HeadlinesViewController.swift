//
//  ViewController.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/4.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class HeadlinesViewController: UIViewController {

  lazy var tableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    return tableView
  }()

  private var viewModel = NewsViewModel(service: MoyaProvider<MoyaService>())
  private var headlines = [Article]()
  private var refreshControl = UIRefreshControl()
  private var bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    addPullToRefresh()
    setupUI()
    fetchNews()
    tableViewBinding()
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

  private func tableViewBinding() {
    viewModel.items
      .bind(to: tableView.rx.items(cellIdentifier: NewsCell.reuseIdentifier, cellType: NewsCell.self)) { [weak self] (row, element, cell) in
        cell.config(image: element.urlToImage, title: element.title)
        self?.refreshControl.endRefreshing()
      }
      .disposed(by: bag)

    tableView.rx
      .modelSelected(Article.self)
      .subscribe(onNext:  { value in
        print("Tapped \(value)")
      })
      .disposed(by: bag)
  }

}

