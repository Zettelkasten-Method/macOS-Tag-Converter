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
        closeButton.isEnabled = false

        updateProgress(current: current, total: total)
    }

    /// Cache used to display the final state.
    private var lastTotal = 0

    private func updateProgress(current: Int, total: Int) {
        lastTotal = total

        progressIndicator.maxValue = Double(total)
        progressIndicator.doubleValue = Double(current)

        progressLabel.stringValue = "Processing \(current) / \(total) Files"
    }

    @IBOutlet var resultTextView: NSTextView!

    func finishConversion(errors: [Error]) {

        updateProgress(current: lastTotal, total: lastTotal)
        
        resultTextView.string = errors
            .map(String.init(describing:))
            .joined(separator: "\n\n")

        closeButton.isEnabled = true
        progressWindow.makeFirstResponder(closeButton)
    }

    @IBOutlet weak var closeButton: NSButton!

    @IBAction func close(_ sender: Any) {
        isDisplayingProgress = false
    }
}
