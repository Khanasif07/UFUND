//
//  ProductFilterVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import Parchment
import ObjectMapper

protocol ProductFilterVCDelegate: class {
    func filterApplied(_ category: ([CategoryModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool))
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool))
    
}

class ProductFilterVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var mainContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var mainBackView: UIView!
       
    
    // MARK: - Variables
    //===========================
    var productType: ProductType = .AllProducts
    var isFilterWithoutCategory: Bool =  false
    var categoryListingVC : CategoryListingVC!
    var priceRangeVC      : PriceRangeVC!
    var statusVC          : StatusVC!
    var startDateVC       : AssetsFilterDateVC!
    var endDateVC         : AssetsFilterDateVC!
    var maturityDateVC        : AssetsFilterDateVC!
    // Parchment View
    var selectedIndex: Int = ProductFilterVM.shared.lastSelectedIndex
    var filtersTabs =  [MenuItem]()
    var parchmentView : PagingViewController?
    
    //  MARK: - Variables
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var allChildVCs: [UIViewController] = [UIViewController]()
    weak var delegate : ProductFilterVCDelegate?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
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
        delegate?.filterDataWithoutFilter((ProductFilterVM.shared.selectedCategoryListing, false), (ProductFilterVM.shared.status, false), (ProductFilterVM.shared.minimumPrice , true), (ProductFilterVM.shared.maximumPrice , true),(ProductFilterVM.shared.start_from, false), (ProductFilterVM.shared.start_to, false), (ProductFilterVM.shared.close_from, false),(ProductFilterVM.shared.close_to, false), (ProductFilterVM.shared.investmentMaturity_from, false), (ProductFilterVM.shared.investmentMaturity_to, false))
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        delegate?.filterApplied((ProductFilterVM.shared.selectedCategoryListing, !ProductFilterVM.shared.selectedCategoryListing.isEmpty), (ProductFilterVM.shared.status, !ProductFilterVM.shared.status.isEmpty), (ProductFilterVM.shared.minimumPrice , true), (ProductFilterVM.shared.maximumPrice , true),(ProductFilterVM.shared.start_from, !ProductFilterVM.shared.start_from.isEmpty), (ProductFilterVM.shared.start_to, !ProductFilterVM.shared.start_to.isEmpty), (ProductFilterVM.shared.close_from, !ProductFilterVM.shared.close_from.isEmpty),(ProductFilterVM.shared.close_to, !ProductFilterVM.shared.close_to.isEmpty), (ProductFilterVM.shared.investmentMaturity_from, !ProductFilterVM.shared.investmentMaturity_from.isEmpty), (ProductFilterVM.shared.investmentMaturity_to, !ProductFilterVM.shared.investmentMaturity_to.isEmpty))
         self.popOrDismiss(animation: true)
    }
}

// MARK: - Extension For Functions
//===========================
extension ProductFilterVC {
    
    private func initialSetup() {
        self.applyBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.closeButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        if isFilterWithoutCategory{
            self.setupPagerViewWithoutCategory()
        } else {
            switch productType {
            case .NewProducts,.AllProducts:
                 self.setupPagerViewWithoutStatus()
            }
        }
    }
    
    private func setupPagerView(isMenuReload:Bool = true) {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allTabsStr.count {
            if i == 0 {
                self.categoryListingVC = CategoryListingVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(categoryListingVC)
            } else if i == 1 {
                self.priceRangeVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(priceRangeVC)
            } else if i == 2 {
                self.statusVC = StatusVC.instantiate(fromAppStoryboard: .Filter)
                self.statusVC.statusType = .status
                self.allChildVCs.append(statusVC)
            }else if i == 3 {
                self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.startDateVC.filterDateType = .startDate
                self.allChildVCs.append(startDateVC)
            } else if i == 4 {
                self.endDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.endDateVC.filterDateType = .closeDate
                self.allChildVCs.append(endDateVC)
            } else {
                self.maturityDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.maturityDateVC.filterDateType = .investmentMaturityDate
                self.allChildVCs.append(maturityDateVC)
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
    
    private func setupPagerViewWithoutStatus(isMenuReload:Bool = true) {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allTabsStrWithoutStatus.count {
            if i == 0 {
                self.categoryListingVC = CategoryListingVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(categoryListingVC)
            } else if i == 1 {
                self.priceRangeVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(priceRangeVC)
            }else if i == 2 {
                self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.startDateVC.filterDateType = .startDate
                self.allChildVCs.append(startDateVC)
            } else if i == 3 {
                self.endDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.endDateVC.filterDateType = .closeDate
                self.allChildVCs.append(endDateVC)
            } else {
                self.maturityDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.maturityDateVC.filterDateType = .investmentMaturityDate
                self.allChildVCs.append(maturityDateVC)
            }
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        if isMenuReload {self.initiateFilterTabsWithoutStatus()}
        setupParchmentPageController(isMenuReload: isMenuReload)
        
    }
       
    
    private func setupPagerViewWithoutCategory(isMenuReload:Bool = true) {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allTabsStrWithoutCategory.count {
            if i == 0 {
                self.priceRangeVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(priceRangeVC)
            } else if i == 1 {
                self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.startDateVC.filterDateType = .startDate
                self.allChildVCs.append(startDateVC)
            } else if i == 2 {
                self.endDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.endDateVC.filterDateType = .closeDate
                self.allChildVCs.append(endDateVC)
            } else {
                self.maturityDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.maturityDateVC.filterDateType = .investmentMaturityDate
                self.allChildVCs.append(maturityDateVC)
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
        for i in 0..<(ProductFilterVM.shared.allTabsStr.count){
            let obj = MenuItem(title: ProductFilterVM.shared.allTabsStr[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
            filtersTabs.append(obj)
        }
    }
    
    private func initiateFilterTabsWithoutStatus() {
           filtersTabs.removeAll()
           for i in 0..<(ProductFilterVM.shared.allTabsStrWithoutStatus.count){
               let obj = MenuItem(title: ProductFilterVM.shared.allTabsStrWithoutStatus[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
               filtersTabs.append(obj)
           }
       }
       
    
    private func initiateFilterTabsWithoutCategory() {
        filtersTabs.removeAll()
        for i in 0..<(ProductFilterVM.shared.allTabsStrWithoutCategory.count){
            let obj = MenuItem(title: ProductFilterVM.shared.allTabsStrWithoutCategory[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
            filtersTabs.append(obj)
        }
    }
    
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.4 : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = true) {
        UIView.animate(withDuration: animated ? 0.4 : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = -(self.mainContainerView.frame.height)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if shouldRemove {
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
    }
}

