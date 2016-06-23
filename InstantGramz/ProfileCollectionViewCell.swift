//
//  ProfileCollectionViewCell.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/22/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!

}
