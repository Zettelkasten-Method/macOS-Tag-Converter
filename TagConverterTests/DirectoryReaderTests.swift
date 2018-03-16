//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import TagConverter

class DirectoryReaderTests: XCTestCase {

    class DirectoryListerDouble: DirectoryLister {
        var testFiles: [URL] = []
        var testThrows: Error?
        var didRequestFilesInDirectory: URL?
        func filesInDirectory(at url: URL) throws -> [URL] {
            didRequestFilesInDirectory = url

            if let error = testThrows {
                throw error
            }

            return testFiles
        }
    }

    class NoteFactoryDouble: NoteFactory {
        var testNote: Note = Note(url: URL(fileURLWithPath: "irrelevant"), filename: "irrelevant", tags: [])
        var didRequestNote = false
        var requestedURLs: [URL] = []
        override func note(url: URL) -> Note {
            didRequestNote = true
            requestedURLs.append(url)
            return testNote
        }
    }

    class DirectoryReaderOutputDouble: DirectoryReaderOutput {
        var didDisplayNotes: [Note]?
        func display(notes: [Note]) {
            didDisplayNotes = notes
        }

        var didDisplayPath: String?
        func display(path: String) {
            didDisplayPath = path
        }
    }

    var service: DirectoryReader!

    var listerDouble: DirectoryListerDouble!
    var noteFactoryDouble: NoteFactoryDouble!
    var errorHandlerDouble: ErrorHandlerDouble!
    var outputDouble: DirectoryReaderOutputDouble!

    override func setUp() {
        super.setUp()
        listerDouble = DirectoryListerDouble()
        noteFactoryDouble = NoteFactoryDouble()
        errorHandlerDouble = ErrorHandlerDouble()
        outputDouble = DirectoryReaderOutputDouble()
        service = DirectoryReader(
            lister: listerDouble,
            noteFactory: noteFactoryDouble,
            errorHandler: errorHandlerDouble.handleError(error:),
            output: outputDouble)
    }
    
    override func tearDown() {
        service = nil
        listerDouble = nil
        noteFactoryDouble = nil
        errorHandlerDouble = nil
        outputDouble = nil
        super.tearDown()
    }

    var irrelevantURL: URL { return URL(fileURLWithPath: "irrelevant") }


    // MARK: -

    func testProcess_RequestsFilesInDirectory() {

        let url = URL(fileURLWithPath: "/the/requested/dir")

        service.process(directoryURL: url)

        XCTAssertEqual(listerDouble.didRequestFilesInDirectory, url)
    }


    // MARK: Dir Listing Error

    func testProcess_ListingThrows_DoesNotUseNoteFactory() {

        listerDouble.testThrows = TestError.irrelevant

        service.process(directoryURL: irrelevantURL)

        XCTAssertFalse(noteFactoryDouble.didRequestNote)
    }

    func testProcess_ListingThrows_DoesNotDisplayPath() {

        listerDouble.testThrows = TestError.irrelevant

        service.process(directoryURL: irrelevantURL)

        XCTAssertNil(outputDouble.didDisplayPath)
    }

    func testProcess_ListingThrows_DoesNotDisplayNotes() {

        listerDouble.testThrows = TestError.irrelevant

        service.process(directoryURL: irrelevantURL)

        XCTAssertNil(outputDouble.didDisplayNotes)
    }

    func testProcess_ListingThrows_DelegatesErrorToErrorHandler() {

        struct TheError: Error { }
        listerDouble.testThrows = TheError()

        service.process(directoryURL: irrelevantURL)

        XCTAssert(errorHandlerDouble.didHandleError is TheError)
    }


    // MARK: Empty Directory

    func testProcess_ListingReturnsEmptyDirectory_DoesNotUseNoteFactory() {

        listerDouble.testFiles = []

        service.process(directoryURL: irrelevantURL)

        XCTAssertFalse(noteFactoryDouble.didRequestNote)
    }

    func testProcess_ListingReturnsEmptyDirectory_DisplaysPath() {

        let path = "/this/is/the/path"
        listerDouble.testFiles = []

        service.process(directoryURL: URL(fileURLWithPath: path))

        XCTAssertEqual(outputDouble.didDisplayPath, path)
    }

