# BaseNetworkKit

[![GitHub release](https://img.shields.io/github/release/limadeveloper/BaseNetworkKit.svg)](https://github.com/limadeveloper/BaseNetworkKit/releases)
[![Build Status](https://travis-ci.com/limadeveloper/BaseNetworkKit.svg?token=HzevNmMEwiqbuyePKWyP&branch=master)](https://travis-ci.com/limadeveloper/BaseNetworkKit)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org/pods/BaseNetworkKit)
[![GitHub repo size](https://img.shields.io/github/repo-size/limadeveloper/BaseNetworkKit.svg)](https://github.com/limadeveloper/BaseNetworkKit)
[![License](https://img.shields.io/github/license/limadeveloper/BaseNetworkKit.svg)](https://raw.githubusercontent.com/limadeveloper/BaseNetworkKit/master/LICENSE)

**BaseNetworkKit** is the easiest way to create your network layer in Swift.

## Requirements

- iOS 9.3+
- Swift 4.0+

## Installation

### CocoaPods

**BaseNetworkKit** is available through [CocoaPods](https://cocoapods.org/pods/BaseNetworkKit). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BaseNetworkKit', '~> 1.0'
```

and run `pod install`

### Manual

Just copy source folder to your project.

```script
Framework > BaseNetworkKit > Source
```

## How to use

Import library in your network layer:

```Swift
import BaseNetworkKit
```

*Example using [`Twitch API`](https://dev.twitch.tv/docs/v5/):*

Setup request

```Swift
enum RequesterAPI {
  case topGames(ModelRequest)
}

extension RequesterAPI: NKFlowTarget {
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
```

Than, create a request function

```swift
final class Requester: NKBaseService<RequesterAPI> {
  func fetchGames(page: Int, limit: Int, completion: @escaping NKCommon.Completion<Model>) {
    let requestModel = ModelRequest(offset: "\(page)", limit: "\(limit)")
    fetch(.topGames(requestModel), dataType: Model.self) { result, _, error in
      completion(result, error)
    }
  }
}
```

*If you need more examples, open [`demo project`](https://github.com/limadeveloper/BaseNetworkKit/tree/master/Demo).*

## Communication

- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request. 👨🏻‍💻

## License

**BaseNetworkKit** is under MIT license. See the [LICENSE](https://raw.githubusercontent.com/limadeveloper/BaseNetworkKit/master/LICENSE?token=ALdmBr7BYPLFm0JcKkmChbVeGU10EblTks5cgHzcwA%3D%3D) file for more info.