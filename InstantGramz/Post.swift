//
//  Parse.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/21/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
    
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        post["arrayOfComments"] = []
     
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    class func postComment(comment: String?, forPost post: PFObject) {
        //let currentPost: Post = Post.init()
        let oldCommentsCount = post["commentsCount"]
        var newCommentsCount = (oldCommentsCount as? Int)
        newCommentsCount! += 1
        post.setObject(newCommentsCount!, forKey: "commentsCount")
        
        let currentComment = PFObject(className: "Comment")
        currentComment["text"] = comment
        let username = PFUser.currentUser()?.username
        currentComment["username"] = username
        
        currentComment["parent"] = post
        
        currentComment.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                print("Right on Right on!!!")
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
}
