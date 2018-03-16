//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class NoteTableCellView: NSTableCellView {
    /// Last displayed `Note`.
    private(set) var note: Note?

    /// The default implementation sets the `note` property
    /// and colors the text view disabled when no tags are present.
    func display(note: Note) {
        self.note = note
        self.textField?.textColor = note.tags.isEmpty ? NSColor.disabledControlTextColor : nil
    }
}

class FilenameTableCellView: NoteTableCellView {
    override func display(note: Note) {
        super.display(note: note)
        textField?.stringValue = note.filename
    }
}

class TagsTableCellView: NoteTableCellView {
    override func display(note: Note) {
        super.display(note: note)
        textField?.stringValue = note.tags.joined(separator: ", ")
    }
}
