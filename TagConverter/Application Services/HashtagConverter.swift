//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation

protocol HashtagConverterOutput {
    func displayProgress(current: Int, total: Int)
    func finishConversion()
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
            for (index, note) in conversion.notes.enumerated() {
                self.noteConverter.process(note: note, conversion: conversion)
                DispatchQueue.main.async { self.output.displayProgress(current: index, total: total) }
            }
            DispatchQueue.main.async { self.output.finishConversion() }
        }
    }
}

class NoteConverter {
    func process(note: Note, conversion: Conversion) {

    }
}