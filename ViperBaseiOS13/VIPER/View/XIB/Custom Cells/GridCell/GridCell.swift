//
//  GridCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 25/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {

    @IBOutlet weak var decriptionLbl: UILabel!
    @IBOutlet weak var readyLbl: UILabel!
    @IBOutlet weak var webImgView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        readyLbl.text =  Constants.string.ReadyForApp.localize()
//        readyLbl.text =  Constants.string.ReadyForApp.localize().uppercased()
    }

}
