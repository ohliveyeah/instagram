//
//  SearchTableViewCell.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/24/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import ParseUI

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
