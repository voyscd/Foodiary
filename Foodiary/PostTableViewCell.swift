//
//  PostTableViewCell.swift
//  Foodiary
//
//  Created by wjw on 21/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageThumbnail: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var totalLikesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var commentButton: UIButton!
    @IBAction func commentAction(sender: AnyObject) {
    }
    
    var post: Post!
    var likeRef: Firebase!
    
    func configureCell(post: Post) {
        self.post = post
        
        // Convert the base64string to image
        let base64String = post.postImage
        
        //let  = self.convertBase64ToImage(base64String)
        
        // Set the labels and textView.
        
        self.feedImage.image = self.convertBase64ToImage(base64String)
        self.captionTextView.text = post.postCaption
        self.totalLikesLabel.text = "\(post.postLikes) Likes"
        self.usernameLabel.text = post.username
        if post.postCategory == "Menu" {
            self.categoryImage.image = UIImage(named: "menu")
            self.categoryLabel.text = "I'm from the Menu"
        }
        if post.postCategory == "Homemade" {
            self.categoryImage.image = UIImage(named: "homemade")
            self.categoryLabel.text = "I'm Home made"
        }
        if post.postCategory == "Barcode" {
            self.categoryImage.image = UIImage(named: "barcode2")
            self.categoryLabel.text = "I have a Barcode"
        }
        
        
        // Set "likes" as a child of the current user in Firebase and save the post's key in likes as a boolean.
        
        likeRef = CURRENT_USER.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        // observeSingleEventOfType() listens for the thumb to be tapped, by any user, on any device.
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // Set the like image.
            
            if let like = snapshot.value as? NSNull {
                
                // Current user hasn't liked for the post yet.
                
                print(like)
                
                self.likeImage.image = UIImage(named: "like")
                
            } else {
                
                // Current user liked the post!
                
                self.likeImage.image = UIImage(named: "liked")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        // observeSingleEventOfType listens for a tap by the current user.
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let like = snapshot.value as? NSNull {
                // Debugging
                print(like)
                
                self.likeImage.image = UIImage(named: "like")
                
                // addSubtractLike(), in Post.swift, handles the like.
                self.post.addSubtractLike(true)
                
                // setValue saves the likes as true for the current user.
                // likeRef is a reference to the user's "likes" path.                
                self.likeRef.setValue(true)
                
            } else {
                self.likeImage.image = UIImage(named: "liked")
                self.post.addSubtractLike(false)
                self.likeRef.removeValue()
            }
            
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // UITapGestureRecognizer is set programatically.
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostTableViewCell.likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(PostTableViewCell.likeTapped(_:)))
        tap2.numberOfTapsRequired = 2
        feedImage.addGestureRecognizer(tap2)
        feedImage.userInteractionEnabled = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Convert base64string back into image
    
    func convertBase64ToImage(base64String: String) -> UIImage {
        
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters )
        
        let decodedImage = UIImage(data: decodedData!)
        
        return decodedImage!
    }

}
