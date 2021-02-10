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
    
    @IBAction func profileRedirect(_ sender: UIButton) {
        self.drawerController?.closeSide()
        self.push(to: Storyboard.Ids.UserProfileVC)
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
    var sideMenuImg: [UIImage]?
    var buttonArray = [UIButton]()
    
    var isFromCampainer = false
    {
        
        didSet {
            
            if isFromCampainer {
                
                menuContent = [(Constants.string.dashboard.localize(),[]),(Constants.string.myProfile.localize(),[]),(Constants.string.tokenRequests.localize(),[]),(Constants.string.Products.localize(),[]),(Constants.string.history.localize(),[]),(Constants.string.wallet.localize(),[]),(Constants.string.Notification.localize(),[])]
                sideMenuImg =   [#imageLiteral(resourceName: "icDashboard"),#imageLiteral(resourceName: "icProfile"),#imageLiteral(resourceName: "sideVynil"),#imageLiteral(resourceName: "icProducts"),#imageLiteral(resourceName: "historyIcon"),#imageLiteral(resourceName: "sideWallet"),#imageLiteral(resourceName: "whiteNotify"),#imageLiteral(resourceName: "SideSecurity"),#imageLiteral(resourceName: "logout")]
                
            } else {
                menuContent = [(Constants.string.dashboard.localize(),[]),(Constants.string.myProfile.localize(),[]),(Constants.string.categories.localize(),[]),(Constants.string.Products.localize(),[]),(Constants.string.TokenizedAssets.localize(),[]),(Constants.string.allInvestment.localize(),[]),(Constants.string.logout.localize(),[])]
                sideMenuImg =   [#imageLiteral(resourceName: "icDashboard"),#imageLiteral(resourceName: "icProfile"),#imageLiteral(resourceName: "icCategories"),#imageLiteral(resourceName: "icProducts"),#imageLiteral(resourceName: "icTokenized"),#imageLiteral(resourceName: "SideSecurity"),#imageLiteral(resourceName: "icLogout")]
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
        profileImg.backgroundColor = .white
        profileName.textColor = .white
        tableView.delegate = self
        tableView.dataSource = self
//        investButton.titleEdgeInsets.left = 40
//        campaignerButton.titleEdgeInsets.left = 40
//
        let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: User.main.picture))
        profileImg.sd_setImage(with: url , placeholderImage: nil)
        profileImg.contentMode = .scaleAspectFill
        profileImg.clipsToBounds = true
        profileName.text = nullStringToEmpty(string: User.main.name)
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
        tableView.reloadData()
    }
       
    
    @IBAction func campaignerButtonClickEvent(_ sender: UIButton) {
        
        UserDefaults.standard.set(UserType.campaigner.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
        setUpUserType()
//        self.drawerController?.closeSide()
//        self.push(to: Storyboard.Ids.HomeViewController)
        
    }
    
    @IBAction func investButtonClickEvent(_ sender: UIButton) {
        
        UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
        setUpUserType()
        //        self.drawerController?.closeSide()
        //        self.push(to: Storyboard.Ids.HomeViewController)
        
    }
    
    @IBAction func topCloseBtnAction(_ sender: UIButton) {
        self.drawerController?.closeSide()
        self.push(to: Storyboard.Ids.HomeViewController)
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
        view.imageView?.image = sideMenuImg?[section]
        view.titleLbl.text = nullStringToEmpty(string: menuContent?[section].0)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15 * tableView.frame.height / 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10 * tableView.frame.height / 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SideMenuTableCell.self, indexPath: indexPath)
//        cell.backgroundColor = .clear
        cell.imgView.image = sideMenuImg?[indexPath.section]
        cell.titleLbl.text = nullStringToEmpty(string: menuContent?[indexPath.section].1[indexPath.row])
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    func sectionTappedAction(section: Int){
//        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row,section: 0)) as? SideMenuCell
        switch menuContent?[section].0 {
        case Constants.string.profile.localize():
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.EditProfileViewController)
        case Constants.string.Products.localize():
            if self.menuContent?[section].1.isEmpty ?? true{
                self.menuContent?[section].1 = ["My Product","New Product","All Product"]
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                }, completion: {res in })
                tableView.reloadData()
            } else {
                self.menuContent?[section].1 = []
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                }, completion: {res in })
                tableView.reloadData()
            }
//            self.drawerController?.closeSide()
//            self.push(to: Storyboard.Ids.ProductViewController)
        case Constants.string.TokenizedAssets.localize():
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.TokenizedAssetsListViewController)
        case Constants.string.Investors.localize():
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.InvestmentViewController)
        case Constants.string.MyProducts.localize():
            self.drawerController?.closeSide()
            
            //
            if let isFromCamp = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as?  String {
                switch  isFromCamp
                {
                case UserType.investor.rawValue:
                    UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.TokenProductViewController) as? TokenProductViewController else { return }
                    vc.tileStr = Constants.string.my.localize()
                    vc.toInvestesrAllProducts = true
                    
                    (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
                    
                    
                    
                default:
                    UserDefaults.standard.set(UserType.campaigner.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.TokenProductViewController) as? TokenProductViewController else { return }
                    vc.tileStr = Constants.string.my.localize()
                    vc.toInvestesrAllProducts = false
                    
                    (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
                }
                
            }
            
            
        case Constants.string.wallet.localize():
            
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.WalletViewController)
            
        case Constants.string.Notification.localize():
            
            
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.NotificationViewController)
            
        case Constants.string.security.localize():
            
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.SecurityViewController)
            
        case Constants.string.dashboard.localize():
            
            
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.HomeViewController)
            
        case Constants.string.tokenRequests.localize():
            
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.TokenRequestViewController)
            
        case Constants.string.allProduct.localize():
            self.drawerController?.closeSide()

            if isFromCampainer {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.TokenProductViewController) as! TokenProductViewController
                viewController.tileStr = Constants.string.all.localize()
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(viewController, animated: true)
            } else {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.ProductListViewController) as! ProductListViewController
                viewController.tileStr = Constants.string.all.localize()
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(viewController, animated: true)
            }

            
        case Constants.string.InvestorSide.localize():
            
            UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.HomeViewController)
            
        case Constants.string.campaignerSide.localize():
            
            UserDefaults.standard.set(UserType.campaigner.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.HomeViewController)
            
        case Constants.string.history.localize():
            
            UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
            
            
            
            if isFromCampainer {
                self.drawerController?.closeSide()
                self.push(to: Storyboard.Ids.CampHistoryViewController)
            } else {
                self.drawerController?.closeSide()
                self.push(to: Storyboard.Ids.HistoryViewController)
            }
            
            
        case Constants.string.coinpay.localize():
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.PayClearHistoryViewController)
        case Constants.string.logout.localize():
            
            
            presentAlertViewController()
            
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
