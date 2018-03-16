//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

protocol TagReader {
    func tags(url: URL) -> [String]
}

class NoteFactory {
    let tagReader: TagReader

    init(tagReader: TagReader = MetadataTagReader()) {
        self.tagReader = tagReader
    }

    func note(url: URL) -> Note {
        return Note(url: url,
                    filename: url.filename,
                    tags: tagReader.tags(url: url))
    }
}

class MetadataTagReader: TagReader {
    func tags(url: URL) -> [String] {
        guard let item = NSMetadataItem(url: url) else { return [] }
        guard let tags = item.value(forAttribute: "kMDItemUserTags") as? [String] else { return [] }
        return tags
    }
}

extension URL {
    /// File name without path extension of the last path component.
    var filename: String {
        return (self.lastPathComponent as NSString)
            .deletingPathExtension
            // Favor simple characters over combined grapheme clusters
            .precomposedStringWithCanonicalMapping
    }
}
