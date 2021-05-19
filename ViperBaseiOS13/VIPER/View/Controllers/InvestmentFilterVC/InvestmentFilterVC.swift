//
//  InvestmentFilterVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit
import Parchment
import ObjectMapper

protocol InvestmentFilterVCDelegate: class {
    func filterApplied(_ category: ([CategoryModel], Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool),_ min_earning: (CGFloat, Bool), _ max_earning: (CGFloat, Bool),_ byRewards: ([String], Bool), _ asset_types: ([AssetTokenTypeModel], Bool), _ token_types: ([AssetTokenTypeModel], Bool) )
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool),_ min_earning: (CGFloat, Bool), _ max_eraning: (CGFloat, Bool),_ byRewards: ([String], Bool), _ asset_types: ([AssetTokenTypeModel], Bool), _ token_types: ([AssetTokenTypeModel], Bool) )
    
}

class InvestmentFilterVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
       
    
    var investmentType: MyInvestmentType = .MyProductInvestment
    // MARK: - Variables
    //===========================
    var categoryListingVC : CategoryListingVC!
    var startDateVC       : AssetsFilterDateVC!
    var priceRangeVC      : PriceRangeVC!
    var yieldVC           : PriceRangeVC!
    var endDateVC         : AssetsFilterDateVC!
    var maturityDateVC    : AssetsFilterDateVC!
    var byRewardsVC       : StatusVC!
    var assetTypeVC              : CurrencyVC!
    var tokenTypeVC              : CurrencyVC!
    // Parchment View
    var selectedIndex: Int = ProductFilterVM.shared.lastSelectedIndex
    var filtersTabs =  [MenuItem]()
    var parchmentView : PagingViewController?
    
    //  MARK: - Variables
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var isFilterApplied:Bool = false
    var allChildVCs: [UIViewController] = [UIViewController]()
    weak var delegate : InvestmentFilterVCDelegate?
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
        self.initialSetup()
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        ProductFilterVM.shared.lastSelectedIndex = 0
        delegate?.filterDataWithoutFilter((ProductFilterVM.shared.selectedCategoryListing, false), (ProductFilterVM.shared.investmentStart_from, false), (ProductFilterVM.shared.investmentStart_to, false), (ProductFilterVM.shared.minimumPrice , false), (ProductFilterVM.shared.maximumPrice , false), (ProductFilterVM.shared.investmentClose_from, false),(ProductFilterVM.shared.investmentClose_to, false), (ProductFilterVM.shared.investmentMaturity_from, false), (ProductFilterVM.shared.investmentMaturity_to, false), (ProductFilterVM.shared.minimumEarning, false), (ProductFilterVM.shared.maximumEarning, false), (ProductFilterVM.shared.byRewards, false), (ProductFilterVM.shared.selectedAssetsListing, false), (ProductFilterVM.shared.selectedTokenListing, false))
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        delegate?.filterApplied((ProductFilterVM.shared.selectedCategoryListing, !ProductFilterVM.shared.selectedCategoryListing.isEmpty), (ProductFilterVM.shared.investmentStart_from, !ProductFilterVM.shared.investmentStart_from.isEmpty), (ProductFilterVM.shared.investmentStart_to, !ProductFilterVM.shared.investmentStart_to.isEmpty), (ProductFilterVM.shared.minimumPrice , ProductFilterVM.shared.minimumPrice != 0.0), (ProductFilterVM.shared.maximumPrice , ProductFilterVM.shared.maximumPrice != 0.0), (ProductFilterVM.shared.investmentClose_from, !ProductFilterVM.shared.investmentClose_from.isEmpty),(ProductFilterVM.shared.investmentClose_to, !ProductFilterVM.shared.investmentClose_to.isEmpty), (ProductFilterVM.shared.investmentMaturity_from, !ProductFilterVM.shared.investmentMaturity_from.isEmpty), (ProductFilterVM.shared.investmentMaturity_to, !ProductFilterVM.shared.investmentMaturity_to.isEmpty), (ProductFilterVM.shared.minimumEarning, ProductFilterVM.shared.minimumEarning != 0.0), (ProductFilterVM.shared.maximumEarning, ProductFilterVM.shared.maximumEarning != 0.0), (ProductFilterVM.shared.byRewards, !ProductFilterVM.shared.byRewards.isEmpty),(ProductFilterVM.shared.selectedAssetsListing, !ProductFilterVM.shared.selectedAssetsListing.isEmpty), (ProductFilterVM.shared.selectedTokenListing, !ProductFilterVM.shared.selectedTokenListing.isEmpty))
         self.popOrDismiss(animation: true)
    }
}

