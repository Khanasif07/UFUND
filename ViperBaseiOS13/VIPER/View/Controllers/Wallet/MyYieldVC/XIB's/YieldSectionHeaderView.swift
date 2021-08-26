//
//  YieldSectionHeaderView.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/07/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class YieldSectionHeaderView: UITableViewHeaderFooterView, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setSearchBar()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private func setSearchBar(){
//        self.searchBar.delegate = self
        if #available(iOS 13.0, *) {
//            self.searchBar.backgroundColor = #colorLiteral(red: 1, green: 0.3843137255, blue: 0.4235294118, alpha: 1)
            searchBar.tintColor = .white
            searchBar.setIconColor(.white)
            searchBar.setPlaceholderColor(.white)
            self.searchBar.searchTextField.font = .setCustomFont(name: .medium, size: isDeviceIPad ? .x18 : .x14)
            self.searchBar.searchTextField.textColor = .lightGray
        } else {
            // Fallback on earlier versions
        }
    }

}
