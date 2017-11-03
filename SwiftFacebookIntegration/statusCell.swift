//
//  statusCell.swift
//  SwiftFacebookIntegration
//
//  Created by Shobha V J on 2017-11-01.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit

class statusCell: UITableViewCell {

    @IBOutlet weak var username4: UILabel!
    
    @IBOutlet weak var timeLbl4: UILabel!
    @IBOutlet weak var dateLbl4: UILabel!
    @IBOutlet weak var profilePicStatus: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
