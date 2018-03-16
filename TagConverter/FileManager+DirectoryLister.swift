//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

extension FileManager: DirectoryLister {

    public func filesInDirectory(at url: URL) throws -> [URL] {

        guard existence(atUrl: url) == .directory
            else { throw DirectoryListingError.notADirectory(url) }

        let contents: [URL]

        do {
            contents = try contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsSubdirectoryDescendants, .skipsPackageDescendants])
        } catch {
            throw DirectoryListingError.listingFailed(wrapped: error)
        }

        return contents.filter { !$0.hasDirectoryPath }
    }
}
