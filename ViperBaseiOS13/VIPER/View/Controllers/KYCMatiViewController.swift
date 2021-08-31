//
//  KYCMatiViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 29/06/20.
//  Copyright © 2020 CSS. All rights reserved.
//





import UIKit
//import MatiGlobalIDSDK
import ObjectMapper



//class KYCMatiViewController: UIViewController, MFKYCDelegate {
class KYCMatiViewController: UIViewController {
   
    
    
   
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var verifyMeBtn: UIButton!
    @IBOutlet weak var verifiedView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    var userDetails: UserDetails?
    var userProfile: UserProfile?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
//    let matiButton = MFKYCButton()
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super .viewWillLayoutSubviews()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        
        self.loadProfileDetails()
        
    }
    @IBAction func closeBtnAction(_ sender: UIButton) {
        presentAlertViewController()
    }
    
    @IBAction func verifyMeBtnAction(_ sender: UIButton) {
        switch User.main.trulioo_kyc_status ?? 0 {
        case 0:
            if verifyMeBtn.titleLabel?.text == "Check Status" {
                self.loadProfileDetails()
            } else {
                guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCViewController) as? KYCViewController  else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            let vc =  Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCViewController) as? KYCViewController  else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: MFKYCDelegate
    
    func mfKYCLoginSuccess(identityId: String) {
        print("Mati Login Success",identityId)
        self.loadProfileDetails()
    }
    
    func mfKYCLoginCancelled() {
        print("Mati Login Cancelled")
        self.loadProfileDetails()
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
    
    func getLogout() {
        self.loader.isHidden = false
        var param = [String: AnyObject]()
        param[RegisterParam.keys.id] = User.main.id as AnyObject
        self.presenter?.HITAPI(api: Base.logout.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: true)
    }

}

//MARK: - PresenterOutputProtocol
extension KYCMatiViewController: PresenterOutputProtocol {
    
    func loadProfileDetails() {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: UserDetails.self, token: true)
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch nullStringToEmpty(string: api) {
            
        case Base.profile.rawValue:
               self.loader.isHidden = true
               self.userDetails = dataDict as? UserDetails
               self.userProfile = self.userDetails?.user
               User.main.kyc = self.userProfile?.kyc
               User.main.trulioo_kyc_status = self.userProfile?.trulioo_kyc_status
               storeInUserDefaults()
            switch User.main.trulioo_kyc_status ?? 0 {
            case 0:
                if  User.main.is_document_submitted == true {
                    verifyMeBtn.setTitle("Check Status", for: .normal)
                    infoLbl.text = "Document verification is under process. This process will take upto 20 minutes."
                }else {
                    verifyMeBtn.setTitle("Verify your identity", for: .normal)
                }
            case 1:
                verifyMeBtn.setTitle("Finish", for: .normal)
                infoLbl.text =   "Document verification is completed."
            default:
                verifyMeBtn.setTitle("Retry", for: .normal)
                infoLbl.text =  "Document verification is failed. Please initiate verification again."
            }
        case Base.logout.rawValue:
            self.loader.isHidden = true
            self.drawerController?.closeSide()
            forceLogout(with: SuccessMessage.string.logoutMsg.localize())
            
//            if User.main.trulioo_kyc_status == 1 {
//
//                buttonView.isHidden = true
//                verifiedView.isHidden = false
//
//                statusLbl.text = Constants.string.sucessKYC.localize()
//                statusLbl.textColor = .white
//                verifiedView.backgroundColor = UIColor(hex: "#34C759").withAlphaComponent(0.75)
//
//            } else if User.main.kyc == 2 {
//                buttonView.isHidden = true
//                              verifiedView.isHidden = false
//
//                statusLbl.text = Constants.string.failedKyc.localize()
//                 statusLbl.textColor =  UIColor(hex: "#FA376B")
//                verifiedView.backgroundColor = UIColor(hex: "#FA376B").withAlphaComponent(0.75)
//
//            }  else if User.main.kyc == 3 {
//
//                buttonView.isHidden = true
//                              verifiedView.isHidden = false
//
//                 statusLbl.textColor =  UIColor(hex: "#FA376B")
//                 statusLbl.text = Constants.string.pendingKyc.localize()
//                 verifiedView.backgroundColor = UIColor(hex: "#FBFBE4")
//            } else {
//                verifyMeBtn.isHidden = false
//                buttonView.isHidden = false
//                verifiedView.isHidden = true
//
//            }
        default:
            break
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title: nullStringToEmpty(string: error.localizedDescription), state: .error)
    }
}
