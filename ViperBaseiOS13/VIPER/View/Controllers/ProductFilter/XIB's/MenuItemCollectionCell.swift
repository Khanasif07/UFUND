//
//  MenuItemCollectionCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

import UIKit
import Parchment

struct MenuItem : PagingItem ,Hashable, Comparable {
    static func < (lhs: MenuItem, rhs: MenuItem) -> Bool {
         return lhs.index < rhs.index
    }
    
    static func ==(lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.title == rhs.title &&
            lhs.index == rhs.index
    }
    
    var title: String
    var index: Int
    var isSelected: Bool = true
    
    init(title: String,index: Int,isSelected: Bool = true){
        self.title = title
        self.index = index
        self.isSelected = isSelected
    }
    
    var hashValue: Int {
      return title.hashValue
    }
}

class MenuItemCollectionCell: PagingCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataContainerView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9333333333, blue: 0.937254902, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.setCirclerCornerRadius()
    }
    
    open override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
         if let item = pagingItem as? MenuItem {
            self.title.text = item.title
            self.title.textColor = selected ? .white : .black
            self.title.font = selected ? UIFont.boldSystemFont(ofSize: 12.0) : UIFont.boldSystemFont(ofSize: 11.0)
            self.dataContainerView.backgroundColor = selected ? .red : #colorLiteral(red: 0.9568627451, green: 0.9333333333, blue: 0.937254902, alpha: 1)
        }
     }
}
