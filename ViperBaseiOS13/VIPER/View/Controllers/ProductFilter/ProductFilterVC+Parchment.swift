//
//  ProductFilterVC+Parchment.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import Parchment

// To display the view controllers, and how they traverse from one page to another
extension ProductFilterVC: PagingViewControllerDataSource {

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        if isFilterWithoutCategory {
          return  MenuItem(title: ProductFilterVM.shared.allTabsStrWithoutCategory[index], index: index, isSelected: filtersTabs[index].isSelected )
        } else {
            if (productType == .AllProducts){
              return  MenuItem(title: ProductFilterVM.shared.allTabsStrWithoutStatus[index], index: index, isSelected: filtersTabs[index].isSelected )
            } else{
                return  MenuItem(title: ProductFilterVM.shared.allTabsStrWithoutStatus[index], index: index, isSelected: filtersTabs[index].isSelected)
            }
        }
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.allChildVCs[index]
    }
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return isFilterWithoutCategory ? ProductFilterVM.shared.allTabsStrWithoutCategory.count : productType == .AllProducts ? ProductFilterVM.shared.allTabsStrWithoutStatus.count : ProductFilterVM.shared.allTabsStrWithoutStatus.count
    }
}

// To handle the page view object properties, and how they look in the view.
extension ProductFilterVC : PagingViewControllerDelegate, PagingViewControllerSizeDelegate{
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem {
            let text = pagingIndexItem.title
            return text.widthOfString(usingFont: isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)) + 35.0
        }
        
        return 150.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        let pagingIndexItem = pagingItem as! MenuItem
        ProductFilterVM.shared.lastSelectedIndex = pagingIndexItem.index
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, willScrollToItem pagingItem: PagingItem, startingViewController: UIViewController, destinationViewController: UIViewController) {
        let pagingIndexItem = pagingItem as! MenuItem
        ProductFilterVM.shared.lastSelectedIndex = pagingIndexItem.index
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
