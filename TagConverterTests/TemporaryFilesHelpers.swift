//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

func touch(url: URL) {
    try! "".write(to: url, atomically: false, encoding: .utf8)
}

func generatedTempDirectoryURL() -> URL {

    let fileName = "minnv-temp-dir.\(UUID().uuidString)"
    return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName, isDirectory: true)
}

func createTempDirectory() -> URL {

    let fileUrl = generatedTempDirectoryURL()

    try! FileManager.default.createDirectory(at: fileUrl, withIntermediateDirectories: false, attributes: nil)

    return fileUrl
}

func generatedTempFileURL(ext: String? = nil) -> URL {

    let fileName = generatedFileName(ext: ext)
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)

    return fileURL
}

func generatedFileName(ext: String? = nil) -> String {

    let fileExtension: String
    if let ext = ext {
        fileExtension = ".\(ext)"
    } else {
        fileExtension = ""
    }

    return "minnv-temp.\(UUID().uuidString)\(fileExtension)"
}

func createTempFileURL(content: String = "irrelevant content", ext: String? = nil) -> URL {

    let url = generatedTempFileURL(ext: ext)
    try! content.write(to: url, atomically: true, encoding: .utf8)
    return url
}
