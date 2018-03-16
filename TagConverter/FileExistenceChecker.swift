//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

protocol FileExistenceChecker {
    func existence(atUrl url: URL) -> FileExistence
}

enum FileExistence: Equatable {
    case none
    case file
    case directory
}

func ==(lhs: FileExistence, rhs: FileExistence) -> Bool {

    switch (lhs, rhs) {
    case (.none, .none),
         (.file, .file),
         (.directory, .directory):
        return true

    default: return false
    }
}
