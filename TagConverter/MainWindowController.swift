//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class MainWindowController: NSWindowController {

    convenience init() {
        self.init(windowNibName: .mainWindow)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBOutlet weak var directoryPathLabel: NSTextField!
    @IBOutlet weak var changeDirectoryButton: NSButton!

    @IBAction func changeDirectory(_ sender: Any) {
        return
    }
}

extension NSNib.Name {
    static var mainWindow: NSNib.Name { return .init(rawValue: "MainWindowController") }
}
