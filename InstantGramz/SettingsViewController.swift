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

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var bioField: UITextField!
    
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
       vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
     self.presentViewController(vc, animated: true, completion: nil)

    }
    
    @IBAction func didTapChangeBio(sender: AnyObject) {
        let user = PFUser.currentUser()
        user!["bio"] = bioField.text
        user!.saveInBackground()
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        profileImageView.image = editedImage
        let imagePFFile = Post.getPFFileFromImage(editedImage)
        let user = PFUser.currentUser()
        user!["profilePicture"] = imagePFFile
        user!.saveInBackground()
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
        performSegueWithIdentifier("logoutSegue", sender: nil)
    }
    
    @IBAction func didTapBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
