//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var windowController: MainWindowController = MainWindowController()
    lazy var directoryReader: DirectoryReader = {
        return DirectoryReader(
            errorHandler: { NSAlert(error: $0).runModal() },
            output: self.windowController)
    }()
    lazy var converter: HashtagConverter = HashtagConverter(output: self.windowController)

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        windowController.directoryPickerHandler = { [weak directoryReader] in
            directoryReader?.process(directoryURL: $0)
        }
        windowController.conversionHandler = { [weak converter] in
            converter?.process(conversion: $0)
        }

        windowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        windowController.showWindow(nil)
        return true
    }

}

