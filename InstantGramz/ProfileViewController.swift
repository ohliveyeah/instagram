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

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var taggedCollectionView: UICollectionView!
    @IBOutlet weak var myPostsButton: UIButton!
    @IBOutlet weak var tagsButton: UIButton!
    
    var isMoreDataLoading = false
    var taggedPost: [PFObject] = []
    var userPosts: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPostsButton.hidden = true
        
        let currentUser = PFUser.currentUser()!.username
        userLabel.text = "\(currentUser!)'s Gramz"
        var bio = PFUser.currentUser()!["bio"]
        if let bio = bio {
            bioLabel.text = (bio as! String)
        } else {
            bioLabel.text = ""
        }
        
        taggedCollectionView.dataSource = self
        taggedCollectionView.delegate = self
        taggedCollectionView.hidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self

        
        //
        //        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ProfileViewController.onTimer), userInfo: nil, repeats: true)
        
        self.profilePicture.layer.cornerRadius = 30
        self.profilePicture.layer.masksToBounds = true
        
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
                self.postsLabel.text = "\(self.userPosts.count) Posts"
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
            // construct query
            let secondQuery = PFQuery(className: "Post")
            secondQuery.includeKey("taggedUser")
            secondQuery.whereKey("taggedUser", equalTo: PFUser.currentUser()!)
            
            // fetch data asynchronously
            secondQuery.findObjectsInBackgroundWithBlock { (secondPosts: [PFObject]?, error: NSError?) -> Void in
                if let secondPosts = secondPosts {
                    self.taggedPost = secondPosts
                    self.taggedCollectionView.reloadData()
                } else {
                    print(error?.localizedDescription)
                }
            }

        }
        
        let currentProfilePic = PFUser.currentUser()!["profilePicture"]
        
        var instagramPost: PFObject! {
            didSet {
                self.profilePicture.file = PFUser.currentUser()!["profilePicture"] as? PFFile
                self.profilePicture.loadInBackground()
            }
        }
        instagramPost = PFUser.currentUser()
    }
    
    @IBAction func didTapTags(sender: AnyObject) {
        collectionView.hidden = true
        taggedCollectionView.hidden = false
        tagsButton.hidden = true
        myPostsButton.hidden = false
        
        postsLabel.text = "\(taggedPost.count) Posts"
    }
    
    
    @IBAction func didTapMyPosts(sender: AnyObject) {
        collectionView.hidden = false
        taggedCollectionView.hidden = true
        tagsButton.hidden = false
        myPostsButton.hidden = true
        
        postsLabel.text = "\(userPosts.count)"
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        var bio = PFUser.currentUser()!["bio"]
        if let bio = bio {
            bioLabel.text = (bio as! String)
        } else {
            bioLabel.text = ""
        }
        
        let currentProfilePic = PFUser.currentUser()!["profilePicture"]
        
        var instagramPost: PFObject! {
            didSet {
                self.profilePicture.file = PFUser.currentUser()!["profilePicture"] as? PFFile
                self.profilePicture.loadInBackground()
            }
        }
        instagramPost = PFUser.currentUser()
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
        
        let currentProfilePic = PFUser.currentUser()!["profilePicture"]
        
        var instagramPost: PFObject! {
            didSet {
                self.profilePicture.file = PFUser.currentUser()!["profilePicture"] as? PFFile
                self.profilePicture.loadInBackground()
            }
        }
        instagramPost = PFUser.currentUser()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView.restorationIdentifier == "Posts Collection View") {
            return userPosts.count
        }
        else {
            return taggedPost.count
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (collectionView.restorationIdentifier == "Posts Collection View") {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfilePostCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
            
            let post = userPosts[indexPath.row]
            cell.profileImageView.file = post["media"] as? PFFile
            cell.profileImageView.loadInBackground()
            
            cell.likeLabel.text = post["likesCount"].stringValue
            cell.commentsLabel.text = post["commentsCount"].stringValue
            
            return cell
        }
        else {
            let cell = taggedCollectionView.dequeueReusableCellWithReuseIdentifier("ProfilePostCell", forIndexPath: indexPath) as! ProfileCollectionViewCell
            
            let post = taggedPost[indexPath.row]
            cell.profileImageView.file = post["media"] as? PFFile
            cell.profileImageView.loadInBackground()
            
            cell.likeLabel.text = post["likesCount"].stringValue
            cell.commentsLabel.text = post["commentsCount"].stringValue
            
            return cell

        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var bio = PFUser.currentUser()!["bio"]
        if let bio = bio {
            bioLabel.text = (bio as! String)
        } else {
            bioLabel.text = ""
        }
        
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

        let currentProfilePic = PFUser.currentUser()!["profilePicture"]
        
        var instagramPost: PFObject! {
            didSet {
                self.profilePicture.file = PFUser.currentUser()!["profilePicture"] as? PFFile
                self.profilePicture.loadInBackground()
            }
        }
        instagramPost = PFUser.currentUser()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "profilePostDetailsSegue") {
            var indexPath: NSIndexPath
            let vc = segue.destinationViewController as! PostDetailsViewController
            indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)!
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            
            let post = userPosts[indexPath.row]
            vc.currentPost = post
            let caption = post["caption"]
            vc.captionText = caption as! String
            let likesCount = post["likesCount"]
            vc.likesText = likesCount.stringValue
            
            let timestamp = post.createdAt
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            let convertedDate = timestamp?.timeIntervalSinceNow
            let newDate = convertedDate! * -1
            var finalDate = Int(newDate)
            if finalDate > 3600 {
                print(finalDate)
                finalDate = finalDate / 3600
                vc.timestampText = "Posted:\(finalDate) hours ago"
            }
            else if finalDate > 60 {
                print(finalDate)
                finalDate = finalDate / 60
                vc.timestampText = "Posted:\(finalDate) minutes ago"
            }
            else {
                print(finalDate)
                vc.timestampText = "Posted:\(finalDate) seconds ago"
            }

            
            let oldImage = post["media"] as? PFFile
            vc.image = oldImage
        }
    }
    
    
}

