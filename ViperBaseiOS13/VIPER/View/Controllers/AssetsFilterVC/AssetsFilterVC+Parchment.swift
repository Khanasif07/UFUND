//
//  AssetsFilterVC+Parchment.swift
//  ViperBaseiOS13
//
//  Created by Admin on 24/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import Parchment

// To display the view controllers, and how they traverse from one page to another
extension AssetsFilterVC: PagingViewControllerDataSource {

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
        return isFilterWithoutCategory ?  MenuItem(title: ProductFilterVM.shared.allTabsStrForAssetsWithoutCategory[index], index: index, isSelected: filtersTabs[index].isSelected ) : MenuItem(title: ProductFilterVM.shared.allTabsStrForAssets[index], index: index, isSelected: filtersTabs[index].isSelected )
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.allChildVCs[index]
    }
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return  isFilterWithoutCategory ? ProductFilterVM.shared.allTabsStrForAssetsWithoutCategory.count : ProductFilterVM.shared.allTabsStrForAssets.count
    }
}

// To handle the page view object properties, and how they look in the view.
extension AssetsFilterVC : PagingViewControllerDelegate, PagingViewControllerSizeDelegate{
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem {
            let text = pagingIndexItem.title
            
            let font = UIFont.boldSystemFont(ofSize: 12.0)
            return text.widthOfString(usingFont: font) + 35.0
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
