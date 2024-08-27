//
//  CreatePoemsController.swift
//  WhisperQuill
//
//  Created by Tal Bar on 18/08/2024.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabaseInternal

class CreatePostController: UIViewController {
    
    weak var delegate: CreatePostDelegate?
    
    @IBOutlet weak var post_IMG_userImage: UIImageView!
    
    @IBOutlet weak var post_LBL_username: UILabel!
    
    @IBOutlet weak var post_EDT_title: UITextField!
    
    @IBOutlet weak var post_EDT_content: UITextView!
    
    var userID: String?
    let ref = FirebaseManager.shared.getDatabaseReference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDetails()
    }
    
    func loadUserDetails() {
            guard let userID = Auth.auth().currentUser?.uid else {
                print("No user is logged in")
                return
            }
            
            let ref = Database.database().reference().child("users").child(userID)
            
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let userDict = snapshot.value as? [String: Any] else {
                    print("User data not found")
                    return
                }
                
                if let username = userDict["username"] as? String {
                    self.post_LBL_username.text = username
                }
                
                if let imageURLString = userDict["userImage"] as? String, let imageURL = URL(string: imageURLString) {
                    self.downloadImage(from: imageURL)
                }
            }
        }
        
        func downloadImage(from url: URL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Failed to download image: \(error?.localizedDescription ?? "No error description")")
                    return
                }
                DispatchQueue.main.async {
                    self.post_IMG_userImage.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    
    @IBAction func createPost(_ sender: UIBarButtonItem){

        guard let title = post_EDT_title.text, !title.isEmpty,
        let content = post_EDT_content.text, !content.isEmpty else {
            showErrorAlert(message: "Please fill in both fields befor publishing.")
            return
        }
        
        addPostToDatabase(title: title, content: content)
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func addPostToDatabase(title: String, content: String) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference()
        let postID = ref.child("posts").childByAutoId().key
        
        if let postID = postID {
            let postData: [String: Any] = [
                "userID": userID,
                "title": title,
                "content": content,
                "likes": 0,
                "timestamp": Int(Date().timeIntervalSince1970)
            ]
           
            ref.child("posts").child(postID).setValue(postData) { error, _ in
                if let error = error {
                    print("error saving post: \(error)")
                } else {
                    print("Post added successfully")
                    
                    self.fetchUserDetails(userID: userID) { username, userImage in
                        let post = Post(userID: userID,
                                        username: username,
                                        userImage: userImage,
                                        title: title,
                                        content: content,
                                        likes: 0,
                                        timestamp: Int(Date().timeIntervalSince1970))
                        self.delegate?.didCreatePost(post)
                    }
                }
            }
        }
        
    }
        
    func fetchUserDetails(userID: String, completion: @escaping (String, String) -> Void) {
           let ref = Database.database().reference().child("users").child(userID)
           
           ref.observeSingleEvent(of: .value) { snapshot in
               if let userDict = snapshot.value as? [String: Any],
                  let username = userDict["username"] as? String,
                  let userImage = userDict["userImage"] as? String {
                   completion(username, userImage)
               } else {
                   completion("Unknown", "")
               }
           }
       }

}
