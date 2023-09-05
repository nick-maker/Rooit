//
//  NewsCell.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/5.
//

import UIKit

class NewsCell: UITableViewCell {

  static let reuseIdentifier = "\(NewsCell.self)"

  private var picView = UIImageView()
  private var titleLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {

    picView.layer.cornerRadius = 10
    titleLabel.numberOfLines = 0

    [picView, titleLabel].forEach {
      contentView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      picView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      picView.widthAnchor.constraint(equalTo: picView.heightAnchor, multiplier: 1),
      picView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      picView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

      titleLabel.leadingAnchor.constraint(equalTo: picView.trailingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -16),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

    ])

  }

}
