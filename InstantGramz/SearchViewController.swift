//
//  SearchViewController.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/24/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData = [PFObject]()
    var usernames = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let query = PFQuery(className: "_User")
        query.orderByDescending("createdAt")
        //query.includeKey("username")
        
        query.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if let users = users {
                self.usernames = users
                self.filteredData = users
            }
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return filteredData.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchTableViewCell
        let user = filteredData[indexPath.row]
        
        let username = user["username"]
        //let profilePic = user["profilePicture"]
        
        
        var newPost: PFObject! {
            didSet {
                let oldPic = user["profilePicture"] as? PFFile
                cell.profilePicture.file = oldPic
                cell.profilePicture.loadInBackground()
            }
        }
        newPost = user

        cell.userLabel.text = (username as! String)
    
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = usernames
        } else {
            filteredData = usernames.filter({(dataItem: PFObject) -> Bool in
                if (dataItem["username"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath: NSIndexPath
        indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        
        let vc = segue.destinationViewController as! OtherProfileViewController
        vc.user = filteredData[indexPath.row] 
    }
}
