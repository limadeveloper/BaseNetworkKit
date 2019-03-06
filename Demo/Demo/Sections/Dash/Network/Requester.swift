//
//  Requester.swift
//  Demo
//
//  Created by John Lima on 04/03/19.
//  Copyright © 2019 limadeveloper. All rights reserved.
//

import Foundation

enum RequesterAPI {
  case topGames(ModelRequest)
}

extension RequesterAPI: NKFlowTarget {
  var baseURL: URL! {
    return URL(string: "https://api.twitch.tv/")
  }

  var path: String {
    switch self {
    case .topGames:
      return "kraken/games/top"
    }
  }

  var method: NKHTTPMethods {
    return .get
  }

  var headers: NKCommon.HTTPHeader? {
    return [
      "Accept": "application/vnd.twitchtv.v5+json",
      "Client-ID": "5f1mxwqmosk9lsmwoglmz7o6icahcq"
    ]
  }

  var task: Task {
    switch self {
    case .topGames(let body):
      guard let params = body.dictionary(), !params.isEmpty else {
        return .requestPlain
      }
      return .requestParameters(params, encoding: .queryString)
    }
  }

  var environment: NKEnvironment {
    return .develop
  }
}

final class Requester: NKBaseService<RequesterAPI> {
  func fetchGames(page: Int, limit: Int, completion: @escaping NKCommon.Completion<Model>) {
    let requestModel = ModelRequest(offset: "\(page)", limit: "\(limit)")
    fetch(.topGames(requestModel), dataType: Model.self) { result, _, error in
      completion(result, error)
    }
  }
}
