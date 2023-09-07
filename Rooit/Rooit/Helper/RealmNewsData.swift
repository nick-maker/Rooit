//
//  RealmManager.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/5.
//

import RealmSwift

class RealmNewsData: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var status: String
  @Persisted var totalResults: Int
  @Persisted var articles: List<RealmArticle>
}

class RealmArticle: Object {
  @Persisted var source: RealmSource?
  @Persisted var author: String?
  @Persisted var title: String?
  @Persisted var descript: String?
  @Persisted var url: String?
  @Persisted var urlToImage: String?
  @Persisted var publishedAt: String?
  @Persisted var content: String?
}

class RealmSource: Object {
  @Persisted var id: String?
  @Persisted var name: String?
}
