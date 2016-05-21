//
//  FeedTableViewController.swift
//  Foodiary
//
//  Created by wjw on 21/05/2016.
//  Copyright © 2016 2016 S2 FIT4039. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController {
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // observeEventType is called whenever anything changes in the Firebase - new Jokes or Votes.
        // It's also called here in viewDidLoad().
        // It's always listening.
        
//        POST_REF.observeEventType(.Value, withBlock: { snapshot in
//            
//            // The snapshot is a current look at post data.
//            
//            print(snapshot.value)
//            
//            self.posts = []
//            
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
//                
//                for snap in snapshots {
//                    
//                    // Make post array for the tableView.
//                    
//                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let post = Post(key: key, dictionary: postDictionary)
//                        
//                        // Items are returned chronologically, but it's more fun with the newest jokes first.
//                        
//                        self.posts.insert(post, atIndex: 0)
//                    }
//                }
//                
//            }
//            
//            // tableView updates when there is new data.
//            
//            self.tableView.reloadData()
//        })
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        POST_REF.observeEventType(.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at post data.
            
            print(snapshot.value)
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make post array for the tableView.
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(key: key, dictionary: postDictionary)
                        
                        // Items are returned chronologically, but it's more fun with the newest jokes first.
                        
                        self.posts.insert(post, atIndex: 0)
                    }
                }
                
            }
            
            // tableView updates when there is new data.
            
            self.tableView.reloadData()
        })
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostTableViewCell {
            
            // Send the single post to configureCell() in PostTableViewCell.
            
            cell.configureCell(post)
            
            return cell
        }
        
        else {
            
            return PostTableViewCell()
            
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
