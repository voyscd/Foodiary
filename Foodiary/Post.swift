//
//  Post.swift
//  Foodiary
//
//  Created by wjw on 10/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postRef: Firebase!
    private var _postKey: String!
    private var _postCaption: String!
    private var _postImage: String!
    private var _postLikes: Int!
    private var _username: String!
    private var _postCategory: String!
    
    var postKey: String {
        return _postKey
    }
    
    var postCaption: String {
        return _postCaption
    }
    
    var postImage: String {
        return _postImage
    }
    
    var postLikes: Int {
        return _postLikes
    }
    
    var username: String {
        return _username
    }
    
    var postCategory: String {
        return _postCategory
    }
    
    // Initialize the new post
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = key
        
        // Within the post, or key, the following properties are children
        
        if let image = dictionary["postImage"] as? String {
            self._postImage = image
        }
        
        if let likes = dictionary["likes"] as? Int {
            self._postLikes = likes
        }
        
        if let caption = dictionary["postCaption"] as? String {
            self._postCaption = caption
        }
        
        if let user = dictionary["author"] as? String {
            self._username = user
        } else {
            self._username = ""
        }
        
        if let category = dictionary["postCategory"] as? String {
            self._postCategory = category
        }
        
        // The above properties are assigned to their key.
        
        self._postRef = POST_REF.childByAppendingPath(self._postKey)
    }
    
    // Add or Subtract a Like from the Post.
    func addSubtractLike(addLike: Bool) {
        
        if addLike {
            _postLikes = _postLikes + 1
        } else {
            _postLikes = _postLikes - 1
        }
        
        // Save the new like total.
        
        _postRef.childByAppendingPath("likes").setValue(_postLikes)
        
    }


}
