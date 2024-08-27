//
//  HomeController.swift
//  WhisperQuill
//
//  Created by Tal Bar on 17/08/2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreatePostDelegate {


    func didCreatePost(_ post: Post) {
        self.models.append(post)
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
     
     
    @IBOutlet var table: UITableView!
    
    var models = [Post]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        fetchPosts { posts in
            self.models = posts
            print("Model updated: \(self.models)")
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        
    }
    
    
    
    @IBAction func openCreatePoemController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let createPostVC = storyboard.instantiateViewController(withIdentifier: "CreatePostController") as? CreatePostController {
            createPostVC.delegate = self
            self.present(createPostVC, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(models.count)
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let post = models[indexPath.row]
        cell.configure(with: post)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80 + 110 + view.frame.size.width
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        let ref = Database.database().reference().child("posts")

        ref.observeSingleEvent(of: .value) { snapshot in
        var fetchedPosts: [Post] = []

        for child in snapshot.children {
            if let postSnapshot = child as? DataSnapshot,
                let postDict = postSnapshot.value as? [String: Any],
                let userID = postDict["userID"] as? String,
                let title = postDict["title"] as? String,
                let content = postDict["content"] as? String,
                let likes = postDict["likes"] as? Int,
                let timestamp = postDict["timestamp"] as? Int {
                
                self.fetchUserDetails(userID: userID) { username, userImage in
                        let post = Post(userID: userID,
                                        username: username,
                                        userImage: userImage,
                                        title: title,
                                        content: content,
                                        likes: likes,
                                        timestamp: timestamp)
                        fetchedPosts.append(post)
                        
                    fetchedPosts.sort(by: { $1.timestamp > $0.timestamp })
                       // print("Fetched post: \(fetchedPosts)")
                        completion(fetchedPosts)
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
                print("User details: \(username), \(userImage)")
                completion(username, userImage)
            } else {
                print("Failed to fetch useer details for userID: \(userID)")
                completion("Unknown", "")
            }
        }
    }
    
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error)")
                // Handle error (e.g., show an alert)
            } else {
                // Successfully signed in, navigate to HomeController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as? HomeController {
                    self.present(homeVC, animated: true, completion: nil)
                }
            }
        }
    }
}


struct Post {
    let userID: String
    let username: String
    let userImage: String
    let title: String
    let content: String
    let likes: Int
    let timestamp: Int
}
