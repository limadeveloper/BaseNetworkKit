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

enum NKFlowRequestComposer {
  static func create<Target: NKFlowTarget>(_ target: Target) throws -> URLRequest {
    var request = URLRequest(url: URL(target: target))
    request.allHTTPHeaderFields = target.headers
    request.httpMethod = target.method.rawValue
    
    switch target.task {
    case .requestPlain:
      return request
    case .requestData(let data):
      request.httpBody = data
    case .requestJSONEncodable(let body):
      return try request.encoded(encodable: body)
    case .requestCompositeParameters(let bodyParameters, let urlParameters):
      return try request.encoded(bodyParameters: bodyParameters, urlParameters: urlParameters)
    case .requestParameters(let parameters, let encode):
      return try request.encoded(parameters: parameters, paramEncode: encode)
    case .uploadMultipart(let files):
      return try request.multipart(files)
    }

    return request
  }
}
