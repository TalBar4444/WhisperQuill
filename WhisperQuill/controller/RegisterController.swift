//
//  RegisterController.swift
//  WhisperQuill
//
//  Created by Student31 on 17/08/2024.
//

import UIKit
import Firebase

class RegisterController: UIViewController {

    @IBOutlet weak var register_EDT_username: UITextField!
    
    
    @IBOutlet weak var register_EDT_email: UITextField!
    
    
    @IBOutlet weak var register_EDT_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        guard let email = register_EDT_email.text else { return }
        guard let password = register_EDT_password.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                print("error")
            }
            else {
                // go to home view
                self.performSegue(withIdentifier: "goToHomeController", sender: self)
            }
        }
    }

   
    @IBAction func openLoginController(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
        self.dismiss(animated: false, completion: nil)
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