    func testProcess_ListingReturnsEmptyDirectory_DisplaysEmptyNotes() {

        listerDouble.testFiles = []

        service.process(directoryURL: irrelevantURL)

        XCTAssertNotNil(outputDouble.didDisplayNotes)
        if let notes = outputDouble.didDisplayNotes {
            XCTAssertEqual(notes, [])
        }
    }

    func testProcess_ListingReturnsEmptyDirectory_DoesNotCallErrorHandler() {

        listerDouble.testFiles = []

        service.process(directoryURL: irrelevantURL)

        XCTAssertNil(errorHandlerDouble.didHandleError)
    }


    // MARK: One File in Directory

    func testProcess_ListingReturnsOneURL_RequestsNoteFromFactory() {

        let singleURL = URL(fileURLWithPath: "the/path")
        listerDouble.testFiles = [singleURL]

        service.process(directoryURL: irrelevantURL)

        XCTAssert(noteFactoryDouble.didRequestNote)
        XCTAssertEqual(noteFactoryDouble.requestedURLs, [singleURL])
    }

    func testProcess_ListingReturnsOneURL_DisplaysPath() {

        let path = "/this/is/the/path"
        listerDouble.testFiles = [irrelevantURL]

        service.process(directoryURL: URL(fileURLWithPath: path))

        XCTAssertEqual(outputDouble.didDisplayPath, path)
    }

    func testProcess_ListingReturnsOneURL_DisplaysResultOfNoteFactory() {

        listerDouble.testFiles = [irrelevantURL]
        let note = Note(url: URL(fileURLWithPath: "the/file"), filename: "amazing name", tags: ["great", "tags"])
        noteFactoryDouble.testNote = note

        service.process(directoryURL: irrelevantURL)

        XCTAssertNotNil(outputDouble.didDisplayNotes)
        if let notes = outputDouble.didDisplayNotes {
            XCTAssertEqual(notes, [note])
        }
    }

    func testProcess_ListingReturnsOneURL_DoesNotCallErrorHandler() {

        listerDouble.testFiles = [irrelevantURL]

        service.process(directoryURL: irrelevantURL)

        XCTAssertNil(errorHandlerDouble.didHandleError)
    }


    // MARK: Many Files in Directory

    func testProcess_ListingReturns5URLs_RequestsNotesFromFactory() {

        let urls = (1...5).map { URL(fileURLWithPath: String($0)) }
        listerDouble.testFiles = urls

        service.process(directoryURL: irrelevantURL)

        XCTAssert(noteFactoryDouble.didRequestNote)
        XCTAssertEqual(noteFactoryDouble.requestedURLs, urls)
    }

    func testProcess_ListingReturns5URLs_DisplaysPath() {

        let path = "/the/original/path"
        listerDouble.testFiles = [irrelevantURL, irrelevantURL, irrelevantURL, irrelevantURL, irrelevantURL]

        service.process(directoryURL: URL(fileURLWithPath: path))

        XCTAssertEqual(outputDouble.didDisplayPath, path)
    }

    func testProcess_ListingReturns5URLs_Displays5ResultOfNoteFactory() {

        let urls = (1...5).map { URL(fileURLWithPath: String($0)) }
        listerDouble.testFiles = urls
        let note = Note(url: URL(fileURLWithPath: "the/file"), filename: "amazing name", tags: ["great", "tags"])
        noteFactoryDouble.testNote = note

        service.process(directoryURL: irrelevantURL)

        XCTAssertNotNil(outputDouble.didDisplayNotes)
        if let notes = outputDouble.didDisplayNotes {
            XCTAssertEqual(notes, [note, note, note, note, note])
        }
    }

    func testProcess_ListingReturns5URLs_DoesNotCallErrorHandler() {

        listerDouble.testFiles = [irrelevantURL]

        service.process(directoryURL: irrelevantURL)

        XCTAssertNil(errorHandlerDouble.didHandleError)
    }

}
