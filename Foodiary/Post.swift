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
    private var _postVotes: Int!
    private var _username: String!
    
    var postKey: String {
        return _postKey
    }
    
    var postCaption: String {
        return _postCaption
    }
    
    var postImage: String {
        return _postImage
    }
    
    var postVotes: Int {
        return _postVotes
    }
    
    var username: String {
        return _username
    }
    
    // Initialize the new post
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = key
        
        // Within the post, or key, the following properties are children
        
        if let votes = dictionary["votes"] as? Int {
            self._postVotes = votes
        }
        
        if let post = dictionary["postText"] as? String {
            self._postCaption = post
        }
        
        if let user = dictionary["author"] as? String {
            self._username = user
        } else {
            self._username = ""
        }
        
        // The above properties are assigned to their key.
        
        self._postRef = POST_REF.childByAppendingPath(self._postKey)
    }
    
    func addSubtractVote(addVote: Bool) {
        
        if addVote {
            _postVotes = _postVotes + 1
        } else {
            _postVotes = _postVotes - 1
        }
        
        // Save the new vote total.
        
        _postRef.childByAppendingPath("votes").setValue(_postVotes)
        
    }


}
