//
//  MyYieldFilterVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 01/06/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import Parchment

class MyYieldFilterVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    var categoryListingVC : CategoryListingVC!
    var startDateVC       : AssetsFilterDateVC!
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
        clearBtn.setCirclerCornerRadius()
        applyBtn.setCornerRadius(cornerR: 8)
        cancelBtn.setCornerRadius(cornerR: 8)
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
    @IBAction func cancelbtnAction(_ sender: UIButton) {
        ProductFilterVM.shared.lastSelectedIndex = 0
        delegate?.filterDataWithoutFilter((ProductFilterVM.shared.selectedCategoryListing, false), (ProductFilterVM.shared.status, false), (ProductFilterVM.shared.minimumPrice , true), (ProductFilterVM.shared.maximumPrice , true),(ProductFilterVM.shared.start_from, false), (ProductFilterVM.shared.start_to, false), (ProductFilterVM.shared.close_from, false),(ProductFilterVM.shared.close_to, false), (ProductFilterVM.shared.investmentMaturity_from, false), (ProductFilterVM.shared.investmentMaturity_to, false))
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        delegate?.filterApplied((ProductFilterVM.shared.selectedCategoryListing, !ProductFilterVM.shared.selectedCategoryListing.isEmpty), (ProductFilterVM.shared.status, !ProductFilterVM.shared.status.isEmpty), (ProductFilterVM.shared.minimumPrice , true), (ProductFilterVM.shared.maximumPrice , true),(ProductFilterVM.shared.start_from, !ProductFilterVM.shared.start_from.isEmpty), (ProductFilterVM.shared.start_to, !ProductFilterVM.shared.start_to.isEmpty), (ProductFilterVM.shared.close_from, !ProductFilterVM.shared.close_from.isEmpty),(ProductFilterVM.shared.close_to, !ProductFilterVM.shared.close_to.isEmpty), (ProductFilterVM.shared.investmentMaturity_from, !ProductFilterVM.shared.investmentMaturity_from.isEmpty), (ProductFilterVM.shared.investmentMaturity_to, !ProductFilterVM.shared.investmentMaturity_to.isEmpty))
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func clearAllBtnAction(_ sender: UIButton) {
        ProductFilterVM.shared.resetToAllFilter(isCategorySelected: false)
        setupPagerView(isMenuReload: false)
        }
}

// MARK: - Extension For Functions
//===========================
extension MyYieldFilterVC {
    
    private func initialSetup() {
        self.setUpFont()
        self.setupPagerView()
    }
    
    private func setUpFont(){
        self.filterBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x20) : .setCustomFont(name: .medium, size: .x16)
        self.cancelBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.applyBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.clearBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
    }
    
    private func setupPagerView(isMenuReload:Bool = true) {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allYieldTabsStr.count {
            if i == 0 {
                self.categoryListingVC = CategoryListingVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(categoryListingVC)
            } else if i == 1 {
                self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.startDateVC.filterDateType = .startDate
                self.allChildVCs.append(startDateVC)
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
           for i in 0..<(ProductFilterVM.shared.allYieldTabsStr.count){
               let obj = MenuItem(title: ProductFilterVM.shared.allYieldTabsStr[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
               filtersTabs.append(obj)
           }
       }
}
