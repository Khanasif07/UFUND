//
//  CategoryListTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class CategoryListTableCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    
    var category: Categories? {
        didSet {
            self.populateData()
        }
    }
    
    var status: Status? {
        didSet {
            self.populateStatusData()
        }
    }

//    var eventType: ProductType? {
//        didSet {
//            self.populateProductType()
//        }
//    }

    
    // MARK: - View Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func populateData() {
//        self.categoryImageView.image = amenitie?.icon
        self.categoryTitleLabel.text = category?.category_name
    }
    
    private func populateStatusData() {
        //        self.categoryImageView.image = amenitie?.icon
        self.categoryTitleLabel.text = status?.title
    }
//
//
    private func populateProductType() {
//        self.amenityImageView.image = eventType?.icon
//        self.amentityTitleLabel.text = eventType?.title
    }
    
}
