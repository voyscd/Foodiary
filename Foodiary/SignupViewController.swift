//
//  SignupViewController.swift
//  Foodiary
//
//  Created by wjw on 4/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var signupEmailTF: UITextField!
    
    @IBOutlet weak var signupPasswordTF: UITextField!

    @IBOutlet weak var signupBT: UIButton!
    
    // Signup Action
    @IBAction func signupAction(sender: AnyObject)
    {
        let email = self.signupEmailTF.text
        let password = self.signupPasswordTF.text
        
        // If both textfields are not blank
        if email != "" && password != ""
        {
            // Create the user in Firebase
            FIREBASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, authData) -> Void in
                
                // If no error during creation of the user
                if error == nil
                {
                    // Authenticate the user
                    FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                        
                        // If no error during the authentication
                        if error == nil
                        {
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            print("Account Created :)")
                            self.dismissViewControllerAnimated(true,completion: nil)
                        }
                        else
                        {
                            print(error)
                        }
                    })
                }
                // Print the error to debugger
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        signupEmailTF.delegate = self
        signupPasswordTF.delegate = self
    }

    // Dismiss keyboard when touch ouside the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss the keyboard by clicking the return
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
