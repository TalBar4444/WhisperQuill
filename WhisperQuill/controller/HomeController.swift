//
//  HomeController.swift
//  WhisperQuill
//
//  Created by Tal Bar on 17/08/2024.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     
    @IBOutlet var table: UITableView!
    
    var models = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
//        models = [
//            Post(username: "Test User", userImage: "defaultImage", title: "Test Title", content: "Test Content", numberOfLikes: 5, timestamp: Int(Date().timeIntervalSince1970))
//        ]
        
        fetchPosts { posts in
            self.models = posts
            print("Model updated: \(self.models)")
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
//        models.append(Post(username: "TalBar",
//                           userImage: "user_image_1",
//                           title: "yes",
//                           content: "Stringgnonono /n no nofhfdfdhfdhfdfdhf",
//                           numberOfLikes: 40))
//        models.append(Post(username: "TYossi",
//                           userImage: "user_image_1",
//                           title: "My song",
//                           content: "poems is fun",
//                           numberOfLikes: 200))
//        models.append(Post(username: "the poet",
//                           userImage: "user_image_2",
//                           title: "Whay is a poet",
//                           content: "Stringgdghdfbdffdgdfhdfhfdfdhfdhfdfdhf",
//                           numberOfLikes: 0))
    }
    
    @IBAction func openCreatePoemController(_ sender: Any) {
        
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
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
//        cell.configure(with: models[indexPath.row])
//        return cell
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {
//            return UITableViewCell()
//        }
//        let post = models[indexPath.row]
//        cell.configure(with: post)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80 + 110 + view.frame.size.width
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    func fetchPosts(completion: @escaping([Post]) -> Void) {
//
//        let mockPost = Post(userID: "userID",
//                            username: "username",
//                            userImage: "userImage",
//                            title: "title",
//                            content: "content",
//                            numberOfLikes: 42,
//                            timestamp: Int(Date().timeIntervalSince1970))
//
//        completion([mockPost])
//   }

        let ref = Database.database().reference().child("posts")

        ref.observeSingleEvent(of: .value) { snapshot in
            print("Snapshot: \(snapshot)")

            if snapshot.exists() {
                var fetchedPosts: [Post] = []


                for child in snapshot.children {
                    if let postSnapshot = child as? DataSnapshot {
                        print("Child snapshot: \(postSnapshot)")
                        
                        if let postDict = postSnapshot.value as? [String: Any] {
                            print("Pst dict: \(postDict)")
                            
                            if let userID = postDict["userID"] as? String,
                               let title = postDict["title"] as? String,
                               let content = postDict["content"] as? String,
                               let numberOfLikes = postDict["numberOfLikes"] as? Int,
                               let timestamp = postDict["timestamp"] as? Int {
                                
                                print("Fetched post Data: \(postDict)")
                                
                                self.fetchUserDetails(userID: userID) { username, userImage in
                                    let post = Post(userID: userID,
                                                    username: username,
                                                    userImage: userImage,
                                                    title: title,
                                                    content: content,
                                                    numberOfLikes: numberOfLikes,
                                                    timestamp: timestamp)
                                    fetchedPosts.append(post)
                                    
                                    fetchedPosts.sort(by: { $0.timestamp > $1.timestamp })
                                    print("Fetched post: \(fetchedPosts)")
                                    
                                    completion(fetchedPosts)
                                }
                                
                            } else {
                                print("Post data missin require fields: \(postDict)")
                            }
                        } else {
                            print("Invalid post snapshot value: \(postSnapshot.value ?? "No value")")
                        }
                    } else {
                        print("Invalid child snapshot: \(child)")
                    }
                }
            } else {
                print("No posts found")
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
    

}

struct Post {
    let userID: String
    let username: String
    let userImage: String
    let title: String
    let content: String
    let numberOfLikes: Int
    let timestamp: Int
}
