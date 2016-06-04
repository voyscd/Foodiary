//
//  ProfileCell.swift
//  Foodiary
//
//  Created by wjw on 23/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Firebase

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileTotalPost: UILabel!

    func configureCell() {
        CURRENT_USER.observeEventType(FEventType.Value, withBlock: { snapshot in
            let currentUser = snapshot.value.objectForKey("Username") as! String
            let currentEmail = snapshot.value.objectForKey("Email") as! String
            print("Username: \(currentUser)")
            print("Username: \(currentEmail)")
            self.profileUsername.text = currentUser
            self.profileEmail.text = currentEmail
            }, withCancelBlock: { error in
                print(error.description)
        })
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
