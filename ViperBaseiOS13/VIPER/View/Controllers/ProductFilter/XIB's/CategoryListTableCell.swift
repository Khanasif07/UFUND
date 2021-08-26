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
    
    var byCurrency: CurrencyType? {
        didSet {
            self.populatebyCurrencyData()
        }
    }
    
    var currency: AssetTokenTypeModel? {
        didSet {
            self.populateCurrencyData()
        }
    }
    
    var transactionType: TransactionTypeModel? {
        didSet {
            self.populateTransactionData()
        }
    }
    
    
    // MARK: - View Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryTitleLabel.font =  isDeviceIPad ? .setCustomFont(name: .regular, size: .x20) : .setCustomFont(name: .regular, size: .x15)
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
    
    private func populateTransactionData() {
        self.categoryTitleLabel.text = transactionType?.type
    }
    
    private func populatebyRewardsData(){
         self.categoryTitleLabel.text = byRewards?.title
    }
    
    private func populatebyCurrencyData(){
         self.categoryTitleLabel.text = byCurrency?.title
    }
    
}
