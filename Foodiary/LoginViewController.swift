//
//  LoginViewController.swift
//  Foodiary
//
//  Created by wjw on 4/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    func hideKeyboardWhenTappedAround()
    {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

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
                    print("Logged In :)")
                }
                else
                {
                    print(error)
                }
            })
        }
        // Give alter if either one of the the textfield is blank
        else
        {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        // Dismiss the keyboard when tapped around
        self.hideKeyboardWhenTappedAround()

    }
    
    // Check if a user has already logged in
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil
        {
            self.logoutBT.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Log out the user
    @IBAction func logoutAction(sender: AnyObject)
    {
        // Unauthenticate the user
        CURRENT_USER.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.logoutBT.hidden = true
        print("Logged Out :)")
    }
    
    // Dismiss the keyboard by tapping the return
    func textFieldDidBeginEditing(textField: UITextField)
    {
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
