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
//        loadCountyPicker()
       
       
//        MFKYC.register(clientId: MFKYC_CLIENTID)
//        matiButton.frame = CGRect(x: 0, y:0, width: buttonView.frame.width, height: buttonView.frame.height)
//        self.buttonView.addSubview(matiButton)
//        MFKYC.instance.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super .viewWillLayoutSubviews()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        
        self.loadProfileDetails()
        
    }
    
    @IBAction func verifyMeBtnAction(_ sender: UIButton) {
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCViewController) as? KYCViewController  else { return }
        self.navigationController?.pushViewController(vc, animated: true)
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
               
            storeInUserDefaults()
            
            
            if User.main.kyc == 1 {
                
                buttonView.isHidden = true
                verifiedView.isHidden = false
             
                statusLbl.text = Constants.string.sucessKYC.localize()
                statusLbl.textColor = .white
                verifiedView.backgroundColor = UIColor(hex: "#34C759").withAlphaComponent(0.75)
                
            } else if User.main.kyc == 2 {
                buttonView.isHidden = true
                              verifiedView.isHidden = false
                              
                statusLbl.text = Constants.string.failedKyc.localize()
                 statusLbl.textColor =  UIColor(hex: "#FA376B")
                verifiedView.backgroundColor = UIColor(hex: "#FA376B").withAlphaComponent(0.75)
                
            }  else if User.main.kyc == 3 {
                
                buttonView.isHidden = true
                              verifiedView.isHidden = false
                             
                 statusLbl.textColor =  UIColor(hex: "#FA376B")
                 statusLbl.text = Constants.string.pendingKyc.localize()
                 verifiedView.backgroundColor = UIColor(hex: "#FBFBE4")
            } else {
                verifyMeBtn.isHidden = false
                buttonView.isHidden = false
                verifiedView.isHidden = true
               
            }
        default:
            break
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title: nullStringToEmpty(string: error.localizedDescription), state: .error)
    }
}
