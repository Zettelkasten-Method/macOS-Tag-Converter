//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

protocol HashtagConverterOutput {
    func displayProgress(current: Int, total: Int)
    func finishConversion(errors: [Error])
}

struct Conversion {
    let notes: [Note]
    let insertMissingHashtagsOnly: Bool
    let hashtagPlacement: HashtagPlacement
}

enum HashtagPlacement {
    case append
    case atLine(Int)
}

class HashtagConverter {
    let noteConverter: NoteConverter
    let output: HashtagConverterOutput

    init(
        noteConverter: NoteConverter = NoteConverter(),
        output: HashtagConverterOutput) {

        self.noteConverter = noteConverter
        self.output = output
    }

    func process(conversion: Conversion) {
        let total = conversion.notes.count

        DispatchQueue.global(qos: .utility).async {
            var errors: [Error] = []
            for (index, note) in conversion.notes.enumerated() {
                do {
                    try self.noteConverter.process(note: note, conversion: conversion)
                } catch {
                    errors.append(error)
                }
                DispatchQueue.main.async { self.output.displayProgress(current: index, total: total) }
            }
            DispatchQueue.main.async { self.output.finishConversion(errors: errors) }
        }
    }
}

class NoteConverter {
    func process(note: Note, conversion: Conversion) throws {

        guard note.hasTags else { return }
        
        var encoding: String.Encoding = .utf8
        var content = try String(contentsOf: note.url, usedEncoding: &encoding)
        let hashtags = note.tags.map { "#\($0)" }

        let haystack = content.lowercased()
        let missingHashtags: [String] = hashtags.filter { !haystack.contains($0.lowercased()) }

        guard missingHashtags.isNotEmpty else { return }

        let hashtagLine = missingHashtags.joined(separator: " ")

        switch conversion.hashtagPlacement {
        case .append: content = content + "\n\n\(hashtagLine)\n"
        case .atLine(let lineNumber):
            let (before, after) = split(string: content, lineNumber: max(lineNumber, 1) - 1)
            content = before + "\(hashtagLine)\n" + after
        }

        try content.write(to: note.url, atomically: false, encoding: encoding)
    }
}

func split(string: String, lineNumber: Int) -> (String, String) {

    var top: [String] = []
    var bottom: [String] = []

    var i = 0
    var collectToTop = true
    string.enumerateLines { (line, _) in
        if i == lineNumber { collectToTop = false }
        if collectToTop {
            top.append(line)
        } else {
            bottom.append(line)
        }
        i += 1
    }

    // Append empty line if there was a split in order to end the top with a `\n`
    if top.isNotEmpty && bottom.isNotEmpty { top.append("") }

    return (top.joined(separator: "\n"),
            bottom.joined(separator: "\n"))
}
