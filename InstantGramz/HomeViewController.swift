//
//  HomeViewController.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/20/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var userPosts: [PFObject] = []
    var limit = 4
    let CellIdentifier = "PostCell"
    let HeaderViewIdentifier = "PostHeaderView"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(HomeViewController.onTimer), userInfo: nil, repeats: true)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
         tableView.insertSubview(refreshControl, atIndex: 0)
        
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = limit
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.userPosts = posts
  
            } else {
                //handle error
            }
            self.tableView.reloadData()
        }
        
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
        
    }
    
    @IBAction func didTapLike(sender: AnyObject) {
        //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        //NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        //if (indexPath != nil)
//        {
//            ...
//        }
        print("like button pressed")
        let buttonPosition: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if (indexPath != nil) {
            let post = self.userPosts[indexPath!.row]
            let oldLikesCount = post["likesCount"]
            var newLikesCount = (oldLikesCount as? Int)
            newLikesCount! += 1
            //post.setValue(newLikesCount, forKeyPath: "likesCount")
            post.setObject(newLikesCount!, forKey: "likesCount")
            post.saveInBackground()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return 1
        //return userPosts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! FeedPostTableViewCell
        let image = userPosts[indexPath.section]
        let caption = image["caption"]
        let user = image["author"]
        let username = user.username
        let likesCount = image["likesCount"]
        let commentsCount = image["commentsCount"]
        var instagramPost: PFObject! {
            didSet {
                cell.postImage.file = instagramPost["media"] as? PFFile
                cell.postImage.loadInBackground()
            }
        }
        instagramPost = image
        
        cell.userLabel.text = username
        cell.captionLabel.text = caption as? String
        cell.likeLabel.text = likesCount.stringValue
        cell.commentsLabel.text = "\(commentsCount.stringValue) comments"
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        let post = self.userPosts[section]
        let user = post["author"]
        header.textLabel!.text = user.username
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func onTimer() {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = limit
        
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.userPosts = posts
            }
            self.tableView.reloadData()
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = limit
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.userPosts = posts
            }
            self.tableView.reloadData()
        }
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    func loadMoreData() {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        limit += 3
        query.limit = limit
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.userPosts = posts
            }
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
        }

    }
    

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                
               loadMoreData()
            }
            self.isMoreDataLoading = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PostDetailsSegue") {
            var indexPath: NSIndexPath
            let vc = segue.destinationViewController as! PostDetailsViewController
            indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
            
            
            let post = userPosts[indexPath.row]
            print(post)
            vc.currentPost = post
            let caption = post["caption"]
            vc.captionText = caption as! String
            let user = post["author"]
            let username = user.username
            vc.userText = username!!
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


