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
    
    
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let RegisterController = storyboard.instantiateViewController(withIdentifier: "RegisterController") as? RegisterController {
//            self.present(RegisterController,animated: false, completion: nil)
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
