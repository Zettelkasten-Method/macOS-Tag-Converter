//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

protocol DirectoryReaderOutput {
    func display(path: String)
    func display(notes: [Note])
}

struct Note: Equatable {
    let url: URL
    let filename: String
    let tags: [String]
    var hasTags: Bool { return tags.isNotEmpty }
}

func ==(lhs: Note, rhs: Note) -> Bool {

    return lhs.url == rhs.url
        && lhs.filename == rhs.filename
        && lhs.tags == rhs.tags
}

class DirectoryReader {

    let lister: DirectoryLister
    let noteFactory: NoteFactory
    let output: DirectoryReaderOutput
    let errorHandler: (Error) -> Void

    init(
        lister: DirectoryLister = FileManager.default,
        noteFactory: NoteFactory = NoteFactory(),
        errorHandler: @escaping (Error) -> Void,
        output: DirectoryReaderOutput) {

        self.lister = lister
        self.noteFactory = noteFactory
        self.errorHandler = errorHandler
        self.output = output
    }

    func process(directoryURL: URL) {
        do {
            let fileURLs = try lister.filesInDirectory(at: directoryURL)
            let notes = fileURLs
                .sorted { $0.filename < $1.filename     }
                .map(noteFactory.note(url:))
            output.display(path: directoryURL.path)
            output.display(notes: notes)
        } catch {
            errorHandler(error)
        }
    }
}
