//
//  CaptionViewController.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/21/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class CaptionViewController: UIViewController {
    
    var image:UIImage? = nil
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    //var currentPost: Pods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CaptionViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapPost(sender: AnyObject) {
       // var currentPost: Post
        //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var caption = captionField.text
        if (captionField.text == nil) {
            caption = ""
        }
        let currentImage = imageView.image
        Post.postUserImage(currentImage, withCaption: caption, withCompletion: nil)
        //MBProgressHUD.hideHUDForView(self.view, animated: true)
        print("posted")
        //self.dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("postedImage", sender: nil)
    }

    @IBAction func onTap(sender: AnyObject) {
        print ("tapped")
        captionField.resignFirstResponder()
        view.endEditing(true)
    }
    
    
    

}
