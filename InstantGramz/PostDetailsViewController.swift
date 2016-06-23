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

class PostDetailsViewController: UIViewController { //UITableViewDataSource, UITableViewDelegate {

    var image:PFFile? = nil
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentsTableView: UITableView!
    
    
    var captionText = ""
    var userText = ""
    var timestampText = ""
    var currentPost: PFObject?
    var commentButtonCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        commentsTableView.dataSource = self
//        commentsTableView.delegate = self
        
        captionLabel.text = captionText
        userLabel.text = userText
        imageView.file = image
        imageView.loadInBackground()
        timestampLabel.text = timestampText
        commentField.hidden = true
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
            print ("Comment posted \(commentField.text)")
            commentField.hidden = true
        }
        
    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection
//        section: Int) -> Int {
//       // return currentPost.comments.count
//        return 1
//    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = commentsTableView.dequeueReusableCellWithIdentifier("PostCell")
//        return cell?
//    }
}
