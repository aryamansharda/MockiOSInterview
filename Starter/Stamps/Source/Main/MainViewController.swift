import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Object Outlets
    @IBOutlet private var stampButtons: [UIButton]!
    
    // MARK: - Private Objects
    private var selectedColor: UIColor = .black
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
}

// MARK: - Helper Methods
private extension MainViewController {
    func updateButtonColors(selectedButton: UIButton) {
        
        // Deselect all the color buttons.
        stampButtons.forEach { $0.alpha = 1.0 }
        
        // Select the relevant color button.
        selectedButton.alpha = 0.8
    }
}
