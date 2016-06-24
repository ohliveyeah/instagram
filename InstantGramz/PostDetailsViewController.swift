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
    
    
    var captionText = ""
    var userText = ""
    var timestampText = ""
    var likesText = ""
    var currentPost: PFObject?
    var commentButtonCounter = 0
    var comments: [PFObject] = []
    
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
            print ("comment button pressed")
            commentField.hidden = false
        }
        else {
            print ("post button pressed")
            Post.postComment(commentField.text, forPost: currentPost!)
            print ("Comment posted \(commentField.text!)")
            commentField.hidden = true
        }
        commentsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        //print(comments.count)
        return comments.count
        //return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentsTableViewCell
        let comment = comments[indexPath.row]
        cell.commentLabel.text = (comment["text"] as! String)
        cell.userLabel.text = (comment["username"] as! String)
        return (cell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "visitProfileSegue") {
            let vc = segue.destinationViewController as! OtherProfileViewController
            vc.user = currentPost!["author"] as! PFObject
        }
    }
}
