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
    
    
    var category: CategoryModel? {
        didSet {
            self.populateData()
        }
    }
    
    var status: Status? {
        didSet {
            self.populateStatusData()
        }
    }
    
    var type: AssetsType? {
           didSet {
               self.populateTypeData()
           }
       }
    
    var byRewards: AssetsByReward? {
        didSet {
            self.populatebyRewardsData()
        }
    }
    
    var currency: AssetTokenTypeModel? {
        didSet {
            self.populateCurrencyData()
        }
    }
    
    // MARK: - View Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func populateData() {
        self.categoryTitleLabel.text = category?.category_name
    }
    
    private func populateTypeData(){
         self.categoryTitleLabel.text = type?.title
    }
    
    private func populateStatusData() {
        self.categoryTitleLabel.text = status?.title
    }
    
    private func populateCurrencyData() {
        self.categoryTitleLabel.text = currency?.name
    }
    
    private func populatebyRewardsData(){
         self.categoryTitleLabel.text = byRewards?.title
    }
    
}
