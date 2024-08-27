//
//  LoginController.swift
//  WhisperQuill
//
//  Created by Tal Bar on 17/08/2024.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginController: UIViewController {
   
    @IBOutlet weak var login_EDT_email: UITextField!
    
    @IBOutlet weak var login_EDT_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitClicked(_ sender: UIButton) {
        guard let email = login_EDT_email.text else { return }
        guard let password = login_EDT_password.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                self.showErrorAlert(message: "User is not exist, Please Register first")
                print("error")
            }
            else {
                // go to home view
                self.performSegue(withIdentifier: "goToHomeController", sender: self)
            }
        }
    }
    
    @IBAction func openRegisterController(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    
    }

}
