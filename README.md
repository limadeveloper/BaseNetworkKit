<h1 align="center">BaseNetworkKit</h1>

<p align="center">
 <a href="https://github.com/thejohnlima/BaseNetworkKit/releases">
  <img src="https://img.shields.io/github/v/release/thejohnlima/BaseNetworkKit?style=for-the-badge">
 </a>
 <a href="https://github.com/thejohnlima/BaseNetworkKit/actions">
  <img src="https://img.shields.io/github/workflow/status/thejohnlima/BaseNetworkKit/CI/master?style=for-the-badge">
 </a>
 <a href="https://cocoapods.org/pods/BaseNetworkKit">
  <img src="https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=for-the-badge">
 </a><br>
 <a href="https://github.com/thejohnlima/BaseNetworkKit">
  <img src="https://img.shields.io/github/repo-size/thejohnlima/BaseNetworkKit.svg?style=for-the-badge">
 </a>
 <a href="https://raw.githubusercontent.com/thejohnlima/BaseNetworkKit/master/LICENSE">
  <img src="https://img.shields.io/github/license/thejohnlima/BaseNetworkKit.svg?style=for-the-badge">
 </a>
 <a href="https://developer.apple.com/ios/">
  <img src="https://img.shields.io/cocoapods/p/BaseNetworkKit?style=for-the-badge">
 </a>
 <a href="https://developer.apple.com/swift/">
  <img src="https://img.shields.io/badge/Swift-5-blue.svg?style=for-the-badge">
 </a>
 <a href="https://patreon.com/thejohnlima">
  <img src="https://img.shields.io/badge/donate-patreon-yellow.svg?style=for-the-badge">
 </a>
</p>

**BaseNetworkKit** is the easiest way to create your network layer in Swift.

## ❗️Requirements

- iOS 9.3+
- Swift 5.0+

## ⚒ Installation

### Swift Package Manager

**BaseNetworkKit** is available through [SPM](https://developer.apple.com/videos/play/wwdc2019/408/). To install
it, follow the steps:

```script
Open Xcode project > File > Swift Packages > Add Package Dependecy
```

After that, put the url in the field: `https://github.com/thejohnlima/BaseNetworkKit.git`

### CocoaPods

**BaseNetworkKit** is available through [CocoaPods](https://cocoapods.org/pods/BaseNetworkKit). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BaseNetworkKit'
```

and run `pod install`

## 🎓 How to use

Import library in your network layer:

```Swift
import BaseNetworkKit
```

Setup request

```Swift
enum RequesterAPI {
  // Body can be a model object conform to NKCodable
  case listOfItems(Body)
}

extension RequesterAPI: NKFlowTarget {
  // Set your api
  var baseURL: URL {
    return URL(stringValue: "https://your.api")
  }

  // Set your endpoints
  var path: String {
    switch self {
    case .listOfItems:
      return "endpoint1"
    }
  }

  // Set http methods
  var method: NKHTTPMethods {
    return .get
  }

  // Set headers if needed
  var headers: NKCommon.HTTPHeader? {
    return [
      "key1": "value2",
      "key2": "value2"
    ]
  }

  // Here you can set the tasks, like parameters
  var task: NKTask {
    switch self {
    case .listOfItems(let body):
      guard let params = body.dictionary(), !params.isEmpty else {
        return .requestPlain
      }
      return .requestParameters(params, encoding: .queryString)
    }
  }

  // You want to see the request logs, set the environment to develop
  var environment: NKEnvironment {
    return .develop
  }
}
```

Than, create a request function

```swift
class Service: NKBaseService<RequesterAPI> {
  func fetchItems(page: Int, limit: Int, completion: @escaping NKCommon.ResultType<Model>) {
    let requestModel = ModelRequest(offset: "\(page)", limit: "\(limit)")
    fetch(.listOfItems(requestModel), dataType: Model.self, completion: completion)
  }
}
```

*If you need more examples, open [`demo project`](https://github.com/thejohnlima/BaseNetworkKit/tree/master/Demo).*

## 🙋🏻‍ Communication

- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request. 👨🏻‍💻

## 📜 License

**BaseNetworkKit** is under MIT license. See the [LICENSE](https://raw.githubusercontent.com/thejohnlima/BaseNetworkKit/master/LICENSE?token=ALdmBr7BYPLFm0JcKkmChbVeGU10EblTks5cgHzcwA%3D%3D) file for more info.
