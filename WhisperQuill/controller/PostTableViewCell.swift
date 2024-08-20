//
//  PostTableViewCell.swift
//  WhisperQuill
//
//  Created by Tal Bar on 20/08/2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var home_LBL_username: UILabel!
    @IBOutlet var home_IMG_userImage: UIImageView!
    @IBOutlet var home_LBL_title: UILabel!
    @IBOutlet var home_LAY_content: UITextView!
    @IBOutlet var home_LBL_likes: UILabel!
    
    static let identifier = "PostTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
                          
    func configure(with model: Post) {
        self.home_LBL_username.text = model.username
        self.home_IMG_userImage.image = UIImage(named: model.userImage)
        self.home_LBL_title.text = model.title
        self.home_LAY_content.text = model.content
        self.home_LBL_likes.text = "\(model.numberOfLikes) Likes"
        
    }
    
}
