//
//  SettingsViewController.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/23/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImageView: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentProfilePic = PFUser.currentUser()!["profilePicture"]
        
        var instagramPost: PFObject! {
            didSet {
                self.profileImageView.file = PFUser.currentUser()!["profilePicture"] as? PFFile
                self.profileImageView.loadInBackground()
            }
        }
        instagramPost = PFUser.currentUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapChangeProfile(sender: AnyObject) {
        let vc = UIImagePickerController()
       // vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
     self.presentViewController(vc, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        profileImageView.image = editedImage
        PFUser.currentUser()!["profilePicture"] = editedImage
        PFUser.currentUser()?.saveInBackground()
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }

}
