//
//  APIService.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/4.
//
import Foundation
import Moya


enum MoyaService {
  case topHeadlines(country: String)
}

extension MoyaService: TargetType {

  var baseURL: URL { return URL(string: "https://newsapi.org/v2/")!}

  var path: String {
    switch self {
    case .topHeadlines:
      return "top-headlines"
    }
  }

  var method: Moya.Method {
    switch self {
    case .topHeadlines:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case .topHeadlines(let country):
      return .requestParameters(parameters: ["country" : country, "apiKey": Config.newsAPIKey], encoding: URLEncoding.default)
    }
  }

  var headers: [String : String]? {
    switch self {
    case .topHeadlines:
      return nil
    }
  }


}

