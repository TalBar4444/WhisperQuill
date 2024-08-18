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
        let user = "User1" //Auth.auth().currentUser.u
        guard let title = post_EDT_title.text else {return}
        guard let content = post_EDT_content.text else {return}
        addPostToDatabase(userID: user, title: title, content: content)
    }
    
    func addPostToDatabase(userID: String, title: String, content: String) {
        let ref = Database.database().reference()
        let postID = ref.child("posts").childByAutoId().key
        
        if let postID = postID {
            ref.child("posts").child(postID).setValue([
                "userID": userID,
                "title": title,
                "content": content,
                "likes": 0,
                "timestamp": [".sv": "timestamp"]
            ]) { error, _ in
                if let error = error {
                    print("error")
                } else {
                    print("Post added successfully")
                }
                
            }
        }
    }
    
//    var ref: DataReference!
//    ref = Database.database().reference()
//    ref.child
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
