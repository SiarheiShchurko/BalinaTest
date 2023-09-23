
import UIKit

extension UIViewController {
    func showAlert(message: String) {
        // # 1
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)
        // # 2
        let startAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(startAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
