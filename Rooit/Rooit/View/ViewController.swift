//
//  ViewController.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/4.
//

import UIKit
import Moya
import RxSwift

class ViewController: UIViewController {

  lazy var tableView = {
    let tableView = UITableView(frame: view.frame, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    return tableView
  }()

  private var viewModel = NewsViewModel(service: MoyaProvider<MoyaService>())
  var bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    fetchNews()
    binding()
  }

  func setupUI() {
    view.addSubview(tableView)
  }

  func fetchNews() {
    viewModel.fetchNews(country: "us")
  }

  func binding() {
    viewModel.newsData.subscribe { newsData in
      
    }.disposed(by: bag)
  }


}

extension ViewController: UITableViewDelegate {}


