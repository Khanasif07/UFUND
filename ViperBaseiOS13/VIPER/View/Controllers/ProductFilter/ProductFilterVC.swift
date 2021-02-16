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
    func doneButtonTapped()
    func clearAllButtonTapped()
    
}


class ProductFilterVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
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
    var filtersTabs =  [MenuItem]()
    var productModelEntity : ProductModelEntity?
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
        self.categoryListingVC.selectedCategoryListing = []
        ProductFilterVM.shared.status = []
        ProductFilterVM.shared.currency = []
        statusVC.tableView.reloadData()
        currencyVC.tableView.reloadData()
        delegate?.clearAllButtonTapped()
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        delegate?.doneButtonTapped()
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
         self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension ProductFilterVC {
    
    private func initialSetup() {
        self.setupPagerView()
        self.getProductList()
    }
    
    private func setupPagerView() {
        self.allChildVCs.removeAll()
        for i in 0..<ProductFilterVM.shared.allTabsStr.count {
            if i == 0 {
                self.categoryListingVC = CategoryListingVC.instantiate(fromAppStoryboard: .Filter)
                categoryListingVC.categoryListing = productModelEntity?.categories
                self.allChildVCs.append(categoryListingVC)
            } else if i == 1 {
                self.priceRangeVC = PriceRangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(priceRangeVC)
            } else if i == 2 {
                self.currencyVC = CurrencyVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(currencyVC)
            } else if i == 3 {
                self.statusVC = StatusVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(statusVC)
            }
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        self.initiateFilterTabs()
        setupParchmentPageController()
        
    }
    
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
    private func setupParchmentPageController(){
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
        self.parchmentView?.select(index: 0)
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
    }
    
    private func initiateFilterTabs() {
        filtersTabs.removeAll()
        for i in 0..<(ProductFilterVM.shared.allTabsStr.count){
            let obj = MenuItem(title: ProductFilterVM.shared.allTabsStr[i], index: i, isSelected: ProductFilterVM.shared.allTabsStr[i] == Constants.string.category.localize())
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
    private func getProductList() {
        switch (userType,false) {
        case (UserType.campaigner.rawValue,false):
            self.presenter?.HITAPI(api: Base.myProductList.rawValue, params: nil, methodType: .GET, modelClass: ProductModel.self, token: true)
        case (UserType.investor.rawValue,false):
            self.presenter?.HITAPI(api: Base.investorAllProducts.rawValue, params: nil, methodType: .GET, modelClass: ProductModelEntity.self, token: true)
        case (UserType.investor.rawValue,true):
            self.presenter?.HITAPI(api: Base.investerProducts.rawValue, params: nil, methodType: .GET, modelClass: ProductModel.self, token: true)
        default:
            break
        }
        self.loader.isHidden = false
    }
}



extension ProductFilterVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        self.productModelEntity = dataDict as? ProductModelEntity
        self.setupPagerView()
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
        
    }
 
}

