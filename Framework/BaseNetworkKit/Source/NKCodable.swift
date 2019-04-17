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

public protocol NKCodable: Codable {
  init?(_ dictionary: NKCommon.JSON)
  init?(_ data: Data)
  func dictionary() -> NKCommon.JSON?
  func jsonString() -> String
}

extension NKCodable {
  public init?(_ dictionary: NKCommon.JSON) {
    do {
      let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
      let object = try JSONDecoder().decode(Self.self, from: data)
      self = object
    } catch {
      if NKManager.shared.environment == .develop {
        print("⚠️ error: \(error.localizedDescription)")
      }
      return nil
    }
  }

  public init?(_ data: Data) {
    do {
      let decoder = JSONDecoder()
      let object = try decoder.decode(Self.self, from: data)
      self = object
    } catch {
      if NKManager.shared.environment == .develop {
        print("⚠️ error: \(error.localizedDescription)")
      }
      return nil
    }
  }

  public func dictionary() -> NKCommon.JSON? {
    if let jsonData = try? JSONEncoder().encode(self),
      let result = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? NKCommon.JSON {
      return result
    }
    return nil
  }

  public func jsonString() -> String {
    if  let data = try? JSONEncoder().encode(self),
      let result = String(data: data, encoding: .utf8) {
      return result
    }
    return "{}"
  }
}
