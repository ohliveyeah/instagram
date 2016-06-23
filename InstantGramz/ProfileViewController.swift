//
//  ProfileViewController.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/22/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var isMoreDataLoading = false
    var userPosts: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()!.username
        print(currentUser)
        userLabel.text = "\(currentUser!)'s Gramz"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        //
        //        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ProfileViewController.onTimer), userInfo: nil, repeats: true)
        
        //        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
        //        self.profilePicture.clipsToBounds = true;
        //        self.profilePicture.layer.borderWidth = 3.0;
        //        self.profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        // construct query
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.userPosts = posts
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // construct query
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.userPosts = posts
            } else {
                print(error?.localizedDescription)
            }
        }
        self.collectionView.reloadData()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfilePostCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
        
        let post = userPosts[indexPath.row]
        cell.profileImageView.file = post["media"] as? PFFile
        cell.profileImageView.loadInBackground()
        
        cell.likeLabel.text = post["likesCount"].stringValue
        cell.commentsLabel.text = post["commentsCount"].stringValue
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "profilePostDetailsSegue") {
            var indexPath: NSIndexPath
            let vc = segue.destinationViewController as! PostDetailsViewController
            indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)!
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            
            let post = userPosts[indexPath.row]
            //print(post)
            vc.currentPost = post
            let caption = post["caption"]
            vc.captionText = caption as! String
            let user = post["author"] as! PFUser
            print (user)
            //print (user.username)
            //let username: String? = user.username
            //print(username)
            let username = PFUser.currentUser()!.username
            print(username)
            print(username!)
            var username1 = username!
            //vc.userLabel.text = username1
            let timestamp = post.createdAt
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            let convertedDate = dateFormatter.stringFromDate(timestamp!)
            vc.timestampText = "Posted:\(convertedDate)"
            
            let oldImage = post["media"] as? PFFile
            vc.image = oldImage
            if (oldImage != nil) {
                
                print("imageView not nil")
            }
        }
    }
    
}

