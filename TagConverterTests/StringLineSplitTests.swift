//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import TagConverter

class StringLineSplitTests: XCTestCase {

    func testEmptyString() {
        XCTAssertEqual(split(string: "", lineNumber: 0).0, "")
        XCTAssertEqual(split(string: "", lineNumber: 0).1, "")

        XCTAssertEqual(split(string: "", lineNumber: 1).0, "")
        XCTAssertEqual(split(string: "", lineNumber: 1).1, "")

        XCTAssertEqual(split(string: "", lineNumber: 10).0, "")
        XCTAssertEqual(split(string: "", lineNumber: 10).1, "")
    }

    func testStringWithoutLineBreak() {
        XCTAssertEqual(split(string: "hello", lineNumber: 0).0, "")
        XCTAssertEqual(split(string: "hello", lineNumber: 0).1, "hello")

        XCTAssertEqual(split(string: "hello", lineNumber: 1).0, "hello")
        XCTAssertEqual(split(string: "hello", lineNumber: 1).1, "")

        XCTAssertEqual(split(string: "hello", lineNumber: 10).0, "hello")
        XCTAssertEqual(split(string: "hello", lineNumber: 10).1, "")
    }

    func testStringWith2Lines() {
        XCTAssertEqual(split(string: "hello\nworld", lineNumber: 0).0, "")
        XCTAssertEqual(split(string: "hello\nworld", lineNumber: 0).1, "hello\nworld")

        XCTAssertEqual(split(string: "hello\nworld", lineNumber: 1).0, "hello\n")
        XCTAssertEqual(split(string: "hello\nworld", lineNumber: 1).1, "world")

        XCTAssertEqual(split(string: "hello\nworld", lineNumber: 2).0, "hello\nworld")
        XCTAssertEqual(split(string: "hello\nworld", lineNumber: 2).1, "")

        XCTAssertEqual(split(string: "hello\nworld", lineNumber: 10).0, "hello\nworld")
        XCTAssertEqual(split(string: "hello\nworld", lineNumber: 10).1, "")
    }

    func testStringWith3Lines() {
        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 0).0, "")
        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 0).1, "hello\nworld\n!")

        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 1).0, "hello\n")
        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 1).1, "world\n!")

        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 2).0, "hello\nworld\n")
        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 2).1, "!")

        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 3).0, "hello\nworld\n!")
        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 3).1, "")

        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 10).0, "hello\nworld\n!")
        XCTAssertEqual(split(string: "hello\nworld\n!", lineNumber: 10).1, "")
    }
}
