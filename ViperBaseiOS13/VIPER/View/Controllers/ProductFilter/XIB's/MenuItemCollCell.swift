//
//  MenuItemCollCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

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

class MenuItemCollCell: PagingCell ,UICollectionViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dotView.layer.cornerRadius = 2.0
        self.dotView.backgroundColor = .green
    }
    
    open override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
         if let item = pagingItem as? MenuItem {
            self.title.text = item.title
            self.dotView.isHidden = item.isSelected
            self.title.font = selected ? UIFont.boldSystemFont(ofSize: 14.0) : UIFont.boldSystemFont(ofSize: 13.0)
        }
     }
}
