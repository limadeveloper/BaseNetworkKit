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

@testable import BaseNetworkKit
import XCTest

final class BaseNetworkKitTests: XCTestCase {

  // MARK: - Propertiees
  private var viewModel: ViewModelMock?

  static var allTests = [
    ("testFetchDataSuccess", testFetchDataSuccess)
  ]

  // MARK: - Overrides
  override func setUp() {
    super.setUp()
    viewModel = ViewModelMock()
  }

  override func tearDown() {
    viewModel = nil
    super.tearDown()
  }

  // MARK: - Test Methods
  func testFetchDataSuccess() {
    let expectation = self.expectation(description: "Wait for fetch data with success")

    viewModel?.fetchData(.success) { model, error in
      XCTAssertNil(error)
      XCTAssertEqual(model?.topGames.count, 2)
      XCTAssertEqual(model?.topGames.first?.game.name, "Dota 2")
      expectation.fulfill()
    }

    waitForExpectations(timeout: 0.3)
  }

  func testFetchDataError() {
    let expectation = self.expectation(description: "Wait for fetch data with error")

    viewModel?.fetchData(.fail) { model, error in
      let error = error as? CustomError
      XCTAssertNil(model)
      XCTAssertEqual(error?.description, "No found")
      expectation.fulfill()
    }

    waitForExpectations(timeout: 0.3)
  }
}
