
import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Object Outlets
    @IBOutlet private var stampButtons: [UIButton]!
    @IBOutlet private var undoButton: UIBarButtonItem!
    @IBOutlet private var redoButton: UIBarButtonItem!
    
    // MARK: - Private Objects
    private var selectedColor: UIColor = .black
    private var colorCount: [UIColor: Int] = [:]
    private var undoLabels: [UILabel] = []
    private var redoLabels: [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        updateUndoButtonState()
        updateRedoButtonState()
    }
}

// MARK: - Action Outlets
private extension MainViewController {
    @IBAction func stampTapped(_ sender: UIButton) {
        
        // Extract stamp color from the buttons background color.
        guard let stampColor = sender.backgroundColor else {
            return
        }
        
        // Update internal values.
        selectedColor = stampColor
        updateButtonColors(selectedButton: sender)
    }
    
    @IBAction func undoPressed(_ sender: UIBarButtonItem) {
        // Grab last label from the array.
        guard let lastLabel = undoLabels.popLast() else {
            return
        }
        
        redoLabels.append(lastLabel)
        
        // Update hash count.
        if let labelColor = lastLabel.backgroundColor, let count = colorCount[labelColor] {
            colorCount[labelColor] = count - 1
        }
        
        // Remove subview.
        lastLabel.removeFromSuperview()
        
        // Set state of buttons.
        updateUndoButtonState()
        updateRedoButtonState()
    }
    
    @IBAction func redoPressed(_ sender: UIBarButtonItem) {
        // Grab last label from the array.
        guard let lastLabel = redoLabels.popLast() else {
            return
        }
        
        // Add redo label back to the undo list of labels.
        undoLabels.append(lastLabel)
        
        // Update hash count.
        if let labelColor = lastLabel.backgroundColor, let count = colorCount[labelColor] {
            colorCount[labelColor] = count + 1
        }
        
        // Remove subview.
        view.addSubview(lastLabel)
        
        // Set state of buttons.
        updateUndoButtonState()
        updateRedoButtonState()
    }

}

// MARK: - Helper Methods
private extension MainViewController {
    func updateButtonColors(selectedButton: UIButton) {
        
        // Deselect all the color buttons.
        stampButtons.forEach { $0.alpha = 1.0 }
        
        // Select the relevant color button.
        selectedButton.alpha = 0.8
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        addSquare(with: selectedColor, at: sender.location(in: view))
    }
    
    func addSquare(with color: UIColor, at location: CGPoint) {
        let squareLabel = UILabel(frame: CGRect(x: location.x, y: location.y, width: 50.0, height: 50.0))
        squareLabel.backgroundColor = selectedColor
        squareLabel.textAlignment = .center
        squareLabel.textColor = .white
        
        if let existingColorCount = colorCount[selectedColor] {
            colorCount[selectedColor] = existingColorCount + 1
            squareLabel.text = String(existingColorCount + 1)
        } else {
            squareLabel.text = "1"
            colorCount[selectedColor] = 1
        }
        view.addSubview(squareLabel)
        undoLabels.append(squareLabel)
        
        updateUndoButtonState()
        updateRedoButtonState()
    }
    
    func updateUndoButtonState() {
        if undoLabels.isEmpty, undoButton.isEnabled {
            undoButton.isEnabled = false
        } else if !undoLabels.isEmpty, !undoButton.isEnabled {
            undoButton.isEnabled = true
        }
    }
    
    func updateRedoButtonState() {
        if redoLabels.isEmpty, redoButton.isEnabled {
            redoButton.isEnabled = false
        } else if !redoLabels.isEmpty, !redoButton.isEnabled {
            redoButton.isEnabled = true
        }
    }
}
