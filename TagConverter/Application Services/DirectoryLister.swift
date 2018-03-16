//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import struct Foundation.URL

protocol DirectoryLister {
    /// - throws: `DirectoryListingError`
    func filesInDirectory(at url: URL) throws -> [URL]
}

enum DirectoryListingError: Error {
    case notADirectory(URL)
    case listingFailed(wrapped: Error)
}
