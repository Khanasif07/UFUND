//
//  SideMenuController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 16/03/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import SDWebImage

class SideMenuController: UIViewController {
    
    @IBOutlet weak var profileLastName: UILabel!
    @IBAction func profileRedirect(_ sender: UIButton) {
//        if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.UserProfileVC)
//        }
        //        self.push(to: Storyboard.Ids.EditProfileViewController)
    }
    @IBOutlet weak var topCloseBtn: UIButton!
    @IBOutlet weak var topRoundedView: UIView!
    @IBOutlet weak var buttonContainerStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var campaignerButton: UIButton!
    @IBOutlet weak var investButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var parentView: UIView!
    
    
    var menuContent : [(String,[String])]?
    var sideMenuImg: [(UIImage,[UIImage])]?
    var buttonArray = [UIButton]()
    
    var isFromCampainer = false
    {
        
        didSet {
            
            if isFromCampainer {
                
                menuContent = [(Constants.string.myProfile.localize(),[]),(Constants.string.categories.localize(),[]),(Constants.string.submit_assets.localize(),[]),(Constants.string.allMyProduct.localize(),[]),(Constants.string.allMyTokenizedAssets.localize(),[]),(Constants.string.wallet.localize(),[]),(Constants.string.send_coin.localize(),[]),(Constants.string.setting.localize(),[]),(Constants.string.contactUs.localize(),[]),(Constants.string.logout.localize(),[])]
                sideMenuImg =   [(#imageLiteral(resourceName: "icProfile"),[#imageLiteral(resourceName: "icProfile")]),(#imageLiteral(resourceName: "icCategories"),[#imageLiteral(resourceName: "icCategories")]),(#imageLiteral(resourceName: "icSubmitAssets"),[#imageLiteral(resourceName: "icSubmitAssets")]),(#imageLiteral(resourceName: "icProducts"),[#imageLiteral(resourceName: "icProducts"),#imageLiteral(resourceName: "icProducts"),#imageLiteral(resourceName: "icProducts"),#imageLiteral(resourceName: "icProducts"),#imageLiteral(resourceName: "icProducts")]),(#imageLiteral(resourceName: "icTokenized"),[#imageLiteral(resourceName: "icTokenized"),#imageLiteral(resourceName: "icTokenized"),#imageLiteral(resourceName: "icTokenized"),#imageLiteral(resourceName: "icTokenized"),#imageLiteral(resourceName: "icTokenized")]),(#imageLiteral(resourceName: "icWallet"),[#imageLiteral(resourceName: "icWallet")]),(#imageLiteral(resourceName: "icSendCoin"),[]),(#imageLiteral(resourceName: "Image"),[]),(#imageLiteral(resourceName: "icContactUs"),[]),(#imageLiteral(resourceName: "icLogout"),[])]
                
            } else {
                menuContent = [(Constants.string.myProfile.localize(),[]),(Constants.string.categories.localize(),[]),(Constants.string.Products.localize(),[]),(Constants.string.TokenizedAssets.localize(),[]),(Constants.string.allMyInvestment.localize(),[]),(Constants.string.wallet.localize(),[]),(Constants.string.send_coin.localize(),[]),(Constants.string.myYield.localize(),[]),(Constants.string.setting.localize(),[]),(Constants.string.contactUs.localize(),[]),(Constants.string.logout.localize(),[])]
                sideMenuImg =   [(#imageLiteral(resourceName: "icProfile"),[#imageLiteral(resourceName: "icProfile")]),(#imageLiteral(resourceName: "icCategories"),[#imageLiteral(resourceName: "icCategories")]),(#imageLiteral(resourceName: "icProducts"),[#imageLiteral(resourceName: "icProducts"),#imageLiteral(resourceName: "icProducts")]),(#imageLiteral(resourceName: "icTokenized"),[#imageLiteral(resourceName: "icTokenized"),#imageLiteral(resourceName: "icTokenized")]),(#imageLiteral(resourceName: "icInvestments"),[#imageLiteral(resourceName: "icInvestments"),#imageLiteral(resourceName: "icInvestments")]),(#imageLiteral(resourceName: "icWallet"),[#imageLiteral(resourceName: "icWallet")]),(#imageLiteral(resourceName: "icSendCoin"),[]),(#imageLiteral(resourceName: "send_token"),[]),(#imageLiteral(resourceName: "Image"),[]),(#imageLiteral(resourceName: "icContactUs"),[]),(#imageLiteral(resourceName: "icLogout"),[])]
            }
        }
    }
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    var isSelectInvester = true {
        didSet {
            if isSelectInvester {
                investButton.backgroundColor = UIColor(hex: primaryColor)
                campaignerButton.backgroundColor = UIColor.white
                campaignerButton.setTitleColor(UIColor(hex: primaryColor), for: .normal)
                investButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                investButton.backgroundColor = UIColor.white
                campaignerButton.backgroundColor = UIColor(hex: primaryColor)
                investButton.setTitleColor(UIColor(hex: primaryColor), for: .normal)
                campaignerButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        self.tableView.registerCell(with: SideMenuTableCell.self)
        self.tableView.registerHeaderFooter(with: SideMenuHeaderView.self)
        profileImg.backgroundColor = .clear
        profileName.textColor = .white
        profileLastName.textColor = .white
        tableView.delegate = self
        tableView.dataSource = self
//        let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: User.main.picture))
        let url = URL.init(string: nullStringToEmpty(string: User.main.picture))
        profileImg.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "icPlaceHolder"))
        profileImg.contentMode = .scaleAspectFill
        profileImg.clipsToBounds = true
        profileName.text = nullStringToEmpty(string: User.main.name)
        profileLastName.isHidden = User.main.email?.isEmpty ?? true
        profileLastName.text = nullStringToEmpty(string: User.main.email)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUpUserType()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        topCloseBtn.setCirclerCornerRadius()
        profileImg.setCirclerCornerRadius()
        campaignerButton.setTitle(Constants.string.campaignerSide.localize(), for: .normal)
        investButton.setTitle(Constants.string.InvestorSide.localize(), for: .normal)
    }
    
    
    private func setupViews() {
        buttonContainerStackView.layer.cornerRadius = 10.0
    }
    
    private func setupButtons() {
        buttonArray = [investButton, campaignerButton]
        buttonArray.forEach({$0.borderLineWidth = 0.5})
        buttonArray.forEach({$0.borderColor = UIColor.red})
        investButton.roundCorners([.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 8)
        campaignerButton.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner], radius: 8)
        topRoundedView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10)
        investButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x15) : .setCustomFont(name: .semiBold, size: .x13)
        campaignerButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x15) : .setCustomFont(name: .semiBold, size: .x13)
        profileName.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
         profileLastName.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .medium, size: .x12)
        
    }
    
    private func setUpUserType(){
        if let isFromCamp = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as?  String {
            switch  isFromCamp
            {
            case UserType.investor.rawValue:
                isFromCampainer = false
                isSelectInvester = true
            default:
                isSelectInvester = false
                isFromCampainer = true
            }
        }
//        let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: User.main.picture))
        let url = URL.init(string: nullStringToEmpty(string: User.main.picture))
        profileImg.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "icPlaceHolder"))
        profileImg.contentMode = .scaleAspectFill
        profileImg.clipsToBounds = true
        profileName.text = nullStringToEmpty(string: User.main.name)
        profileLastName.isHidden = User.main.email?.isEmpty ?? true
        profileLastName.text = nullStringToEmpty(string: User.main.email)
        tableView.reloadData()
    }
    
    func rotateLeft(dropdownView: UIView,left: CGFloat = -1) {
        UIView.animate(withDuration: 1.0, animations: {
            dropdownView.transform = CGAffineTransform(rotationAngle: ((180.0 * CGFloat(Double.pi)) / 180.0) * CGFloat(left))
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func campaignerButtonClickEvent(_ sender: UIButton) {
        if !isKycIncompleted(){
        UserDefaults.standard.set(UserType.campaigner.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
        setUpUserType()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserTypeChanged"), object: nil)
        }
        //  2      self.drawerController?.closeSide()
        //        self.push(to: Storyboard.Ids.HomeViewController)
        
    }
    
    @IBAction func investButtonClickEvent(_ sender: UIButton) {
        if !isKycIncompleted(){
        UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
        setUpUserType()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserTypeChanged"), object: nil)
        }
        //   1     self.drawerController?.closeSide()
        //        self.push(to: Storyboard.Ids.HomeViewController)
        
    }
    
    @IBAction func topCloseBtnAction(_ sender: UIButton) {
        if !isKycIncompleted(){
        self.drawerController?.closeSide()
        self.push(to: Storyboard.Ids.HomeViewController)
        }
    }
    
}



//MARK: - UITableViewDelegate & UITableViewDataSource
extension SideMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuContent?.count ?? 0 > 0 ?  menuContent?.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuContent?[section].1.endIndex ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: SideMenuHeaderView.self)
        view.headerBtnAction  = {  [weak self] (sender)  in
            guard let selff = self else { return }
            selff.sectionTappedAction(section: section)
        }
        view.backgroundColor = .clear
        view.imageView?.image = sideMenuImg?[section].0
        switch self.menuContent?[section].0 {
        case Constants.string.TokenizedAssets.localize():
            view.dropdownView?.isHidden = false
            self.rotateLeft(dropdownView: view.dropdownView,left : (self.menuContent?[section].1.isEmpty ?? true) ? 0 : -1)
        case Constants.string.allMyInvestment.localize():
            view.dropdownView?.isHidden = false
            self.rotateLeft(dropdownView: view.dropdownView,left : (self.menuContent?[section].1.isEmpty ?? true) ? 0 : -1)
        case Constants.string.Products.localize():
            view.dropdownView?.isHidden = false
            self.rotateLeft(dropdownView: view.dropdownView,left : (self.menuContent?[section].1.isEmpty ?? true) ? 0 : -1)
        case Constants.string.allMyProduct.localize():
            view.dropdownView?.isHidden = false
            self.rotateLeft(dropdownView: view.dropdownView,left : (self.menuContent?[section].1.isEmpty ?? true) ? 0 : -1)
        case Constants.string.allMyTokenizedAssets.localize():
            view.dropdownView?.isHidden = false
            self.rotateLeft(dropdownView: view.dropdownView,left : (self.menuContent?[section].1.isEmpty ?? true) ? 0 : -1)
        default:
            view.dropdownView?.isHidden = true
        }
        view.titleLbl.text = nullStringToEmpty(string: menuContent?[section].0)
        view.titleLbl.textColor = (nullStringToEmpty(string: menuContent?[section].0) == Constants.string.logout.localize()) ? #colorLiteral(red: 1, green: 0.1215686277, blue: 0.1764705926, alpha: 1) :  (menuContent?[section].1.isEmpty ?? true) ?   #colorLiteral(red: 0.160784319, green: 0.160784319, blue: 0.160784319, alpha: 0.7049664456) :  #colorLiteral(red: 0.160784319, green: 0.160784319, blue: 0.160784319, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isDeviceIPad {
             return 10 * tableView.frame.height / 100
        } else {
            return 12.5 * tableView.frame.height / 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isDeviceIPad {
            return 7.5 * tableView.frame.height / 100
        } else {
            return 10 * tableView.frame.height / 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SideMenuTableCell.self, indexPath: indexPath)
        cell.imgView.image = sideMenuImg?[indexPath.section].1[indexPath.row]
        cell.titleLbl.text = nullStringToEmpty(string: menuContent?[indexPath.section].1[indexPath.row])
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menuContent?[indexPath.section].0 {
        case Constants.string.Products.localize():
            if self.menuContent?[indexPath.section].1[indexPath.row] ?? "" == Constants.string.allProduct.localize(){
                self.drawerController?.closeSide()
                    let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.allProducts.localize()
                    vc.productType = .AllProducts
                    (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            } else if self.menuContent?[indexPath.section].1[indexPath.row] ?? "" == Constants.string.newProduct.localize(){
                self.drawerController?.closeSide()
                let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.newProducts.localize()
                vc.productType = .NewProducts
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            }
        case Constants.string.TokenizedAssets.localize():
            if self.menuContent?[indexPath.section].1[indexPath.row] ?? "" == Constants.string.newTokenizedAssets.localize(){
                self.drawerController?.closeSide()
                let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.newTokenizedAssets.localize()
                vc.assetType = .NewAssets
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            } else if self.menuContent?[indexPath.section].1[indexPath.row] ?? "" == Constants.string.allTokenizedAssets.localize(){
                self.drawerController?.closeSide()
                let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.allTokenizedAssets.localize()
                vc.assetType = .AllAssets
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            }
            
        case Constants.string.allMyInvestment.localize():
            self.drawerController?.closeSide()
            if self.menuContent?[indexPath.section].1[indexPath.row] ?? "" == Constants.string.myTokenInvestMents.localize(){
                let vc = MyInvestmentVC.instantiate(fromAppStoryboard: .Products)
                vc.investmentType = .MyTokenInvestment
                vc.productTitle = Constants.string.myTokenInvestMents.localize()
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            } else if self.menuContent?[indexPath.section].1[indexPath.row] ?? "" == Constants.string.myProductInvestMents.localize(){
                let vc = MyInvestmentVC.instantiate(fromAppStoryboard: .Products)
                vc.investmentType = .MyProductInvestment
                vc.productTitle = Constants.string.myProductInvestMents.localize()
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            }
            
        case Constants.string.allMyProduct.localize():
            switch self.menuContent?[indexPath.section].1[indexPath.row] ?? "" {
            case Constants.string.allProducts.localize():
                self.drawerController?.closeSide()
                let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.allProducts.localize()
                vc.campaignerProductType = .AllProduct
                vc.productType = .AllProducts
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            case Constants.string.liveProduct.localize():
                self.drawerController?.closeSide()
                let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.liveProduct.localize()
                vc.productType = .AllProducts
                vc.campaignerProductType = .LiveProduct
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            case Constants.string.pendingProduct.localize():
                self.drawerController?.closeSide()
                let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.pendingProduct.localize()
                vc.productType = .AllProducts
                vc.campaignerProductType = .PendingProduct
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            case Constants.string.soldProduct.localize():
                self.drawerController?.closeSide()
                let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.soldProduct.localize()
                vc.productType = .AllProducts
                vc.campaignerProductType = .SoldProduct
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            default:
                self.drawerController?.closeSide()
                let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.rejectedProduct.localize()
                vc.productType = .AllProducts
                vc.campaignerProductType = .RejectedProduct
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
                print("Do Nothing")
            }
        case Constants.string.allMyTokenizedAssets.localize():
            switch self.menuContent?[indexPath.section].1[indexPath.row] ?? "" {
            case Constants.string.allTokens.localize():
                self.drawerController?.closeSide()
                let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.allTokens.localize()
                vc.campaignerAssetType = .AllAssets
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            case Constants.string.liveTokens.localize():
                self.drawerController?.closeSide()
                let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.liveTokens.localize()
                vc.campaignerAssetType = .LiveAssets
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            case Constants.string.pendingTokens.localize():
                self.drawerController?.closeSide()
                let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.pendingTokens.localize()
                vc.campaignerAssetType = .PendingAssets
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            case Constants.string.soldTokens.localize():
                self.drawerController?.closeSide()
                let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.soldTokens.localize()
                vc.campaignerAssetType = .SoldAssets
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            default:
                self.drawerController?.closeSide()
                let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                vc.productTitle = Constants.string.rejectedTokens.localize()
                vc.campaignerAssetType = .RejectedAssets
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            }
        default:
            print("Do Nothing")
        }
    }
    
    @objc func viewSelectedList(sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func push(to identifier : String) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: identifier)
        (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
}



extension  SideMenuController {
    
    private func isKycIncompleted()->Bool {
        if User.main.kyc == 0{
             ToastManager.show(title: "Your profile KYC is not verified! Please update your details for KYC. If already submitted please wait for KYC Approval.",state: .error)
            return true
        }
        if (User.main.signup_by ?? "") == "5" {
            if !(User.main.social_email_verify ?? true) {
                ToastManager.show(title: "Please verify your email first." ,state: .error)
                return true
            }
        }
        return false
    }
    
    func sectionTappedAction(section: Int){
        //        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row,section: 0)) as? SideMenuCell
        switch menuContent?[section].0 {
        case Constants.string.submit_assets.localize():
            if !isKycIncompleted() {
            self.drawerController?.closeSide()
            let vc = SubmitAssetsProductsVC.instantiate(fromAppStoryboard: .Products)
            self.navigationController?.pushViewController(vc, animated: true)
            }
        case Constants.string.send_coin.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            let vc = SendCoinVC.instantiate(fromAppStoryboard: .Wallet)
            self.navigationController?.pushViewController(vc, animated: true)
            }
        case Constants.string.profile.localize(),Constants.string.myProfile.localize():
//            if !isKycIncompleted() {
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.UserProfileVC)
//            }
        case Constants.string.Products.localize():
            if !isKycIncompleted(){
            if self.menuContent?[section].1.isEmpty ?? true{
                self.menuContent?[section].1 = [Constants.string.newProduct.localize(),Constants.string.allProduct.localize()]
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            } else {
                self.menuContent?[section].1 = []
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            }
            }
        case Constants.string.changePassword.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Products)
            (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            }
        case Constants.string.wallet.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            let vc = MyWalletVC.instantiate(fromAppStoryboard: .Wallet)
            (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            }
        case Constants.string.categories.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.CategoriesVC)
            }
        case Constants.string.TokenizedAssets.localize():
            if !isKycIncompleted(){
            if self.menuContent?[section].1.isEmpty ?? true{
                self.menuContent?[section].1 = [Constants.string.newTokenizedAssets.localize(),Constants.string.allTokenizedAssets.localize()]
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            } else {
                self.menuContent?[section].1 = []
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
                }
            }
        case Constants.string.setting.localize():
            self.drawerController?.closeSide()
            let vc = SettingVC.instantiate(fromAppStoryboard: .Products)
            (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
        case Constants.string.allMyInvestment.localize():
            if !isKycIncompleted(){
            if self.menuContent?[section].1.isEmpty ?? true{
                self.menuContent?[section].1 = [Constants.string.myProductInvestMents.localize(),Constants.string.myTokenInvestMents.localize()]
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            } else {
                self.menuContent?[section].1 = []
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            }
            }
            
        case Constants.string.allMyProduct.localize():
            if !isKycIncompleted(){
            if self.menuContent?[section].1.isEmpty ?? true{
                self.menuContent?[section].1 = [Constants.string.allProduct.localize(),Constants.string.liveProduct.localize(),Constants.string.pendingProduct.localize(),Constants.string.soldProduct.localize(),Constants.string.rejectedProduct.localize()]
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            } else {
                self.menuContent?[section].1 = []
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            }
            }
        case Constants.string.allMyTokenizedAssets.localize():
            if !isKycIncompleted(){
            if self.menuContent?[section].1.isEmpty ?? true{
                self.menuContent?[section].1 = [Constants.string.allTokens.localize(),Constants.string.liveTokens.localize(),Constants.string.pendingTokens.localize(),Constants.string.soldTokens.localize(),Constants.string.rejectedTokens.localize()]
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            } else {
                self.menuContent?[section].1 = []
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            }
            }
        case Constants.string.Investors.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.InvestmentViewController)
            }
        case Constants.string.MyProducts.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            
            //
            if let isFromCamp = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as?  String {
//                switch  isFromCamp
//                {
//                case UserType.investor.rawValue:
//                    UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
//                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.TokenProductViewController) as? TokenProductViewController else { return }
//                    vc.tileStr = Constants.string.my.localize()
//                    vc.toInvestesrAllProducts = true
//
//                    (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
//
//
//
//                default:
//                    UserDefaults.standard.set(UserType.campaigner.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
//                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.TokenProductViewController) as? TokenProductViewController else { return }
//                    vc.tileStr = Constants.string.my.localize()
//                    vc.toInvestesrAllProducts = false
//
//                    (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
//                }
                
            }
            }
            
            
        case Constants.string.wallet.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.WalletViewController)
            }
            
        case Constants.string.Notification.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.NotificationViewController)
            }
            
        case Constants.string.security.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.SecurityViewController)
            }
            
        case Constants.string.dashboard.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.HomeViewController)
            }
            
        case Constants.string.tokenRequests.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.TokenRequestViewController)
            }
            
        case Constants.string.logout.localize():
            self.presentAlertViewController()
        case Constants.string.contactUs.localize():
            let vc = ContactsUsVC.instantiate(fromAppStoryboard: .Products)
            self.navigationController?.pushViewController(vc, animated: true)
            
