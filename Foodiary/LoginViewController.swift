//
//  LoginViewController.swift
//  Foodiary
//
//  Created by wjw on 4/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBT: UIButton!
    @IBOutlet weak var logoutBT: UIButton!
    
    // Login Action
    @IBAction func loginAction(sender: AnyObject)
    {
        let email = self.emailTF.text
        let password = self.passwordTF.text
        
        // If both textfields are not blank
        if email != "" && password != ""
        {
            FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                // If no error
                if error == nil
                {
                    // User login successfully
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    self.performSegueWithIdentifier("LoginSegue", sender: self)
                    print("Logged In :)")
                }
                else
                {
                    self.displayAlert("Error", message: "Incorrect Username or Password.")
                    print(error)
                }
            })
        }
        // Give alter if either one of the the textfield is blank
        else
        {
            displayAlert("Error", message: "Enter Email and Password.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self

    }
    
    // Check if a user has already logged in
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil
        {
            self.logoutBT.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // Log out the user
//    @IBAction func logoutAction(sender: AnyObject)
//    {
//        // Unauthenticate the user
//        CURRENT_USER.unauth()
//        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
//        self.logoutBT.hidden = true
//        print("Logged Out :)")
//    }
    
    // Dismiss keyboard when touch ouside the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Dismiss the keyboard by clicking the return
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // Use for Logout function. Once logout is called the page will
    // return back to this login view controller.
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }

}
