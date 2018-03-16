//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import TagConverter

class FileManager_ExistenceTests: XCTestCase {

    func testExistence_NonExistingFile() {

        let url = generatedTempFileURL()
        XCTAssertEqual(FileManager.default.existence(atUrl: url), FileExistence.none)
    }

    func testExistence_ExistingFile() {

        let url = generatedTempFileURL()

        guard let _ = try? "some content".write(to: url, atomically: false, encoding: .utf8)
            else { XCTFail("writing failed"); return }
        XCTAssertEqual(FileManager.default.existence(atUrl: url), FileExistence.file)
    }

    func testExistence_ExistingDirectory() {

        let url = createTempDirectory()
        XCTAssertEqual(FileManager.default.existence(atUrl: url), FileExistence.directory)
    }

}
