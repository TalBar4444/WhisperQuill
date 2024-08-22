//
//  RegisterController.swift
//  WhisperQuill
//
//  Created by Tal Bar on 17/08/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterController: UIViewController {

    @IBOutlet weak var register_EDT_username: UITextField!
    
    @IBOutlet weak var register_EDT_email: UITextField!
    
    @IBOutlet weak var register_EDT_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        let userImage = UIImage(named: "user_image_1")!
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
            
            self.uploadUserImage(image: userImage) { url in
                if let url = url {
                    self.saveUserData(userID: userID, username: username, userImageURL: url)
                } else {
                    print("failed to upload image or get download URL")
                }
            }
        }
    }
    
    func saveUserData(userID: String, username: String, userImageURL: URL) {
        // Save the username and the userImage in the database
        let ref = Database.database().reference().child("users").child(userID)
        
        // Data to save
        let userData: [String: Any] = [
            "username" : username,
            "userImage" : userImageURL.absoluteString
        ]
        
        ref.setValue(userData) { (error, _) in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            }
            else {
                print("User data saved successfully!")
                
                // go to home view
                self.performSegue(withIdentifier: "goToHomeController", sender: self)
            }
            
        }
        
    }
    

    func uploadUserImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error: could not convert image to data.")
            completion(nil)
            return
        }
        
        // Create reference to FirebaseStorage
        let storageRef = Storage.storage().reference().child("userImage/\(UUID().uuidString).jpg")
        
        //Upload the image data
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { (url, error ) in
                if let error = error {
                    print("Error fetching download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url)
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
