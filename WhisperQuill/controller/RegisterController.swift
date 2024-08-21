//
//  RegisterController.swift
//  WhisperQuill
//
//  Created by Student31 on 17/08/2024.
//

import UIKit
import Foundation
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
        let userImage = ("fdsgdfg")//UIImage(named: "user_image_1"),
//           let base64String = userImage.toBase64String() {
//            print("Base64 String: \(base64String)")
//        }
        guard let username = register_EDT_username.text else { return }
        guard let email = register_EDT_email.text else { return }
        guard let password = register_EDT_password.text else { return }
              
        
        // Create the user email and password
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if username.isEmpty || email.isEmpty || password.isEmpty {
                self.showErrorAlert(message: "Please fill all needed fields.")
                return
            }
            
            // Successfully created the user
            guard let user = authResult?.user else { return }
            let userID = user.uid
            
            // Save the username and the userImage in the database
            let ref = Database.database().reference()
            
            let userData: [String: Any] = [
                "username" : username,
               "userImage" : userImage
            ]
            
            ref.child("users").child(userID).setValue(userData) { error, _ in
                if let error = error {
                    print("Error saving username: \(error)")
                    self.showErrorAlert(message: "Error saving username: \(error.localizedDescription)")
                }
                else {
                    print("Username saved successfully!")
                    // go to home view
                    self.performSegue(withIdentifier: "goToHomeController", sender: self)
                }
                
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

extension UIImage {
    func toBase64String() -> String? {
        guard let imageData = self.pngData() else {
            print("Failed")
            return nil
        }
        return imageData.base64EncodedString()
    }
}
