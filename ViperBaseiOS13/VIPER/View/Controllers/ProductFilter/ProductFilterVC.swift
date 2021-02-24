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
    func filterApplied()
    func clearAllButtonTapped()
    
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
    var categoryListingVC : CategoryListingVC!
    var priceRangeVC      : PriceRangeVC!
    var statusVC          : StatusVC!
    var currencyVC        : CurrencyVC!
    // Parchment View
    var selectedIndex: Int = ProductFilterVM.shared.lastSelectedIndex
    var filtersTabs =  [MenuItem]()
    var currencyModelEntity : CurrencyModelEntity?
    var parchmentView : PagingViewController?
    
    //  MARK: - Variables
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
         delegate?.filterApplied()
         self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension ProductFilterVC {
    
    private func initialSetup() {
        self.setupPagerView()
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
                self.currencyVC = CurrencyVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(currencyVC)
            } else if i == 3 {
                self.statusVC = StatusVC.instantiate(fromAppStoryboard: .Filter)
                self.statusVC.statusType = .status
                self.allChildVCs.append(statusVC)
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
        for i in 0..<(ProductFilterVM.shared.allTabsStr.count){
            let obj = MenuItem(title: ProductFilterVM.shared.allTabsStr[i], index: i, isSelected: (ProductFilterVM.shared.lastSelectedIndex == i))
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
    
    //MARK:- PRDUCTS LIST API CALL
//    private func getProductsCurrenciesList() {
//        self.presenter?.HITAPI(api: Base.productsCurrencies.rawValue, params: nil, methodType: .GET, modelClass: CurrencyModelEntity.self, token: true)
//        self.loader.isHidden = false
//    }
}



//extension ProductFilterVC : PresenterOutputProtocol {
//
//    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
//        self.loader.isHidden = true
//        self.currencyModelEntity = dataDict as? CurrencyModelEntity
//        ProductFilterVM.shared.currencyListing = self.currencyModelEntity?.data ?? []
//        self.setupPagerView()
//    }
//
//    func showError(error: CustomError) {
//        self.loader.isHidden = true
//        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
//
//    }
//
//}

