//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import TagConverter

class FileManager_DirectoryListerTests: XCTestCase {

    var directoryLister: DirectoryLister { return FileManager.default }

    func testFiles_NonexistingURL_Throws() {

        let url = generatedTempFileURL()

        do {
            _ = try directoryLister.filesInDirectory(at: url)
            XCTFail("expected to throw")
        } catch let error as DirectoryListingError {
            switch error {
            case .notADirectory(let errorURL): XCTAssertEqual(url, errorURL)
            default: XCTFail("wrong kind of error")
            }
        } catch {
            XCTFail("wrong kind of error")
        }
    }

    func testFiles_FileAtURL_Throws() {

        let url = createTempFileURL()

        do {
            _ = try directoryLister.filesInDirectory(at: url)
            XCTFail("expected to throw")
        } catch let error as DirectoryListingError {
            switch error {
            case .notADirectory(let errorURL): XCTAssertEqual(url, errorURL)
            default: XCTFail("wrong kind of error")
            }
        } catch {
            XCTFail("wrong kind of error")
        }
    }

    func testFiles_EmptyDirectory_ReturnsEmptyArray() {

        let url = createTempDirectory()

        var results: [URL]?
        expectNoError {
            results = try directoryLister.filesInDirectory(at: url)
        }

        XCTAssertNotNil(results)
        if let results = results {
            XCTAssert(results.isEmpty)
        }
    }

    func testFiles_FilesInDirectory_ReturnsURLs() {

        let directoryUrl = createTempDirectory()
        let firstFileUrl = directoryUrl.appendingPathComponent("file1")
        let secondFileUrl = directoryUrl.appendingPathComponent("file2")
        touch(url: firstFileUrl)
        touch(url: secondFileUrl)

        var results: [URL]?
        expectNoError {
            results = try directoryLister.filesInDirectory(at: directoryUrl)
        }

        XCTAssertNotNil(results)
        if let results = results?.map({ $0.resolvingSymlinksInPath() }) {
            XCTAssertEqual(results.count, 2)
            XCTAssert(results.contains(firstFileUrl))
            XCTAssert(results.contains(secondFileUrl))
        }
    }
}
