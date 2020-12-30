//
//  SideMenuController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 16/03/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class SideMenuCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class SideMenuController: UIViewController {

    @IBAction func profileRedirect(_ sender: UIButton) {
        self.drawerController?.closeSide()
        self.push(to: Storyboard.Ids.EditProfileViewController)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var campaignerButton: UIButton!
    @IBOutlet weak var investButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var parentView: UIView!
    var menuContent : [String]?
    var sideMenuImg: [UIImage]?
   
   var isFromCampainer = false
   {
    
       didSet {
           
           if isFromCampainer {
               
            menuContent = [Constants.string.tokenRequests.localize(),Constants.string.MyProducts.localize(),Constants.string.history.localize(),Constants.string.wallet.localize(),Constants.string.Notification.localize(),Constants.string.security.localize(),Constants.string.logout.localize()]
               sideMenuImg =   [#imageLiteral(resourceName: "sideVynil"),#imageLiteral(resourceName: "sideSoild"),#imageLiteral(resourceName: "historyIcon"),#imageLiteral(resourceName: "sideWallet"),#imageLiteral(resourceName: "whiteNotify"),#imageLiteral(resourceName: "SideSecurity"),#imageLiteral(resourceName: "logout")]
               
           } else {
               menuContent = [Constants.string.allProduct.localize(),Constants.string.MyProducts.localize(),Constants.string.history.localize(),Constants.string.coinpay.localize(),Constants.string.wallet.localize(),Constants.string.Notification.localize(),Constants.string.security.localize(),Constants.string.logout.localize()]
               sideMenuImg =   [#imageLiteral(resourceName: "sideSoild"),#imageLiteral(resourceName: "sideSoild"),#imageLiteral(resourceName: "historyIcon"),#imageLiteral(resourceName: "historyIcon"),#imageLiteral(resourceName: "sideWallet"),#imageLiteral(resourceName: "whiteNotify"),#imageLiteral(resourceName: "SideSecurity"),#imageLiteral(resourceName: "logout")]
           }
       }
   }
   
   private lazy var loader  : UIView = {
               return createActivityIndicator(self.view)
   }()

    var isSelectInvester = true {
        
        didSet {
            
            if isSelectInvester {
                
                investButton.backgroundColor = UIColor.white
                campaignerButton.backgroundColor = UIColor(hex: primaryColor)
                campaignerButton.setTitleColor(UIColor.white, for: .normal)
                investButton.setTitleColor(UIColor(hex: primaryColor), for: .normal)
                
            } else {
                
              investButton.backgroundColor = UIColor(hex: primaryColor)
              campaignerButton.backgroundColor = UIColor.white
              investButton.setTitleColor(UIColor.white, for: .normal)
              campaignerButton.setTitleColor(UIColor(hex: primaryColor), for: .normal)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.backgroundColor = .white
        profileName.textColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        investButton.titleEdgeInsets.left = 40
        campaignerButton.titleEdgeInsets.left = 40
        
        let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: User.main.picture))
        profileImg.sd_setImage(with: url , placeholderImage: nil)
        profileImg.contentMode = .scaleAspectFill
        profileImg.clipsToBounds = true
        profileName.text = nullStringToEmpty(string: User.main.name)
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          
        
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       
        profileImg.setCirclerCornerRadius()
        campaignerButton.setTitle(Constants.string.campaignerSide.localize(), for: .normal)
        investButton.setTitle(Constants.string.InvestorSide.localize(), for: .normal)
    }
    
    @IBAction func campaignerButtonClickEvent(_ sender: UIButton) {
        
        UserDefaults.standard.set(UserType.campaigner.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
        self.drawerController?.closeSide()
        self.push(to: Storyboard.Ids.HomeViewController)
        
    }
    
    @IBAction func investButtonClickEvent(_ sender: UIButton) {
        
                UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
               self.drawerController?.closeSide()
               self.push(to: Storyboard.Ids.HomeViewController)
        
    }
    
}



//MARK: - UITableViewDelegate & UITableViewDataSource
extension SideMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuContent?.count ?? 0 > 0 ?  menuContent?.count ?? 0 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15 * tableView.frame.height / 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SideMenuCell, for: indexPath) as! SideMenuCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.imageView?.image = sideMenuImg?[indexPath.row]
        cell.titleLbl.text = nullStringToEmpty(string: menuContent?[indexPath.row])
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row,section: 0)) as? SideMenuCell
        switch nullStringToEmpty(string: cell?.titleLbl.text) {
        case Constants.string.profile.localize():
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.EditProfileViewController)
        case Constants.string.Products.localize():
            
            self.drawerController?.closeSide()
            self.push(to: Storyboard.Ids.ProductViewController)
            
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
    
    @objc func viewSelectedList(sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func push(to identifier : String) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: identifier)
        (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
}



extension  SideMenuController {
    
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
