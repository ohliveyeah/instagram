//
//  PostViewController.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/20/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var modeControl: UISegmentedControl!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    @IBAction func didTapPostButton(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if (modeControl.selectedSegmentIndex == 0) {
            vc.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imageView.image = editedImage
        postButton.hidden = true
        continueButton.hidden = false
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CaptionSegue") {
            let vc = segue.destinationViewController as! CaptionViewController
            vc.image = imageView.image
        }
    }

}
