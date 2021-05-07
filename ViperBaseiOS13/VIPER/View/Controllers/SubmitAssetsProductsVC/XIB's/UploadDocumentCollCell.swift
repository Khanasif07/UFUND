//
//  UploadDocumentCollCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 31/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class UploadDocumentCollCell: UICollectionViewCell {

    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var documentImgView: UIImageView!
    
    var documentBtnTapped: ((UIButton)->())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadowView(view: shadowView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productNameLbl.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x14) : .setCustomFont(name: .regular, size: .x10)
        DispatchQueue.main.async {
            self.productImg.layer.masksToBounds = true
            self.productImg.layer.cornerRadius = self.productImg.bounds.width / 2
        }
    }
    
    @IBAction func uploadBtnAction(_ sender: UIButton) {
        if let handle = documentBtnTapped{
            handle(sender)
        }
    }
    
}
