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
    func filterApplied()
    func clearAllButtonTapped()
    
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
    
    
    // MARK: - Variables
    //===========================
    var categoryListingVC   : CategoryListingVC!
    var priceVC             : PriceRangeVC!
    var typeVC              : StatusVC!
    var startDateVC         : AssetsFilterDateVC!
    var closingDateVC       : AssetsFilterDateVC!
    var byRewardVC          : StatusVC!
    // Parchment View
    var filtersTabs =  [MenuItem]()
    var currencyModelEntity : CurrencyModelEntity?
    var parchmentView : PagingViewController?
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var isFilterApplied:Bool = false
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
        if ProductFilterVM.shared.isFilterApplied && ProductFilterVM.shared.isFilterAppliedDefault{
            ProductFilterVM.shared.resetToLocally()
            ProductFilterVM.shared.resetToDefault()
        } else {
             ProductFilterVM.shared.resetToAllFilter()
        }
        setupPagerView(isMenuReload: false)
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        ProductFilterVM.shared.lastSelectedIndex = 0
        if ProductFilterVM.shared.isLocallyReset && ProductFilterVM.shared.isFilterAppliedDefault{
            ProductFilterVM.shared.resetToLocally(isFilterApplied: true)
        }
        if !ProductFilterVM.shared.isFilterAppliedDefault{
            ProductFilterVM.shared.resetToDefault()
        }
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        ProductFilterVM.shared.isFilterAppliedDefault = true
        if !ProductFilterVM.shared.isFilterApplied {
            ProductFilterVM.shared.isFilterAppliedDefault = false
            ProductFilterVM.shared.resetToAllFilter()
         }
//         delegate?.filterApplied()
         self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension AssetsFilterVC {
    
    private func initialSetup() {
        self.setupPagerView()
    }
    
    private func setupPagerView(isMenuReload:Bool = true) {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allTabsStrForAssets.count {
            if i == 0 {
                self.categoryListingVC = CategoryListingVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(categoryListingVC)
            } else if i == 2 {
                self.priceVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(priceVC)
            } else if i == 1 {
                self.typeVC = StatusVC.instantiate(fromAppStoryboard: .Filter)
                self.typeVC.statusType = .type
                self.allChildVCs.append(typeVC)
            } else if i == 3 {
                self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(startDateVC)
            }else if i == 4{
                self.closingDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
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
        if isMenuReload {self.initiateFilterTabs()}
        setupParchmentPageController(isMenuReload: isMenuReload)
        
    }
    
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
    private func setupParchmentPageController(isMenuReload:Bool = true){
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = 10.0
        self.parchmentView?.backgroundColor = .red
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 60)
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
}
