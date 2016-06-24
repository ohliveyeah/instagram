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
import CoreImage

class CaptionViewController: UIViewController {
    
    var image:UIImage? = nil
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var filterChoice: UISegmentedControl!
    
    
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
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var caption = captionField.text
        if (captionField.text == nil) {
            caption = ""
        }
        let currentImage = imageView.image
        Post.postUserImage(currentImage!, withCaption: caption!, withCompletion: nil)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        print("posted")
        //self.dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("postedImage", sender: nil)
    }
    
    
    @IBAction func didChoooseFilter(sender: AnyObject) {
        //convert image
        let cgimg = image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        
        if (filterChoice.selectedSegmentIndex == 0) {
            imageView.image = image
        }
        
        if (filterChoice.selectedSegmentIndex == 1) {
            //get filter ready
            let filter = CIFilter(name: "CISepiaTone")
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            filter?.setValue(0.5, forKey: kCIInputIntensityKey)
            //
            
            
            if let output = filter?.valueForKey(kCIOutputImageKey) as? CIImage {
                //convert to CG Image
                let context = CIContext(options: nil)
                let filteredImg = context.createCGImage(output, fromRect: output.extent)
                //convert back to UI Image
                let filteredImage = UIImage(CGImage: filteredImg)
                imageView?.image = filteredImage
            }
            else {
                print("image filtering failed")
            }
        }
        
        if (filterChoice.selectedSegmentIndex == 2) {
            let vignette = CIFilter(name:"CIVignette")
            vignette!.setValue(coreImage, forKey:kCIInputImageKey)
            vignette!.setValue(2, forKey:"inputIntensity")
            vignette!.setValue(500, forKey:"inputRadius")
            
            if let output = vignette!.valueForKey(kCIOutputImageKey) as? CIImage {
                //convert to CG Image
                let context = CIContext(options: nil)
                let filteredImg = context.createCGImage(output, fromRect: output.extent)
                //convert back to UI Image
                let filteredImage = UIImage(CGImage: filteredImg)
                imageView?.image = filteredImage
            }
            else {
                print("image filtering failed")
            }
            
        }
        
        if (filterChoice.selectedSegmentIndex == 3) {
            let noir = CIFilter(name:"CIPhotoEffectNoir")
            noir!.setValue(coreImage, forKey:kCIInputImageKey)
            //vignette!.setValue(2, forKey:"inputIntensity")
            //vignette!.setValue(500, forKey:"inputRadius")
            
            if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
                //convert to CG Image
                let context = CIContext(options: nil)
                let filteredImg = context.createCGImage(output, fromRect: output.extent)
                //convert back to UI Image
                let filteredImage = UIImage(CGImage: filteredImg)
                imageView?.image = filteredImage
            }
            else {
                print("image filtering failed")
            }
            
        }


    }
    
    

}
