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
  mutating func multipart(_ files: [NKFlowMultipartFormData]) throws -> URLRequest {
    let boundary = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    do {
      let httpBodyData = try createUploadBody(files, boundary: boundary)
      httpBody = httpBodyData
    } catch {
      throw NKFlowError.invalidBody(error)
    }
    return self
  }

  func createUploadBody(_ files: [NKFlowMultipartFormData], boundary: String) throws -> Data? {
    let body = NSMutableData()

    for file in files {
      var content: Data

      switch file.provider {
      case .data(let data):
        content = data
      case .file(let url):
        content = try Data(contentsOf: url)
      }

      let mimeType = file.mimeType ?? "application/octet-stream"

      body.append("--" + boundary)
      body.append("\r\n")
      body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.fileName)\"\r\n")
      body.append("Content-Type: \(mimeType)\r\n\r\n")
      body.append(content)
      body.append("\r\n")
    }

    body.append("--\(boundary)--\r\n")

    return body as Data
  }
}

extension NSMutableData {
  public func append(_ string: String) {
    guard let data = string.data(using: .utf8, allowLossyConversion: false) else { return }
    append(data)
  }
}
