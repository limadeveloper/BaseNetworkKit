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

public protocol NKFlowProviderProtocol: AnyObject {
  associatedtype Target: NKFlowTarget
  func request(_ target: Target, completion: @escaping NKCommon.CompletionResult)
}

open class NKFlowProvider<Target: NKFlowTarget>: NKFlowProviderProtocol {
  var requester: NKFlowRequester

  init(_ requester: NKFlowRequester = NKFlowRequester()) {
    self.requester = requester
  }

  public func request(_ target: Target, completion: @escaping NKCommon.CompletionResult) {
    NKManager.shared.environment = target.environment
    requester.debugMode = target.environment == .develop ? .verbose : .silent
    do {
      let request = try NKFlowRequestComposer.create(target)
      requester.perform(request) { responseData, response, error in
        completion(responseData, response, error)
      }
    } catch {
      completion(nil, nil, NKFlowError.invalidRequest(error))
    }
  }
}
