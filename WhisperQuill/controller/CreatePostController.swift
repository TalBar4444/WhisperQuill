//
//  CreatePoemsController.swift
//  WhisperQuill
//
//  Created by Student31 on 18/08/2024.
//

import UIKit
import Firebase
import FirebaseDatabaseInternal

class CreatePostController: UIViewController {
    
    @IBOutlet weak var post_EDT_title: UITextField!
    
    @IBOutlet weak var post_EDT_content: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createPost(_ sender: UIBarButtonItem) {
//        let title = post_EDT_title.text ?? ""
        guard let title = post_EDT_title.text else {return}
        guard let content = post_EDT_content.text else {return}
        
        if title.isEmpty || content.isEmpty {
            showErrorAlert()
        }
        else {
            addPostToDatabase(title: title, content: content)
            self.dismiss(animated: true, completion: nil)
        }
      
        
    }
    
    func addPostToDatabase(title: String, content: String) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference()
        let postID = ref.child("users").child(userID).child("posts").childByAutoId().key
        
        if let postID = postID {
            let postData: [String: Any] = [
                "title": title,
                "content": content,
                "likes": 0,
                "timestamp": [".sv": "timestamp"]
            ]
            ref.child("users").child(userID).child("posts").child(postID).setValue(postData) { error, _ in
                if let error = error {
                    print("error saving post: \(error)")
                } else {
                    print("Post added successfully")
                }
                
            }
        }
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please fill in both fields befor publishing.", preferredStyle: .alert)
        
        // Add an OK button to dissmis the alert
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
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
