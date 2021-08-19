//
//  CollectionImageCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 07/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class CollectionImageCell: UICollectionViewCell {
    
    var uploadBtnTapped: ((UIButton)->())?

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var documNameLbl: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func uploadBtnAction(_ sender: UIButton) {
        if let handle = uploadBtnTapped{
            handle(sender)
        }
    }
    
}
