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

open class NKBaseService<T: NKFlowTarget> {

  // MARK: - Properties
  public var provider = NKFlowProvider<T>()

  // MARK: - Initializers
  public init() {}

  // MARK: - Public Methods
  public func fetch(_ target: T, completion: NKCommon.CompletionHandlerPlain) {
    provider.request(target) { data, response, error in
      if let e = self.checkForErrors(data, error: error, response: response) {
        completion?(response, e)
        return
      }
      completion?(response, nil)
    }
  }

  public func fetch<Value: NKCodable>(_ target: T,
                                      dataType: Value.Type,
                                      completion: NKCommon.CompletionHandler<Value>) {
    provider.request(target) { data, response, error in
      if let e = self.checkForErrors(data, error: error, response: response) {
        completion?(nil, response, e)
        return
      }
      guard let data = data, let model = dataType.init(data) else {
        let error = NKFlowError.noFound
        let e = NKError.parse(error)
        completion?(nil, response, e)
        return
      }
      completion?(model, response, nil)
    }
  }
  
  // MARK: - Private Methods
  private func checkForErrors(_ data: Data?, error: NKFlowError? = nil, response: URLResponse? = nil) -> NKError? {
    if let error = error, let networkError = error.underlyingError {
      return NKError.network(networkError)
    }
    if response?.validationStatus != .success,
      let responseData = data,
      let apiResponse = NKAPIErrorResponse(responseData),
      let apiError = apiResponse.error {
      let error = NKError.api(apiError)
      return error
    }
    return nil
  }
}
