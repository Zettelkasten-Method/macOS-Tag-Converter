//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class ConversionProgressViewController: NSViewController, HashtagConverterOutput {

    @IBOutlet var progressWindow: NSWindow!
    @IBOutlet var hostingWindow: NSWindow!

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var progressLabel: NSTextField!

    var isDisplayingProgress: Bool = false {
        didSet {
            showOrHideSheet()
        }
    }

    private func showOrHideSheet() {
        if isDisplayingProgress {
            hostingWindow.beginSheet(progressWindow, completionHandler: nil)
        } else {
            hostingWindow.endSheet(progressWindow)
        }
    }

    func displayProgress(current: Int, total: Int) {

        isDisplayingProgress = true

        progressIndicator.maxValue = Double(total)
        progressIndicator.doubleValue = Double(current)

        progressLabel.stringValue = "Processing \(current) / \(total) Files"
    }

    func finishConversion(errors: [Error]) {

        isDisplayingProgress = false
    }
}
