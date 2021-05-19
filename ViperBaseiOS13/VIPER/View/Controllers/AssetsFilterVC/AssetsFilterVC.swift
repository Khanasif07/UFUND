//
//  AssetsFilterVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 24/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import Parchment
import ObjectMapper

protocol AssetsFilterVCDelegate: class {
    func filterApplied(_ category: ([CategoryModel], Bool), _ asset_types: ([AssetTokenTypeModel], Bool), _ token_types: ([AssetTokenTypeModel], Bool), _ byRewards: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool))
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ asset_types: ([AssetTokenTypeModel], Bool), _ token_types: ([AssetTokenTypeModel], Bool), _ byRewards: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool),_ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool))
    
}


class AssetsFilterVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var filterBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    var categoryListingVC   : CategoryListingVC!
    var priceVC             : PriceRangeVC!
    var assetTypeVC              : CurrencyVC!
    var tokenTypeVC              : CurrencyVC!
    var startDateVC         : AssetsFilterDateVC!
    var closingDateVC       : AssetsFilterDateVC!
    var byRewardVC          : StatusVC!
    // Parchment View
    var filtersTabs =  [MenuItem]()
    var parchmentView : PagingViewController?
    var isFilterApplied:Bool = false
    var allChildVCs: [UIViewController] = [UIViewController]()
    weak var delegate : AssetsFilterVCDelegate?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var isFilterWithoutCategory: Bool = false
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        self.view.layoutIfNeeded()
        self.dataContainerView.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.parchmentView?.view.frame = self.dataContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
        bottomView.addShadowToTopOrBottom(location: .top,color: UIColor.black16)
        clearAllButton.setCirclerCornerRadius()
        applyBtn.setCornerRadius(cornerR: 8)
        closeButton.setCornerRadius(cornerR: 8)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.parchmentView?.view.frame = self.dataContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func clearAllBtnAction(_ sender: Any) {
        ProductFilterVM.shared.resetToAllFilter(isCategorySelected: false)
        if isFilterWithoutCategory {
            setupPagerViewWithoutCategory(isMenuReload: false)
        } else {
            setupPagerView(isMenuReload: false)
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        ProductFilterVM.shared.lastSelectedIndex = 0
        delegate?.filterDataWithoutFilter((ProductFilterVM.shared.selectedCategoryListing, false), (ProductFilterVM.shared.selectedAssetsListing, false),(ProductFilterVM.shared.selectedTokenListing, false), (ProductFilterVM.shared.byRewards, false), (ProductFilterVM.shared.minimumPrice , false), (ProductFilterVM.shared.maximumPrice , false),(ProductFilterVM.shared.start_from,false),(ProductFilterVM.shared.start_to,false),(ProductFilterVM.shared.close_from,false),(ProductFilterVM.shared.close_to,false))
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        delegate?.filterApplied((ProductFilterVM.shared.selectedCategoryListing, !ProductFilterVM.shared.selectedCategoryListing.isEmpty), (ProductFilterVM.shared.selectedAssetsListing, !ProductFilterVM.shared.selectedAssetsListing.isEmpty),(ProductFilterVM.shared.selectedTokenListing, !ProductFilterVM.shared.selectedTokenListing.isEmpty), (ProductFilterVM.shared.byRewards, !ProductFilterVM.shared.byRewards.isEmpty), (ProductFilterVM.shared.minimumPrice , true), (ProductFilterVM.shared.maximumPrice , true),(ProductFilterVM.shared.start_from,!ProductFilterVM.shared.start_from.isEmpty),(ProductFilterVM.shared.start_to,!ProductFilterVM.shared.start_to.isEmpty),(ProductFilterVM.shared.close_from,!ProductFilterVM.shared.close_from.isEmpty),(ProductFilterVM.shared.close_to,!ProductFilterVM.shared.close_to.isEmpty))
        self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension AssetsFilterVC {
    
    private func initialSetup() {
        self.setUpFont()
        if isFilterWithoutCategory{
            self.setupPagerViewWithoutCategory()
        } else {
            self.setupPagerView()
        }
    }
    
    private func setUpFont(){
        self.filterBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x20) : .setCustomFont(name: .medium, size: .x16)
        self.clearAllButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.applyBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.closeButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
    }
    
    private func setupPagerView(isMenuReload:Bool = true) {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allTabsStrForAssets.count {
            if i == 0 {
                self.categoryListingVC = CategoryListingVC.instantiate(fromAppStoryboard: .Filter)
                self.categoryListingVC.categoryType = .TokenzedAssets
                self.allChildVCs.append(categoryListingVC)
            } else if i == 1 {
                self.priceVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(priceVC)
            } else if i == 2 {
                self.assetTypeVC = CurrencyVC.instantiate(fromAppStoryboard: .Filter)
                self.assetTypeVC.tokenType = .Asset
                self.allChildVCs.append(assetTypeVC)
            }else if i == 3 {
                self.tokenTypeVC = CurrencyVC.instantiate(fromAppStoryboard: .Filter)
                self.tokenTypeVC.tokenType = .Token
                self.allChildVCs.append(tokenTypeVC)
            }else if i == 4 {
                self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.startDateVC.filterDateType = .startDate
                self.allChildVCs.append(startDateVC)
            }else if i == 5{
                self.closingDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.closingDateVC.filterDateType = .closeDate
                self.allChildVCs.append(closingDateVC)
            }else if i == 6 {
                self.byRewardVC = StatusVC.instantiate(fromAppStoryboard: .Filter)
                self.byRewardVC.statusType = .byRewards
                self.allChildVCs.append(byRewardVC)
            }
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        if isMenuReload {self.initiateFilterTabs()}
        setupParchmentPageController(isMenuReload: isMenuReload)
        
    }
    
    private func setupPagerViewWithoutCategory(isMenuReload:Bool = true) {
           self.allChildVCs.removeAll()
           for i in 0..<ProductFilterVM.shared.allTabsStrForAssetsWithoutCategory.count {
             if i == 0 {
                   self.priceVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                   self.allChildVCs.append(priceVC)
               } else if i == 1 {
                   self.assetTypeVC = CurrencyVC.instantiate(fromAppStoryboard: .Filter)
                   self.assetTypeVC.tokenType = .Asset
                   self.allChildVCs.append(assetTypeVC)
               }else if i == 2 {
                   self.tokenTypeVC = CurrencyVC.instantiate(fromAppStoryboard: .Filter)
                   self.tokenTypeVC.tokenType = .Token
                   self.allChildVCs.append(tokenTypeVC)
               } else if i == 3 {
                   self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                   self.startDateVC.filterDateType = .startDate
                   self.allChildVCs.append(startDateVC)
               }else if i == 4{
                   self.closingDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                   self.closingDateVC.filterDateType = .closeDate
                   self.allChildVCs.append(closingDateVC)
               }else if i == 5 {
                   self.byRewardVC = StatusVC.instantiate(fromAppStoryboard: .Filter)
                   self.byRewardVC.statusType = .byRewards
                   self.allChildVCs.append(byRewardVC)
               }
           }
           self.view.layoutIfNeeded()
           if let _ = self.parchmentView{
               self.parchmentView?.view.removeFromSuperview()
               self.parchmentView = nil
           }
           if isMenuReload {self.initiateFilterTabsWithoutCategory()}
           setupParchmentPageController(isMenuReload: isMenuReload)
           
       }
    
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
    private func setupParchmentPageController(isMenuReload:Bool = true){
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = 10.0
        self.parchmentView?.backgroundColor = .red
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 200.0, height: isDeviceIPad ? 75 : 60)
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
        self.parchmentView?.register(nib, for: MenuItem.self)
        self.parchmentView?.indicatorColor = .clear
        self.parchmentView?.selectedTextColor = .white
        self.dataContainerView.addSubview(self.parchmentView!.view)
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: ProductFilterVM.shared.lastSelectedIndex, animated: false)
        self.parchmentView?.reloadMenu()
        self.parchmentView?.reloadData()
    }
    
    private func initiateFilterTabs() {
        filtersTabs.removeAll()
        for i in 0..<(ProductFilterVM.shared.allTabsStrForAssets.count){
            let obj = MenuItem(title: ProductFilterVM.shared.allTabsStrForAssets[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
            filtersTabs.append(obj)
        }
    }
    
    private func initiateFilterTabsWithoutCategory() {
        filtersTabs.removeAll()
        for i in 0..<(ProductFilterVM.shared.allTabsStrForAssetsWithoutCategory.count){
            let obj = MenuItem(title: ProductFilterVM.shared.allTabsStrForAssetsWithoutCategory[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
            filtersTabs.append(obj)
        }
    }
    
}
