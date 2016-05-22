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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customise the navigation bar
        let color = UIColor(red: 104/255, green: 135/255, blue: 184/255, alpha: 1)
        
        self.tabBarController?.tabBar.hidden = false
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = color

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
