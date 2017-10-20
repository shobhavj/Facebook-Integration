//
//  PostTableViewCell.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-10-18.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    var nameFromFb: String? = nil
    @IBOutlet weak var usernameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLbl.text = nameFromFb
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
