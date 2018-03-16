//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class ConversionViewController: NSViewController {

    var conversionHandler: ((Conversion) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        insertMissingHashtagsOnly = true

        appendHashtagsRadioButton.state = .on
        hashtagPlacement = .append
        updateLinePlacementControls()
    }


    // MARK: Conversion

    /// Local cache of displayed notes
    private var notes: [Note] = []

    func display(notes: [Note]) {
        self.notes = notes
    }

    @IBAction func convert(_ sender: Any) {

        let conversion = Conversion(
            notes: notes,
            insertMissingHashtagsOnly: insertMissingHashtagsOnly,
            hashtagPlacement: hashtagPlacement)
        conversionHandler?(conversion)
    }


    // MARK: Insert Missing Hashtags Only

    var insertMissingHashtagsOnly = true

    @IBAction func changeInsertMissingHashtagsOnly(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        insertMissingHashtagsOnly = (button.state == .on)
    }


    // MARK: Hashtag placement

    @IBOutlet weak var appendHashtagsRadioButton: NSButton!
    @IBOutlet weak var insertAtLineRadioButton: NSButton!

    var hashtagPlacement: HashtagPlacement = .append

    @IBOutlet weak var lineTextField: NSTextField!
    @IBOutlet weak var lineStepper: NSStepper!

    @objc dynamic var lineNumber: Int = 1 {
        didSet {
            hashtagPlacement = .atLine(lineNumber)
        }
    }

    @IBAction func changeHashtagPlacement(_ sender: Any) {
        self.hashtagPlacement = {
            if insertAtLineRadioButton.state == .on {
                return .atLine(lineNumber)
            } else {
                return .append
            }
        }()

        updateLinePlacementControls()
    }

    private func updateLinePlacementControls() {

        let isPlacingAtLine: Bool = {
            if case .atLine = hashtagPlacement { return true }
            return false
        }()

        lineTextField.isEnabled = isPlacingAtLine
        lineStepper.isEnabled = isPlacingAtLine
    }
}
