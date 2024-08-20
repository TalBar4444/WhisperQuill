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
    
    @IBOutlet weak var post_IMG_userImage: UIImageView!
    
    @IBOutlet weak var post_LBL_username: UILabel!
    
    @IBOutlet weak var post_EDT_title: UITextField!
    
    @IBOutlet weak var post_EDT_content: UITextView!
    
    var userID: String?
    let ref = FirebaseManager.shared.getDatabaseReference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let id = FirebaseManager.shared.getCurrentUserID() else {
            print("No user is logged in")
            return
        }
        
        self.userID = id
        print("User ID successfully retrieved: \(userID ?? "None")")
        ref.child("users").child(id).observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                print("User data not found")
                return
            }
            
            
            // Retrieve the username
            if let username = userData["username"] as? String {
                self.post_LBL_username.text = username
            }
            self.post_IMG_userImage.image = UIImage(named: "user_image_1")
//            if let imageURLString = userData["userImage"] as? String, let imageURL = URL(string: imageURLString) {
//
//                // Download the image
//                self.downloadImage(from: imageURL)
//            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    

    @IBAction func createPost(_ sender: UIBarButtonItem) {

        guard let title = post_EDT_title.text else {return}
        guard let content = post_EDT_content.text else {return}
        
        if title.isEmpty || content.isEmpty {
            showErrorAlert(message: "Please fill in both fields befor publishing.")
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
        
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Faild to download image: \(error?.localizedDescription ?? "No error description")")
                return
            }
            DispatchQueue.main.async {
                self.post_IMG_userImage.image = UIImage(data: data)
            }
        }
        task.resume()
    }
//
//    func showErrorAlert() {
//        let alertController = UIAlertController(title: "Error", message: "Please fill in both fields befor publishing.", preferredStyle: .alert)
//
//        // Add an OK button to dissmis the alert
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//
//        alertController.addAction(okAction)
//
//        // Present the alert
//        present(alertController, animated: true, completion: nil)
//    }
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
