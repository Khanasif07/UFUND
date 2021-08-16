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
import ImageIO
import MiSnapFacialCapture
import CoreLocation
import MiSnapSDKCamera


//class KYCMatiViewController: UIViewController, MFKYCDelegate {
class KYCMatiViewController: UIViewController , MiSnapViewControllerDelegate, MiSnapFacialCaptureViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate{
   
    
    
    private var miSnapController: MiSnapSDKViewController!
    private var livenessController: MiSnapFacialCaptureViewController!
    private let countryDefaultArray:[String] = [
           "US",
           "CA"
       ]
       
       private let documentTypeArray:[String] = [
           "DrivingLicence",
           "IdentityCard",
           "ResidencePermit",
           "Passport"
       ]
       private var countryArray:[String] = []
   
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
        loadCountyPicker()
       
       
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
    
    func loadCountyPicker() {
        let helper = TruliooHelper()
        helper.getCountryList(onSuccess: { (data, statusCode, response) in
            do{
                self.countryArray = try JSONSerialization.jsonObject(with: data) as! [String]
                print(self.countryArray)
            } catch {
                self.countryArray = self.countryDefaultArray
                print(self.countryArray)
            }
//            self.refreshPicker()
        }) { (error, statusCode, response) in
            self.countryArray = self.countryDefaultArray
//            self.refreshPicker()
            let alert = UIAlertController(title: NSLocalizedString("Connection Error", comment: ""), message: NSLocalizedString("Unable to load country list from server. Using the default value", comment: ""), preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                { action -> Void in})
            
            OperationQueue.main.addOperation {
                self.present(alert, animated: true, completion: nil)
            }
        }
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


extension KYCMatiViewController{
    func miSnapFacialCaptureSuccess(_ results: MiSnapFacialCaptureResults) {
        
    }
    
    func miSnapFacialCaptureCancelled(_ results: MiSnapFacialCaptureResults) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
}
