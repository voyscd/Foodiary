//
//  PostViewController.swift
//  Foodiary
//
//  Created by wjw on 6/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Fusuma

class PostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, FusumaDelegate {
    
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var AddPostButton: UIBarButtonItem!

    @IBOutlet weak var PostImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the TextView placeholder programmatically
        captionTextView.delegate = self
        self.captionTextView.text = "Write a caption..."
        self.captionTextView.textColor = UIColor.lightGrayColor()
        
    }
    
    @IBAction func AddPost(sender: AnyObject) {
        // Show Fusuma
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        //        fusuma.defaultMode = .Camera
        //        fusuma.modeOrder = .CameraFirst
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(image: UIImage) {
        
        print("Image selected")
        PostImage.image = image
    }
    
    func fusumaDismissedWithImage(PostImage: UIImage) {
        
        print("Called just after dismissed FusumaViewController")
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
    }
    
    
    // if the text view contains a placeholder (i.e. if its text color is light gray) 
    // clear the placeholder text and set the text color to black
    func textViewDidBeginEditing(captionTextView: UITextView) {
        if captionTextView.textColor == UIColor.lightGrayColor() {
            captionTextView.text = ""
            captionTextView.textColor = UIColor.blackColor()
        }
    }
    
    // if the text view is empty, reset its placeholder 
    // by re-adding the placeholder text and setting its color to light gray
    func textViewDidEndEditing(captionTextView: UITextView) {
        if captionTextView.text.isEmpty {
            captionTextView.text = "Write a caption..."
            captionTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss keyboard when touch ouside the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
