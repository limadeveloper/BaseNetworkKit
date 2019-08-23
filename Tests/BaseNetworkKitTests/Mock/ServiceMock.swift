//  MIT License
//
//  Copyright (c) 2019 John Lima
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
@testable import BaseNetworkKit

enum CustomError: Error, CustomStringConvertible {
  case noFound

  var description: String {
    switch self {
    case .noFound:
      return "No found"
    }
  }
}

enum ResultType {
  case success
  case fail
}

enum RequesterAPI: NKFlowTarget {
  case items(body: ModelRequestMock, type: ResultType)
}

extension RequesterAPI {
  var baseURL: URL {
    return URL(stringValue: "https://api.twitch.tv/")
  }

  var path: String {
    switch self {
    case .items:
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
    case .items(let body, _):
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

class ServiceMock: BaseServiceMock {
  func fetchData(_ resultType: ResultType, completion: @escaping NKCommon.ResultType<ModelMock>) {
    let requestModel = ModelRequestMock(offset: "\(0)", limit: "\(2)")
    fetch(.items(body: requestModel, type: resultType), dataType: ModelMock.self, completion: completion)
  }
}

class BaseServiceMock: NKBaseService<RequesterAPI> {
  override func fetch<Value: NKCodable>(_ target: RequesterAPI,
                                        dataType: Value.Type,
                                        completion: @escaping NKCommon.ResultType<Value>) {
    let mock: Value? = try? JSONDecoder().decode(Value.self, from: jsonData)

    var type: ResultType {
      guard case .items(_, let type) = target else { return .fail }
      return type
    }

    guard let result = mock, type == .success else {
      completion(.failure(CustomError.noFound))
      return
    }

    let response = URLResponse()
    completion(.success((response, result)))
  }
}

extension BaseServiceMock {
  var jsonData: Data {
    return """
    {
        "_total": 2065,
        "top": [
            {
                "game": {
                    "name": "Dota 2",
                    "popularity": 35952,
                    "_id": 29595,
                    "giantbomb_id": 32887,
                    "box": {
                        "large": "https://static-cdn.jtvnw.net/ttv-boxart/Dota%202-272x380.jpg",
                        "medium": "https://static-cdn.jtvnw.net/ttv-boxart/Dota%202-136x190.jpg",
                        "small": "https://static-cdn.jtvnw.net/ttv-boxart/Dota%202-52x72.jpg",
                        "template": "https://static-cdn.jtvnw.net/ttv-boxart/Dota%202-{width}x{height}.jpg"
                    },
                    "logo": {
                        "large": "https://static-cdn.jtvnw.net/ttv-logoart/Dota%202-240x144.jpg",
                        "medium": "https://static-cdn.jtvnw.net/ttv-logoart/Dota%202-120x72.jpg",
                        "small": "https://static-cdn.jtvnw.net/ttv-logoart/Dota%202-60x36.jpg",
                        "template": "https://static-cdn.jtvnw.net/ttv-logoart/Dota%202-{width}x{height}.jpg"
                    },
                    "localized_name": "Dota 2",
                    "locale": "en-us"
                },
                "viewers": 236316,
                "channels": 350
            },
            {
                "game": {
                    "name": "Grand Theft Auto V",
                    "popularity": 163570,
                    "_id": 32982,
                    "giantbomb_id": 36765,
                    "box": {
                        "large": "https://static-cdn.jtvnw.net/ttv-boxart/Grand%20Theft%20Auto%20V-272x380.jpg",
                        "medium": "https://static-cdn.jtvnw.net/ttv-boxart/Grand%20Theft%20Auto%20V-136x190.jpg",
                        "small": "https://static-cdn.jtvnw.net/ttv-boxart/Grand%20Theft%20Auto%20V-52x72.jpg",
                        "template": "https://static-cdn.jtvnw.net/ttv-boxart/Grand%20Theft%20Auto%20V-{width}x{height}.jpg"
                    },
                    "logo": {
                        "large": "https://static-cdn.jtvnw.net/ttv-logoart/Grand%20Theft%20Auto%20V-240x144.jpg",
                        "medium": "https://static-cdn.jtvnw.net/ttv-logoart/Grand%20Theft%20Auto%20V-120x72.jpg",
                        "small": "https://static-cdn.jtvnw.net/ttv-logoart/Grand%20Theft%20Auto%20V-60x36.jpg",
                        "template": "https://static-cdn.jtvnw.net/ttv-logoart/Grand%20Theft%20Auto%20V-{width}x{height}.jpg"
                    },
                    "localized_name": "Grand Theft Auto V",
                    "locale": "en-us"
                },
                "viewers": 106018,
                "channels": 1026
            }
        ]
    }
    """.data(using: .utf8)!
  }
}
