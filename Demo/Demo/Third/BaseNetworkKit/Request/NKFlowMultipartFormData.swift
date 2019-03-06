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

public struct NKFlowMultipartFormData {

  // MARK: - Properties
  /// The method being used for providing form data.
  public let provider: NKFlowFormDataProvider

  /// The name.
  public let name: String

  /// The file name.
  public let fileName: String

  /// The MIME type
  public let mimeType: String?

  // MARK: - Enums
  /// Method to provide the form data.
  public enum NKFlowFormDataProvider {
    case data(Data)
    case file(URL)
  }

  // MARK: - Initializers
  public init(provider: NKFlowFormDataProvider, name: String, fileName: String, mimeType: String? = nil) {
    self.provider = provider
    self.name = name
    self.fileName = fileName
    self.mimeType = mimeType
  }
}
