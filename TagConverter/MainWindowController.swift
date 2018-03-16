//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class MainWindowController: NSWindowController, DirectoryReaderOutput {

    convenience init() {
        self.init(windowNibName: .mainWindow)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        directoryPathLabel.isHidden = true
    }

    @IBOutlet weak var directoryPathLabel: NSTextField!
    @IBOutlet weak var changeDirectoryButton: NSButton!
    var directoryPickerHandler: ((URL) -> Void)?

    @IBAction func changeDirectory(_ sender: Any) {

        guard let directoryURL = userPickedDirectory() else { return }
        directoryPickerHandler?(directoryURL)
    }

    func display(path: String) {
        directoryPathLabel.isHidden = false
        directoryPathLabel.stringValue = path
    }
}

func userPickedDirectory() -> URL? {

    let panel = NSOpenPanel()
    panel.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    panel.canChooseFiles = false
    panel.canChooseDirectories = true
    panel.canCreateDirectories = true
    panel.allowsMultipleSelection = false
    panel.title = "Choose Directory to Convert"

    let response = panel.runModal()

    guard response == .OK else { return nil }

    return panel.urls.first
}

extension NSNib.Name {
    static var mainWindow: NSNib.Name { return .init(rawValue: "MainWindowController") }
}
