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

extension URLRequest {
  mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
    do {
      let encodable = NKEncodable(encodable)
      httpBody = try encoder.encode(encodable)
      let contentTypeHeaderName = "Content-Type"
      if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
        setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
      }
      return self
    } catch {
      throw NKFlowError.encode(error)
    }
  }

  mutating func encoded(parameters: NKCommon.JSON, paramEncode: NKParameterEncoding) throws -> URLRequest {
    do {
      let comps = getURLComponents(queryParameters: parameters)
      self.url = comps?.url
      try validateURL()
      if self.httpMethod != NKHTTPMethods.get.rawValue {
        if self.value(forHTTPHeaderField: "Content-Type") == nil {
          self.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        httpBody = comps?.percentEncodedQuery?.data(using: .utf8)
      }
      return self
    } catch {
      throw NKFlowError.encode(error)
    }
  }

  mutating func encoded(bodyParameters: NKCommon.JSON, urlParameters: NKCommon.JSON) throws -> URLRequest {
    do {
      if self.httpMethod == NKHTTPMethods.get.rawValue {
        fatalError("Only used with others http methods.")
      }
      let contentTypeHeaderName = "Content-Type"
      if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
        setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
      }
      updateURL(withQueryParameters: urlParameters)
      try validateURL()
      httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
      return self
    } catch {
      throw NKFlowError.encode(error)
    }
  }

  /// Throws an error if the URL somehow doesn't exist in this URLRequester
  private func validateURL() throws {
    guard self.url != nil else {
      throw NKFlowError.invalidURL
    }
  }

  /// Update the URLRequest's url appending querystring parameters from dictionary
  private mutating func updateURL(withQueryParameters parameters: NKCommon.JSON) {
    url = buildURL(queryParameters: parameters)
  }

  /// Build the final url using query parameters
  private func buildURL(queryParameters: NKCommon.JSON) -> URL? {
    return getURLComponents(queryParameters: queryParameters)?.url ?? url
  }

  /// Get the URLComponent for the current URLRequest with given url parameters (querystring)
  private func getURLComponents(queryParameters: NKCommon.JSON) -> URLComponents? {
    guard let urlUnwrapped = self.url else { return nil }
    var components = URLComponents(string: urlUnwrapped.absoluteString)
    guard !queryParameters.isEmpty else { return components }
    let queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    components?.queryItems = queryItems
    return components
  }
}
