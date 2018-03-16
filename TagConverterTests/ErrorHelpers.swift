//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import XCTest

func expectNoError(_ message: String = "Unexpected throw", file: StaticString = #file, line: UInt = #line, block: () throws -> Void) {

    do {
        try block()
    } catch {
        XCTFail("\(message) (\(error))", file: file, line: line)
    }
}

func ignoreError(block: () throws -> Void) {

    do {
        try block()
    } catch {
        // no op
    }
}

enum TestError: Error {
    case irrelevant
}

let irrelevantError = TestError.irrelevant

class ErrorHandlerDouble {
    var didHandleError: Error?
    func handleError(error: Error) {
        didHandleError = error
    }
}

