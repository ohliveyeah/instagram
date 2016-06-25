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
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var tagField: UITextField!
    @IBOutlet weak var effectField: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CaptionViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        
//        UIImage *aUIImage = showPickedImageView.image;
//        CGImageRef aCGImage = aUIImage.CGImage;
//        aCIImage = [CIImage imageWithCGImage:aCGImage];
//        
//        
//        context = [[CIContext contextWithOptions:nil] retain];
//        brightnessFilter = [[CIFilter filterWithName:@"CIColorControls" keysAndValues: @"inputImage", aCIImage, nil] retain];
//        
//    }
//    
//    -(IBAction)brightnessSliderValueChanged:(id)sender {
//    
//    [brightnessFilter setValue:[NSNumber numberWithFloat:brightnessSlider.value ] forKey: @"inputBrightness"];
//    outputImage = [brightnessFilter outputImage];
//    CGImageRef cgiig = [context createCGImage:outputImage fromRect:[outputImage extent]];
//    newUIImage = [UIImage imageWithCGImage:cgiig];
//    CGImageRelease(cgiig);
//    [showPickedImageView setImage:newUIImage];
//    
//    }
        
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
        let taggedUsername = tagField.text
        var taggedUser: PFObject?
        
        let query = PFQuery(className: "_User")
        query.orderByDescending("createdAt")
        query.whereKey("username", equalTo: taggedUsername!)
        print(taggedUsername!)
        print("query")
        
        query.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if let users = users {
                taggedUser = users[0]
                print(taggedUser)
            }
            Post.postUserImage(currentImage!, withCaption: caption!, withUsername: taggedUsername!, withUser: taggedUser, withCompletion: nil)
        }
      
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
//            let vignette = CIFilter(name:"CIVignette")
//            vignette!.setValue(coreImage, forKey:kCIInputImageKey)
//            vignette!.setValue(2, forKey:"inputIntensity")
//            vignette!.setValue(500, forKey:"inputRadius")
//            
//            if let output = vignette!.valueForKey(kCIOutputImageKey) as? CIImage {
//                //convert to CG Image
//                let context = CIContext(options: nil)
//                let filteredImg = context.createCGImage(output, fromRect: output.extent)
//                //convert back to UI Image
//                let filteredImage = UIImage(CGImage: filteredImg)
//                imageView?.image = filteredImage
//            }
//            else {
//                print("image filtering failed")
//            }
            
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
    
    
    @IBAction func didChooseEffect(sender: AnyObject) {
        print("valueChanged")
        let currentImage = imageView.image
        let cgimg = currentImage!.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        
        if (effectField.selectedSegmentIndex == 0) {
            imageView.image = currentImage
        }
        
        if (effectField.selectedSegmentIndex == 1) {
            print("1")
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
        if (effectField.selectedSegmentIndex == 2) {
            print("2")
            let filter = CIFilter (name:"CIDotScreen")
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            filter!.setValue(25, forKey: "inputWidth")
            filter!.setValue(0, forKey: "inputAngle")
            filter!.setValue(0.7, forKey: "inputSharpness")
            
            if let output = filter!.valueForKey(kCIOutputImageKey) as? CIImage {
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
        if (effectField.selectedSegmentIndex == 3) {
            print("3")
            let filter = CIFilter (name:"CIGaussianBlur")
            filter!.setValue(coreImage, forKey:kCIInputImageKey)
            filter!.setValue(15, forKey: "inputRadius")
            
            if let output = filter!.valueForKey(kCIOutputImageKey) as? CIImage {
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
