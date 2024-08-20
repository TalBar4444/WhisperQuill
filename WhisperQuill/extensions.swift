//
//  extensions.swift
//  WhisperQuill
//
//  Created by Tal Bar on 20/08/2024.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        // Add an OK button to dissmis the alert
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
}
