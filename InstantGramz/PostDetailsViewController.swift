//
//  PostDetailsViewController.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/22/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostDetailsViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    var image:PFFile? = nil
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var profilePicture: PFImageView!
    
    var captionText = ""
    var userText = ""
    var timestampText = ""
    var likesText = ""
    var currentPost: PFObject?
    var commentButtonCounter = 0
    var comments: [PFObject] = []
    var postUser: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentsTableView.dataSource = self
        self.commentsTableView.delegate = self
        
        captionLabel.text = captionText
        userLabel.text = userText
        likesLabel.text = likesText
        imageView.file = image
        imageView.loadInBackground()
        timestampLabel.text = timestampText
        commentField.hidden = true
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(PostDetailsViewController.onTimer), userInfo: nil, repeats: true)
        
        // construct PFQuery
        let query = PFQuery(className: "Comment")
        query.orderByAscending("createdAt")
        query.whereKey("parent", equalTo: currentPost!)
        //var post = myComment["parent"] as PFObject
        
        //IT DOESNT LIKE THIS (BELOW)
        //query.includeKey("username")
        //query.limit = limit
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (comments: [PFObject]?, error: NSError?) -> Void in
            if let comments = comments {
                self.comments = comments
                
            } else {
                print(error?.localizedDescription)
            }
            self.commentsTableView.reloadData()
        }
        if let postUser = postUser {
            let currentProfilePic = postUser["profilePicture"]
            print(currentProfilePic)
        }
        var instagramPost: PFObject! {
            didSet {
                self.profilePicture.file = postUser!["profilePicture"] as? PFFile
                print(self.profilePicture.file)
                self.profilePicture.loadInBackground()
            }
        }
        //instagramPost = currentProfilePic

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapComment(sender: AnyObject) {
        commentButtonCounter += 1
        if (commentButtonCounter % 2 == 1) {
            commentField.hidden = false
        }
        else {
            Post.postComment(commentField.text, forPost: currentPost!)
            print ("Comment posted \(commentField.text!)")
            commentField.hidden = true
        }
        self.commentsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentsTableViewCell
        let comment = comments[indexPath.row]
        cell.commentLabel.text = (comment["text"] as! String)
        cell.userLabel.text = (comment["username"] as! String)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        
        let timestamp = comment.createdAt
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        let convertedDate = timestamp?.timeIntervalSinceNow
        let newDate = convertedDate! * -1
        var finalDate = Int(newDate)
        if finalDate > 3600 {
            finalDate = finalDate / 3600
            cell.timestampLabel.text = "\(finalDate) hours ago"
        }
        else if finalDate > 60 {
            finalDate = finalDate / 60
            cell.timestampLabel.text = "\(finalDate) minutes ago"
        }
        else {
            cell.timestampLabel.text = "\(finalDate) seconds ago"
        }

        return (cell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "visitProfileSegue") {
            let vc = segue.destinationViewController as! OtherProfileViewController
            vc.user = (currentPost!["author"] as! PFObject)
        }
    }
    
    func onTimer() {
        let query = PFQuery(className: "Comment")
        query.orderByAscending("createdAt")
        query.whereKey("parent", equalTo: currentPost!)
        
        query.findObjectsInBackgroundWithBlock { (comments: [PFObject]?, error: NSError?) -> Void in
            if let comments = comments {
                self.comments = comments
                
            } else {
                print(error?.localizedDescription)
            }
            self.commentsTableView.reloadData()
        }
    }
}
