//
//  MissionUpdateTableViewCell.swift
//  XLambton
//
//  Created by user143339 on 8/19/18.
//  Copyright © 2018 user143339. All rights reserved.
//

import UIKit

class MissionUpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var imfManNOTUSE: UIImageView!
    @IBOutlet weak var lblTracoNOTUSE: UILabel!
    @IBOutlet weak var imgMan: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgCam: UIImageView!
    @IBOutlet weak var imgMail: UIImageView!
    @IBOutlet weak var btnCam: UIButton!
    @IBOutlet weak var btnMail: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
