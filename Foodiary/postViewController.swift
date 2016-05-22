//
//  PostViewController.swift
//  Foodiary
//
//  Created by wjw on 6/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Fusuma
import Firebase

class PostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FusumaDelegate {
    
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var AddPostButton: UIBarButtonItem!
    @IBOutlet weak var SavePostButton: UIButton!
    @IBOutlet weak var PostImage: UIImageView!
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var homemadeImage: UIImageView!
    @IBOutlet weak var barcodeImage: UIImageView!
    
    var currentUsername: String = ""
    var imageData: NSData = NSData()
    
    var isPictureSelected = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customise the navigation bar
        let color = UIColor(red: 104/255, green: 135/255, blue: 184/255, alpha: 1)
        
        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = color
        
        // Add Gesture Recognizer to the Post Image
        let postImageTap = UITapGestureRecognizer(target: self, action: #selector(PostViewController.addImageTapped(_:)))
        postImageTap.numberOfTapsRequired = 1
        PostImage.addGestureRecognizer(postImageTap)
        PostImage.userInteractionEnabled = true
        
        // Add Gesture Recognizer to the Category Image
        let menuImageTap = UITapGestureRecognizer(target: self, action: #selector(PostViewController.menuImageTapped(_:)))
        menuImageTap.numberOfTapsRequired = 1
        menuImage.addGestureRecognizer(menuImageTap)
        menuImage.userInteractionEnabled = true
        let homemadeImageTap = UITapGestureRecognizer(target: self, action: #selector(PostViewController.homemadeImageTapped(_:)))
        homemadeImageTap.numberOfTapsRequired = 1
        homemadeImage.addGestureRecognizer(homemadeImageTap)
        homemadeImage.userInteractionEnabled = true
        let barcodeImageTap = UITapGestureRecognizer(target: self, action: #selector(PostViewController.barcodeImageTapped(_:)))
        barcodeImageTap.numberOfTapsRequired = 1
        barcodeImage.addGestureRecognizer(barcodeImageTap)
        barcodeImage.userInteractionEnabled = true
        
        // Create the TextView placeholder programmatically
        captionTextView.delegate = self
        self.captionTextView.text = "Write a caption..."
        self.captionTextView.textColor = UIColor.lightGrayColor()
        
        // Get username of the current user, and set it to currentUsername, so we can add it to the Post.
        CURRENT_USER.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("Username") as! String
            
            print("Username: \(currentUser)")
            self.currentUsername = currentUser
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    @IBAction func SavePost(sender: AnyObject) {
        
        if menuImage.highlighted == false &&
            homemadeImage.highlighted == false &&
            barcodeImage.highlighted == false {
            displayAlert("Error", message: "Please choose a category for the food.")
        }
        else {
            
            let captionText = captionTextView.text
            
            if captionText != "" {
                
                // Test this later !!!
                //let imageString = convertImageToBase64(PostImage)
                
                // Convert the image into base64string
                if let image = PostImage.image{
                    imageData = UIImageJPEGRepresentation(image, 0.1)!
                }
                let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                
                // Get the food category of the post
                var postCategory = "default"
                if menuImage.highlighted == true {
                    postCategory = "Menu"
                }
                if homemadeImage.highlighted == true {
                    postCategory = "Homemade"
                }
                if barcodeImage.highlighted == true {
                    postCategory = "Barcode"
                }
                
                // Build the new Post.
                // AnyObject is needed because of the likes of type Int.
                
                let newPost: Dictionary<String, AnyObject> = [
                    "postCaption": captionText!,
                    "postImage": base64String,
                    "likes": 0,
                    "author": currentUsername,
                    "postCategory": postCategory
                ]
                
                // Send it over to BaseService and save the data in Firebase.
                createNewPost(newPost)
                
                // Reset the View and move back to the Feed page
                tabBarController?.selectedIndex = 0
                resetView()
                
                //            if let navController = self.navigationController {
                //                navController.popViewControllerAnimated(true)
                //            }
            }
        }
    }
    
    
    // Add the image of new post
    @IBAction func AddPost(sender: AnyObject) {
        // Show Fusuma
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        //        fusuma.defaultMode = .Camera
        //        fusuma.modeOrder = .CameraFirst
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    
    
    // FusumaDelegate Protocol used to pick the image from device library
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
    
    // The above methods are from Fusuma library
    
    
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
    
    // Convert the image into String so it can be stored
    func convertImageToBase64(image: UIImage) -> String{
        let imageData = UIImagePNGRepresentation(image)
        let base64String = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        return base64String!
    }
    
    // Reset the View after save
    func resetView() {
        self.captionTextView.text = "Write a caption..."
        self.captionTextView.textColor = UIColor.lightGrayColor()
        self.PostImage.image = UIImage(named: "DefaultFood100")
    }
    
    // Add the Gesture Recognizer to the Post Image
    func addImageTapped(sender: UITapGestureRecognizer) {
        let controller = UIAlertController()
        
        controller.title = "Please Select Image Source"
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default){
            action in
            self.getPicture(UIImagePickerControllerSourceType.Camera)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default){
            action in
            self.getPicture(UIImagePickerControllerSourceType.PhotoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){
            action in
        }
        
        controller.addAction(cameraAction)
        controller.addAction(libraryAction)
        controller.addAction(cancelAction)
        
        self.presentViewController(controller, animated:true,completion:nil)
    }
    
    // The method used to get the image
    func getPicture(opt:UIImagePickerControllerSourceType){
        let image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = false
        image.sourceType = opt
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        isPictureSelected = true
        PostImage.image = image
    }
    
    // Add the Gesture Recognizer to the images of three categories
    func menuImageTapped(sender: UITapGestureRecognizer) {
        
        if menuImage.highlighted == false {
            if homemadeImage.highlighted == true {
                homemadeImage.highlighted = false
            }
            if barcodeImage.highlighted == true {
                barcodeImage.highlighted = false
            }
            menuImage.highlighted = true
        }
    }
    
    func homemadeImageTapped(sender: UITapGestureRecognizer) {
        if homemadeImage.highlighted == false {
            if menuImage.highlighted == true {
                menuImage.highlighted = false
            }
            if barcodeImage.highlighted == true {
                barcodeImage.highlighted = false
            }
            homemadeImage.highlighted = true
        }
    }
    
    func barcodeImageTapped(sender: UITapGestureRecognizer) {
        if barcodeImage.highlighted == false {
            if menuImage.highlighted == true {
                menuImage.highlighted = false
            }
            if homemadeImage.highlighted == true {
                homemadeImage.highlighted = false
            }
            barcodeImage.highlighted = true
        }
    }
    
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
