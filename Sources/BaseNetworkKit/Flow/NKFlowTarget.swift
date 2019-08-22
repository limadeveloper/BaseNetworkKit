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

public enum NKHTTPMethods: String {
  case get = "GET"
  case post = "POST"
  case update = "PUT"
  case delete = "DELETE"
  case head = "HEAD"
  case patch = "PATCH"
}

public enum NKParameterEncoding {
  case queryString
  case httpBody
  case formData
}

public enum NKTask {
  /// A request with no additional data.
  case requestPlain

  /// A requests body set with data.
  case requestData(Data)

  /// A request body set with `Encodable` type
  case requestJSONEncodable(Encodable)

  /// A requests body set with encoded parameters combined with url parameters.
  case requestCompositeParameters(bodyParameters: NKCommon.JSON, urlParameters: NKCommon.JSON)

  /// A requests body set with encoded parameters.
  case requestParameters(_ parameters: NKCommon.JSON, encoding: NKParameterEncoding)

  /// A "multipart/form-data" upload task.
  case uploadMultipart([NKFlowMultipartFormData])
}

public protocol NKFlowTarget {
  /// The Domain
  var baseURL: URL { get }

  /// The path to be appended to `baseURL` to form the full `URL`.
  var path: String { get }

  /// The HTTP method used in the request.
  var method: NKHTTPMethods { get }

  /// The headers to be used in the request.
  var headers: NKCommon.HTTPHeader? { get }

  /// The task to be used in the request.
  var task: NKTask { get }

  /// The app environment: `develop` or `production`
  var environment: NKEnvironment { get }
}

public extension NKFlowTarget {
  var path: String {
    return ""
  }

  var headers: NKCommon.HTTPHeader? {
    return nil
  }
}
