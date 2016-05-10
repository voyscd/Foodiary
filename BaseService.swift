//
//  BaseService.swift
//  Foodiary
//
//  Created by wjw on 4/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://roy-foodiary.firebaseio.com/"



var FIREBASE_REF = Firebase(url: BASE_URL)
var _USER_REF = Firebase(url: "\(BASE_URL)/users")
var _POST_REF = Firebase(url: "\(BASE_URL)/posts")

var BASE_REF: Firebase {
    return FIREBASE_REF
}

var USER_REF: Firebase {
    return _USER_REF
}

var POST_REF: Firebase {
    return _POST_REF
}

var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    
    return currentUser!
}

func createNewAccount(uid: String, user: Dictionary<String, String>) {
    
    // A User is born.    
    USER_REF.childByAppendingPath(uid).setValue(user)
}

func createNewPost(post: Dictionary<String, AnyObject>) {
    
    // Save the Post
    // POST_REF is the parent of the new Post: "posts".
    // childByAutoId() saves the post and gives it its own ID.
    
    let firebaseNewPost = POST_REF.childByAutoId()
    
    // setValue() saves to Firebase.
    
    firebaseNewPost.setValue(post)
}
