//
//  SettingVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 27/04/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import ObjectMapper
import UIKit

class SettingVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    private lazy var loader  : UIView = {
          return createActivityIndicator(self.view)
      }()
    var dataArray = [(Constants.string.changePassword.localize(),#imageLiteral(resourceName: "icChnagePassword")),(Constants.string.terms_conditions.localize(),#imageLiteral(resourceName: "icTermCondition")),(Constants.string.privacy_policy.localize(),#imageLiteral(resourceName: "icPrivacyPolicy")),(Constants.string.contactUs.localize(),#imageLiteral(resourceName: "icContactUs")),(Constants.string.logout.localize(),#imageLiteral(resourceName: "icLogout"))]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension SettingVC {
    
    private func initialSetup() {
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: SettingTableCell.self)
    }
    
    func presentAlertViewController() {
        let alertController = UIAlertController(title: Constants.string.appName.localize(), message: Constants.string.areYouSureWantToLogout.localize(), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: Constants.string.OK.localize(), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.getLogout()
        }
        
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - Extension For TableView
//===========================
extension SettingVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueCell(with: SettingTableCell.self, indexPath: indexPath)
        cell.titleLbl.text = dataArray[indexPath.row].0
        cell.titleImgView.image = dataArray[indexPath.row].1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isDeviceIPad ? 65.0  :  51.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataArray[indexPath.row].0 {
        case Constants.string.changePassword.localize():
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Products)
            self.navigationController?.pushViewController(vc, animated: true)
        case Constants.string.terms_conditions.localize():
            let vc = WebViewControllerVC.instantiate(fromAppStoryboard: .Products)
            vc.webViewType = .termsCondition
            self.navigationController?.pushViewController(vc, animated: true)
        case Constants.string.logout.localize():
            self.presentAlertViewController()
        case Constants.string.contactUs.localize():
            let vc = ContactsUsVC.instantiate(fromAppStoryboard: .Products)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = WebViewControllerVC.instantiate(fromAppStoryboard: .Products)
            vc.webViewType = .privacyPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: - PresenterOutputProtocol

extension SettingVC: PresenterOutputProtocol {
    
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
