//
//  VideoCellTableViewCell.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-10-25.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit
import AVFoundation

class imageCell: UITableViewCell {
    
    @IBOutlet weak var userName1: UILabel!
    @IBOutlet weak var dateLbl1: UILabel!
    @IBOutlet weak var profilePic1: UIImageView!
    @IBOutlet weak var locationLbl1: UILabel!
    @IBOutlet weak var timeLbl1: UILabel!
    @IBOutlet weak var images1: UIImageView!
    @IBOutlet weak var storyDetailsLbl1: UILabel!
    @IBOutlet weak var videoPlayerSuperView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   
}

