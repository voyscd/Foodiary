//
//  ProfileViewController.swift
//  Foodiary
//
//  Created by wjw on 10/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileTotalPost: UILabel!
    @IBOutlet weak var profileBio: UILabel!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var currentUsername: String = ""
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editAction(sender: AnyObject) {
    }
    
    var currentEmail: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the texts based on the data retrieved from the firebase
        CURRENT_USER.observeEventType(FEventType.Value, withBlock: { snapshot in
            let currentUser = snapshot.value.objectForKey("Username") as! String
            let currentEmail = snapshot.value.objectForKey("Email") as! String
            print("Username: \(currentUser)")
            self.currentUsername = currentUser
            self.profileUsername.text = currentUser
            self.navigationItem.title = currentUser
            self.profileEmail.text = currentEmail
            self.profileTotalPost.text = "0 posts"
            self.profileBio.text = "Profile bio"
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        // Customise the navigation bar
        let color = UIColor(red: 104/255, green: 135/255, blue: 184/255, alpha: 1)
        
        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = color

        // Do any additional setup after loading the view.
        
    }
    
    // The method is called when logout button is tapped
    @IBAction func logoutAction(sender: AnyObject) {
        
        // Get the username of the login user
        CURRENT_USER.observeEventType(FEventType.Value, withBlock: { snapshot in
            self.currentUsername = snapshot.value.objectForKey("Username") as! String
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        // Ask user to confirm logout
        let refreshAlert = UIAlertController(title: "Are you sure \(currentUsername)?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Log Out", style: .Default, handler: { (action: UIAlertAction!) in
            
            // Unauthenticate the user
            CURRENT_USER.unauth()
            // Remove the uid value
            NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
            print("Logged Out :)")
            
            // Return back to the Login page using Unwind segue
            self.performSegueWithIdentifier("unwindToLoginViewController", sender: self)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Display alert message
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
