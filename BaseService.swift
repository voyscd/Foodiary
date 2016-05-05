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

let FIREBASE_REF = Firebase(url: BASE_URL)

var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    
    return currentUser!
}
