//
//  HomeController.swift
//  WhisperQuill
//
//  Created by Tal Bar on 17/08/2024.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     
    @IBOutlet var table: UITableView!
    
    var models = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)

        table.delegate = self
        table.dataSource = self
        models.append(Post(username: "TalBar",
                           userImage: "user_image_1",
                           title: "yes",
                           content: "Stringgnonono /n no nofhfdfdhfdhfdfdhf",
                           numberOfLikes: 40))
        models.append(Post(username: "TYossi",
                           userImage: "user_image_1",
                           title: "My song",
                           content: "poems is fun",
                           numberOfLikes: 200))
        models.append(Post(username: "the poet",
                           userImage: "user_image_2",
                           title: "Whay is a poet",
                           content: "Stringgdghdfbdffdgdfhdfhfdfdhfdhfdfdhf",
                           numberOfLikes: 0))
    }
    
    @IBAction func openCreatePoemController(_ sender: Any) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
//        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80 + 110 + view.frame.size.width
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    

}

struct Post {
    let username: String
    let userImage: String
    let title: String
    let content: String
    let numberOfLikes: Int
}
