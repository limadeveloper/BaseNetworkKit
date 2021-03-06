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

// MARK: - Protocols
protocol NKErrorProtocol: LocalizedError {
  var code: Int { get }
  var message: String { get }
}

// MARK: - Enums
public enum NKErrorMessage: String {
  case unknown = "Something wrong, try again later."
  case network = "No connection"
}

public enum NKErrorCode: Int {
  case generic = 99_998
  case withoutInternet = -1_009
  case connectionLost = -1_005
  case hostConnection = -1_004
  case findHost = -1_003
  case timeout = -1_001
  case unknown = -1
  case parseError = -2
  case cancelled = -3
}

public enum NKError: Error {
  case network(Error)
  case api(NKAPIError)
  case parse(Error)
}

// MARK: - Extensions
extension NKError: NKErrorProtocol {
  public var message: String {
    return localizedDescription
  }

  public var code: Int {
    switch self {
    case .api(let error):
      return error.code ?? 0
    case .network(let error):
      guard let e = error as? URLError else {
        return NKErrorCode.connectionLost.rawValue
      }
      return e.errorCode
    case .parse:
      return NKErrorCode.parseError.rawValue
    }
  }

  public var localizedDescription: String {
    switch self {
    case .api(let error):
      return error.message
    case .network:
      return NKErrorMessage.network.rawValue
    case .parse:
      return NKErrorMessage.unknown.rawValue
    }
  }

  static func checkForErrors(_ data: Data?,
                             error: Error? = nil,
                             response: URLResponse? = nil) -> NKError? {
    if let error = error as? NKFlowError, let networkError = error.underlyingError {
      return NKError.network(networkError)
    }

    if response?.validationStatus != .success,
      let responseData = data,
      let apiError = getAPIError(responseData) {
      let error = NKError.api(apiError)
      return error
    }

    return nil
  }

  static func getAPIError(_ data: Data) -> NKAPIError? {
    let apiResponse = NKAPIErrorResponse(data)
    let apiError = NKAPIError(data)

    if let apiError = apiError {
      return apiError
    } else if let apiResponse = apiResponse {
      return apiResponse.error
    }

    return nil
  }
}

extension NKError: Equatable {
  public static func == (lhs: NKError, rhs: NKError) -> Bool {
    return lhs.code == rhs.code
  }

  static func == (lhs: NKError, rhs: NKErrorCode) -> Bool {
    return lhs.code == rhs.rawValue
  }
}
