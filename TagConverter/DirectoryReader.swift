//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

protocol DirectoryReaderOutput {
    func display(path: String)
}

class DirectoryReader {

    let output: DirectoryReaderOutput

    init(output: DirectoryReaderOutput) {
        self.output = output
    }

    func process(directoryURL: URL) {
        output.display(path: directoryURL.path)
    }
}
