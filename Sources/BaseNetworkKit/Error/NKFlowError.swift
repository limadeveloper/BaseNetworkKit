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
protocol FlowErrorProtocol: LocalizedError {
  var code: Int { get }
  var underlyingError: Error? { get }
}

// MARK: - Enums
public enum NKFlowError: Error {
  case invalidURL
  case encode(Error)
  case network(Error)
  case invalidRequest(Error)
  case invalidBody(Error)
  case invalidParameters
  case noFound
}

// MARK: - Extensions
extension NKFlowError: FlowErrorProtocol {
  public var code: Int {
    switch self {
    case .invalidURL:
      return -7_000
    case .encode:
      return -7_001
    case .network(let error):
      guard let e = error as? URLError else {
        return -0
      }
      return e.errorCode
    case .invalidRequest:
      return -7_002
    case .invalidBody:
      return -7_003
    case .invalidParameters:
      return -7_004
    case .noFound:
      return -7_005
    }
  }

  public var underlyingError: Error? {
    switch self {
    case .invalidURL, .invalidParameters, .noFound:
      return nil
    case .encode(let error):
      return error
    case .network(let error):
      return error
    case .invalidRequest(let error):
      return error
    case .invalidBody(let error):
      return error
    }
  }

  public var localizedDescription: String {
    switch self {
    case .invalidURL:
      return "invalid URL"
    case .encode(let error):
      return error.localizedDescription
    case .network(let error):
      return error.localizedDescription
    case .invalidRequest(let error):
      return error.localizedDescription
    case .invalidBody(let error):
      return error.localizedDescription
    case .invalidParameters:
      return "Invalid parameters"
    case .noFound:
      return "Data not found"
    }
  }
}