// MARK: - Extension For Functions
//===========================
extension InvestmentFilterVC {
    
    private func initialSetup() {
        switch investmentType {
        case .MyProductInvestment:
            self.setupPagerViewForMyProduct()
        default:
            self.setupPagerViewForMyToken()
        }
    }
    
    private func setUpFont(){
        self.filterBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x20) : .setCustomFont(name: .medium, size: .x16)
        self.clearAllButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.applyBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.closeButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
    }
    
    private func setupPagerViewForMyProduct(isMenuReload:Bool = true) {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allTabsStrForMyPrductInvestments.count {
            if i == 0 {
                self.categoryListingVC = CategoryListingVC.instantiate(fromAppStoryboard: .Filter)
                self.categoryListingVC.categoryType = investmentType  == .MyProductInvestment ? .Products : .TokenzedAssets
                self.allChildVCs.append(categoryListingVC)
            } else if i == 3 {
                self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.startDateVC.filterDateType = .investmentStartDate
                self.allChildVCs.append(startDateVC)
            } else if i == 1 {
                self.priceRangeVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.priceRangeVC.filterPriceType = .priceRange
                self.allChildVCs.append(priceRangeVC)
            } else if i == 2 {
                self.yieldVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.yieldVC.filterPriceType = .yield
                self.allChildVCs.append(yieldVC)
            } else if i == 4 {
                self.endDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.endDateVC.filterDateType = .investmentEndDate
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
        if isMenuReload {self.initiateFilterTabsForMyProduct()}
        setupParchmentPageController(isMenuReload: isMenuReload)
        
    }
    
    private func setupPagerViewForMyToken(isMenuReload:Bool = true) {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allTabsStrForMyTokenInvestments.count {
            if i == 0 {
                self.categoryListingVC = CategoryListingVC.instantiate(fromAppStoryboard: .Filter)
                self.categoryListingVC.categoryType = investmentType  == .MyProductInvestment ? .Products : .TokenzedAssets
                self.allChildVCs.append(categoryListingVC)
            } else if i == 3 {
                self.startDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.startDateVC.filterDateType = .investmentStartDate
                self.allChildVCs.append(startDateVC)
            } else if i == 1 {
                self.priceRangeVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.priceRangeVC.filterPriceType = .priceRange
                self.allChildVCs.append(priceRangeVC)
            } else if i == 2 {
                self.byRewardsVC = StatusVC.instantiate(fromAppStoryboard: .Filter)
                self.byRewardsVC.statusType = .byRewards
                self.allChildVCs.append(byRewardsVC)
            } else if i == 4 {
                self.endDateVC = AssetsFilterDateVC.instantiate(fromAppStoryboard: .Filter)
                self.endDateVC.filterDateType = .investmentEndDate
                self.allChildVCs.append(endDateVC)
            }else if i == 5 {
                self.assetTypeVC = CurrencyVC.instantiate(fromAppStoryboard: .Filter)
                self.assetTypeVC.tokenType = .Asset
                self.allChildVCs.append(assetTypeVC)
            } else {
                self.tokenTypeVC = CurrencyVC.instantiate(fromAppStoryboard: .Filter)
                self.tokenTypeVC.tokenType = .Token
                self.allChildVCs.append(tokenTypeVC)
            }
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        if isMenuReload {self.initiateFilterTabsForMyToken()}
        setupParchmentPageController(isMenuReload: isMenuReload)
        
    }
    
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
    private func setupParchmentPageController(isMenuReload:Bool = true){
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = 10.0
        self.parchmentView?.backgroundColor = .red
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: isDeviceIPad ? 75 : 60)
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
    
    private func initiateFilterTabsForMyProduct() {
        filtersTabs.removeAll()
        for i in 0..<(ProductFilterVM.shared.allTabsStrForMyPrductInvestments.count){
            let obj = MenuItem(title: ProductFilterVM.shared.allTabsStrForMyPrductInvestments[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
            filtersTabs.append(obj)
        }
    }
    private func initiateFilterTabsForMyToken() {
        filtersTabs.removeAll()
        for i in 0..<(ProductFilterVM.shared.allTabsStrForMyTokenInvestments.count){
            let obj = MenuItem(title: ProductFilterVM.shared.allTabsStrForMyTokenInvestments[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
            filtersTabs.append(obj)
        }
    }
}

