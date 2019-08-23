//
//  DashAPI.swift
//  Example
//
//  Created by John Lima on 15/03/19.
//  Copyright © 2019 thejohnlima. All rights reserved.
//

import Foundation
import BaseNetworkKit

enum DashAPI {
  case topGames(ModelRequest)
}

extension DashAPI: NKFlowTarget {
  var baseURL: URL {
    return URL(stringValue: "https://api.twitch.tv/")
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

  var task: NKTask {
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
