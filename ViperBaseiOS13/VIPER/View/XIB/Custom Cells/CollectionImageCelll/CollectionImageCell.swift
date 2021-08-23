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
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgView.layer.cornerRadius = 4.0
    }
    @IBAction func uploadBtnAction(_ sender: UIButton) {
        if let handle = uploadBtnTapped{
            handle(sender)
        }
    }
    
}