//        case Constants.string.allProduct.localize():
//            if !isKycIncompleted(){
//            self.drawerController?.closeSide()
//            if isFromCampainer {
//                let viewController = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.TokenProductViewController) as! TokenProductViewController
//                viewController.tileStr = Constants.string.all.localize()
//                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(viewController, animated: true)
//            } else {
//                let viewController = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.ProductListViewController) as! ProductListViewController
//                viewController.tileStr = Constants.string.all.localize()
//                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(viewController, animated: true)
//            }
//            }
            
            
        case Constants.string.InvestorSide.localize():
            if !isKycIncompleted(){
            UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.HomeViewController)
            }
            
        case Constants.string.campaignerSide.localize():
            if !isKycIncompleted(){
            UserDefaults.standard.set(UserType.campaigner.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.HomeViewController)
            }
            
        case Constants.string.history.localize():
            if !isKycIncompleted(){
            UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
            if isFromCampainer {
                self.drawerController?.closeSide()
                self.push(to: Storyboard.Ids.CampHistoryViewController)
            } else {
                self.drawerController?.closeSide()
                self.push(to: Storyboard.Ids.HistoryViewController)
            }
            }
        case Constants.string.coinpay.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.PayClearHistoryViewController)
            }
        case Constants.string.logout.localize():
            presentAlertViewController()
        case Constants.string.myYield.localize():
            if !isKycIncompleted(){
            self.drawerController?.closeSide()
            let myYieldVC = MyYieldVC.instantiate(fromAppStoryboard: .Wallet)
            (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(myYieldVC, animated: true)
            }
            
        default:
            break
        }
    }
    
    func presentAlertViewController() {
        
        
        let alertController = UIAlertController(title: Constants.string.appName.localize(), message: Constants.string.areYouSureWantToLogout.localize(), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: Constants.string.OK.localize(), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            
            self.getLogout()
        }
        
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.drawerController?.closeSide()
            self.dismiss(animated: true, completion: nil)
        }
        
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

//MARK: - PresenterOutputProtocol

extension SideMenuController: PresenterOutputProtocol {
    
    func getLogout() {
        self.loader.isHidden = false
        var param = [String: AnyObject]()
        param[RegisterParam.keys.id] = User.main.id as AnyObject
        self.presenter?.HITAPI(api: Base.logout.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: true)
    }
    
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
            
        case Base.logout.rawValue:
            self.loader.isHidden = true
            self.drawerController?.closeSide()
            forceLogout(with: SuccessMessage.string.logoutMsg.localize())
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
