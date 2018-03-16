//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class NotesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!

    private var notes: [Note] = [] {
        didSet {
            guard isViewLoaded else { return }
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func display(notes: [Note]) {
        self.notes = notes
    }

    // MARK: Table View Population

    func numberOfRows(in tableView: NSTableView) -> Int {
        return notes.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let note = notes[safe: row] else { return nil }
        guard let cellView = noteTableCellView(tableView: tableView, tableColumn: tableColumn) else { return nil }

        cellView.display(note: note)

        return cellView
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return notes[safe: row]?.tags.isNotEmpty ?? false
    }

    private func noteTableCellView(tableView: NSTableView, tableColumn: NSTableColumn?) -> NoteTableCellView? {

        switch tableColumn?.identifier {
        case .some(.filenameColumn):
            return tableView.makeView(withIdentifier: .filenameCellView, owner: self) as? FilenameTableCellView

        case .some(.tagsColumn):
            return tableView.makeView(withIdentifier: .tagsCellView, owner: self) as? TagsTableCellView

        case .none,
             .some(_):
            return nil
        }
    }
}

extension Array {
    var isNotEmpty: Bool { return !isEmpty }
}

extension NSUserInterfaceItemIdentifier {

    static var filenameColumn: NSUserInterfaceItemIdentifier { return .init("Filenames") }
    static var filenameCellView: NSUserInterfaceItemIdentifier { return .init("FilenameCell") }

    static var tagsColumn: NSUserInterfaceItemIdentifier { return .init("Tags") }
    static var tagsCellView: NSUserInterfaceItemIdentifier { return .init("TagsCell") }
}
