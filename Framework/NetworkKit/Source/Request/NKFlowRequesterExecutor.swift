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
import SystemConfiguration

// MARK: - Enums
enum NKFlowDebugMode {
  case silent
  case verbose
}

// MARK: - Protocols
protocol NKFlowRequesterExecutorProtocol {
  var debugMode: NKFlowDebugMode { get set }
  func execute(request: URLRequest, in session: URLSession, completion: NKCommon.CompletionResult?)
}

class NKFlowRequesterExecutor: NKFlowRequesterExecutorProtocol {

  // MARK: - Properties
  var debugMode: NKFlowDebugMode = .silent

  // MARK: - Public Methods
  func execute(request: URLRequest, in session: URLSession, completion: NKCommon.CompletionResult?) {
    session.dataTask(with: request) { data, response, error in
      if self.debugMode == .verbose {
        self.debugResponse(request, data, response, error)
      }
      if let e = error {
        completion?(data, response, NKFlowError.network(e))
        return
      }
      completion?(data, response, nil)
    }.resume()
    session.finishTasksAndInvalidate()
  }

  // MARK: - Private Methods
  private func debugResponse(_ request: URLRequest,
                             _ responseData: Data?,
                             _ response: URLResponse?,
                             _ error: Error?) {
    let uuid = UUID().uuidString

    print("\n🚀 ======= REQUEST =======")
    print("🚀 REQUEST #: \(uuid)")
    print("🚀 URL: \(request.url?.absoluteString ?? "")")

    if let requestHeaders = request.allHTTPHeaderFields,
      let requestHeadersData = try? JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted),
      let requestHeadersString = String(data: requestHeadersData, encoding: .utf8) {
      print("🚀 HEADERS:\n\(requestHeadersString)")
    }

    if let requestBodyData = request.httpBody,
      let requestBody = String(data: requestBodyData, encoding: .utf8) {
      print("🚀 BODY: \(requestBody)")
    }

    if let httpResponse = response as? HTTPURLResponse {
      print("\n🚀 ======= RESPONSE =======")
      switch httpResponse.statusCode {
      case 200...202:
        print("🚀 CODE: \(httpResponse.statusCode) - ✅")
      case 400...505:
        print("🚀 CODE: \(httpResponse.statusCode) - ❌")
      default:
        print("🚀 CODE: \(httpResponse.statusCode) - ❓")
      }

      if let responseHeadersData = try? JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: .prettyPrinted),
        let responseHeadersString = String(data: responseHeadersData, encoding: .utf8) {
        print("🚀 HEADERS:\n\(responseHeadersString)")
      }

      if let responseBodyData = responseData,
        let responseBody =  String(data: responseBodyData, encoding: .utf8),
        !responseBody.isEmpty {

        if let responseBodyDictionary = try? JSONSerialization.jsonObject(with: responseBodyData, options: .allowFragments) {
          print("🚀 BODY:\n\(responseBodyDictionary)\n")
        } else {
          print("🚀 BODY:\n\(responseBody)\n")
        }
      }
    }

    if let urlError = error as? URLError {
      print("\n❌ ======= ERROR =======")
      print("❌ CODE: \(urlError.errorCode)")
      print("❌ DESCRIPTION: \(urlError.localizedDescription)\n")
    }

    print("======== END OF: \(uuid) ========\n\n")
  }
}
