//
//  EditProfileViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 25/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import MatiGlobalIDSDK

class EditProfileViewController: UIViewController, MFKYCDelegate {
    
    @IBAction func profileClickEvent(_ sender: UIButton) {
        isSelectProfile = true
    }
    
    @IBAction func kycClickEvent(_ sender: UIButton) {
        isSelectProfile = false
    
    }
    
    @objc func updatedKYC(_ sender: UIButton) {
       
    }
     @IBOutlet weak var statusLbl: UILabel!
       @IBOutlet weak var verifiedView: UIView!
      @IBOutlet weak var subNoteLbl: UILabel!
      @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var kycView: UIView!
   
    @IBOutlet weak var kycLbl: UILabel!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var outerProfileView: UIView!
    @IBOutlet weak var profileInnerView: UIView!
    @IBOutlet weak var kycInnerView: UIView!
    @IBOutlet weak var kycOutterView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var emailIdTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var editPrfoile: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    var userDetails: UserDetails?
    var userProfile: UserProfile?
    var kycDetail: KYCDetail?
    var imageData : Data?
    var param  =  [String:Any]()
    var dataDic =  [String:(Data,String,String)]()
    let matiButton = MFKYCButton()
    var viewEffect = 0 {
        didSet {
            
            UIView.animate(withDuration: 0.1) {
                for view in self.stackView.subviews {
                    
                    view.applyEffectToView()
                    
                }
            }
        }
    }
    var kycDocumentAlreadyUploaded = [KYCUpdatedDocument]()
    var kycDocument = [Document]()
     var kycVerifyDoc = [KYCVerifiyDoc]()
    

    var viewEffectOnTextFld = 0 {
        didSet {
            
            UIView.animate(withDuration: 0.1) {

            }
        }
    }
    
    @IBOutlet weak var profileSaveView: UIView!
    @IBOutlet weak var profileSelView: UIView!
    
    var isEnableEdit = false {
        
        didSet {
            
            if isEnableEdit {
                
                firstNameTxtFld.isUserInteractionEnabled = true
                lastNameTxtFld.isUserInteractionEnabled = true
                phoneNumberTxtFld.isUserInteractionEnabled = true
                emailIdTxtFld.isUserInteractionEnabled = false
                saveButton.isHidden = false
                editPrfoile.isHidden = true
                titleLbl.text = Constants.string.editProfile.localize().uppercased()
                cameraView.isHidden = false
            } else {
                firstNameTxtFld.isUserInteractionEnabled = false
                lastNameTxtFld.isUserInteractionEnabled = false
                phoneNumberTxtFld.isUserInteractionEnabled = false
                //emailIdTxtFld.isUserInteractionEnabled = false
                saveButton.isHidden = true
                editPrfoile.isHidden = false
                titleLbl.text = Constants.string.profile.localize().uppercased()
                cameraView.isHidden = true
            }
        }
    }
    
    var isSelectProfile = true {
        
        didSet {
            
            if isSelectProfile {
                
                profileInnerView.isHidden = true
                
                profileLbl.textColor = UIColor(hex: appBGColor)
                kycLbl.textColor = UIColor(hex: darkTextColor)
                kycInnerView.isHidden = false
                kycView.isHidden = true
                profileSaveView.isHidden = false
                profileSelView.isHidden = false
                
            } else
            {
                
                profileInnerView.isHidden = false
                profileLbl.textColor = UIColor(hex: darkTextColor)
                kycLbl.textColor = UIColor(hex: appBGColor)
                kycInnerView.isHidden = true
                kycView.isHidden = false
                profileSaveView.isHidden = true
                profileSelView.isHidden = true
                
                
                
                
            }
        }
    }
    
    private lazy var loader  : UIView =
    {
     
        return createActivityIndicator(self.view)
        
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
       // MFKYC.register(clientId: MFKYC_CLIENTID)
        matiButton.frame = CGRect(x: 0, y:0, width: buttonView.frame.width, height: buttonView.frame.height)
        self.buttonView.addSubview(matiButton)
       // MFKYC.instance.delegate = self
        
        overrideUserInterfaceStyle = .light
        
        kycOutterView.setGradientBackgroundForView()
        outerProfileView.setGradientBackgroundForView()
        
        profileInnerView.backgroundColor = UIColor(hex: appBGColor)
        kycInnerView.backgroundColor = UIColor(hex: appBGColor)
        isSelectProfile = true
        
        
        cameraView.setGradientBackgroundForView()
        cameraView.layer.cornerRadius = cameraView.frame.height / 2
        cameraView.maskToBounds = true
        
        viewEffectOnTextFld = 0
        viewEffect = 0
        
        emailIdTxtFld.keyboardType = .emailAddress
        phoneNumberTxtFld.keyboardType = .numberPad
        
        firstNameTxtFld.delegate = self
        lastNameTxtFld.delegate = self
        phoneNumberTxtFld.delegate = self
        emailIdTxtFld.delegate = self
        
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        profileImg.layer.masksToBounds = true
        profileImg.clipsToBounds = true
        
        saveButton.setGradientBackground()
        titleLbl.textColor = UIColor(hex: darkTextColor)
        
        firstNameTxtFld.applyEffectToTextField(placeHolderString: Constants.string.firstName.localize())
        lastNameTxtFld.applyEffectToTextField(placeHolderString: Constants.string.lastName.localize())
        phoneNumberTxtFld.applyEffectToTextField(placeHolderString: Constants.string.phoneNumber.localize())
        emailIdTxtFld.applyEffectToTextField(placeHolderString: Constants.string.emailId.localize())
        
        changePasswordButton.setTitleColor(UIColor(hex: darkTextColor), for: .normal)
        
        editPrfoile.setTitleColor(UIColor(hex: darkTextColor), for: .normal)
        
        isEnableEdit = false
       
        saveButton.addTarget(self, action: #selector(updateProfile(sender:)), for: .touchUpInside)
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
          
          getProfileDetails()
           
       }
    
    //MARK: MFKYCDelegate
       
       func mfKYCLoginSuccess(identityId: String) {
           print("Mati Login Success",identityId)
           self.getProfileDetails()
       }
       
       func mfKYCLoginCancelled() {
           print("Mati Login Cancelled")
           self.getProfileDetails()
       }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localize()
          
    }
    
    @IBAction func changeProfilePic(_ sender: UIButton)
       {
               self.showImage { (image) in
               let proImg : UIImage = image!
               self.profileImg.image = proImg
               self.imageData = proImg.jpegData(compressionQuality: 0.2)!
               
           }
           
       }
}

//MARK: - Localization
extension EditProfileViewController
{
    
    func localize()
    {
    
        profileLbl.text  = Constants.string.profile.localize().uppercased()
        kycLbl.text = Constants.string.kyc.localize().uppercased()
        saveButton.setTitle(Constants.string.save.localize().uppercased(), for: .normal)
        changePasswordButton.setTitle(Constants.string.lookingChangePassword.localize(), for: .normal)
        editPrfoile.setTitle(Constants.string.editProfile.localize(), for: .normal)
        
    }
}


//MARK: - Button Action
extension EditProfileViewController {
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ChangeViewController) as? ChangeViewController else { return }
        vc.userProfile = self.userProfile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveClikcEvent(_ sender: UIButton) {
        isEnableEdit = false
    }
    
    @IBAction func editProfileClick(_ sender: UIButton)
    {
   
        isEnableEdit = true
 
    }
    
    @IBAction func updateProfile(sender:UIButton)
    {
        guard let firstName = self.firstNameTxtFld.text, !firstName.isEmpty else
        {
          return  ToastManager.show(title: "Please Enter First Name", state: .warning)
            
        }
        
        guard let lastName = self.lastNameTxtFld.text, !lastName.isEmpty else {
            
          return  ToastManager.show(title: "Please Enter Last Name", state: .warning)
            
        }
        
        guard let mobileNumber = self.phoneNumberTxtFld.text , !mobileNumber.isEmpty else
        {
           return  ToastManager.show(title: "Please Enter Mobile Number", state: .warning)
        }
        
        
        if imageData != nil {
            
            param[ProfileUpdate.keys.name] = firstName
            param[ProfileUpdate.keys.mobile] = mobileNumber
            param[ProfileUpdate.keys.last_name] = lastName
            self.dataDic = [ProfileUpdate.keys.picture : (self.imageData!,"Profile.jpg",FileType.image.rawValue)]
            self.presenter?.UploadData(api: Base.profile.rawValue, params: param, imageData: dataDic , methodType: .POST, modelClass: UserDetails.self, token: true)
            
  
        } else {
            
            param[ProfileUpdate.keys.name] = firstName
            param[ProfileUpdate.keys.mobile] = mobileNumber
            param[ProfileUpdate.keys.last_name] = lastName
            self.presenter?.HITAPI(api: Base.profile.rawValue, params: param, methodType: .POST, modelClass: UserDetails.self, token: true)
    
            
        }
        
    }
 
}

//MARK: - UITextField Delegate
extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
}

//MARK: - PresenterOutputProtocol

extension EditProfileViewController: PresenterOutputProtocol {
    
   
    
    func getProfileDetails()
    {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: UserDetails.self, token: true)
    }
    
    func getKYC()
    {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.kyc.rawValue, params: nil, methodType: .GET, modelClass: KYCDetail.self, token: true)
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
            
        case Base.profile.rawValue:
        self.loader.isHidden = true
        self.userDetails = dataDict as? UserDetails
        self.userProfile = self.userDetails?.user
        self.imageData = nil
        User.main.kyc = self.userProfile?.kyc
        User.main.pin_status =  self.userProfile?.app_pin_status
        User.main.g2f_temp =  self.userProfile?.g2f_status
        storeInUserDefaults()
        
        if self.userProfile != nil
        {
            
             firstNameTxtFld.text = nullStringToEmpty(string:  self.userProfile?.name)
             lastNameTxtFld.text = nullStringToEmpty(string: self.userProfile?.last_name)
             phoneNumberTxtFld.text = nullStringToEmpty(string: self.userProfile?.mobile)
             emailIdTxtFld.text = nullStringToEmpty(string: self.userProfile?.email)
             let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: self.userProfile?.picture))
            self.profileImg.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "profile"))
            self.profileImg.backgroundColor = UIColor(hex: primaryColor)

            
        }
            
            
            
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
                           
                           buttonView.isHidden = false
                           verifiedView.isHidden = true
                          
                       }
            
 
        case Base.kyc.rawValue:
            
            self.loader.isHidden = true
            self.kycDocument.removeAll()
            self.kycDocumentAlreadyUploaded.removeAll()
            self.kycVerifyDoc.removeAll()
            
            self.kycDetail = dataDict as? KYCDetail
            self.kycDocument = self.kycDetail?.document ?? []
            self.userProfile = self.kycDetail?.user
            self.kycDocumentAlreadyUploaded = self.kycDetail?.kyc_document ?? []
            
            if self.userProfile != nil {
                       
            }
            
            
            for dic in kycDocument {
                          
                          let newValue = self.kycDocumentAlreadyUploaded.filter( { Int($0.document_id ?? "") == dic.id})
                           print(">>>>newValue",newValue)
                          
                          if newValue.isEmpty {
                              
                              let dict = KYCVerifiyDoc.init(id: dic.id, user_id: dic.id, document_id: dic.id, url: dic.image, unique_id: dic.id, status: dic.name, expires_at: "", created_at: "", updated_at: "", image: dic.image, name: dic.name)
                              
                              kycVerifyDoc.append(dict)
                              
                          } else {
                   
                              let dict = KYCVerifiyDoc.init(id: newValue.last?.id, user_id: newValue.last?.user_id, document_id: Int(newValue.last?.document_id ?? ""), url: newValue.last?.url, unique_id: Int(newValue.last?.unique_id ?? ""), status: newValue.last?.status, expires_at: newValue.last?.expires_at, created_at: newValue.last?.created_at, updated_at: newValue.last?.updated_at, image: newValue.last?.image, name: newValue.last?.name)
                                   kycVerifyDoc.append(dict)
                             
                          }
                      }
                  
            
            
           
            
        case Base.kycUpdate.rawValue:
            self.loader.isHidden = true
            getKYC()
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}

extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return kycVerifyDoc.count > 0 ? kycVerifyDoc.count  : 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.CollectionImageCell, for: indexPath) as! CollectionImageCell
                cell.backgroundColor = .clear
                let entity = kycVerifyDoc[indexPath.row]
            cell.documNameLbl.text = nullStringToEmpty(string: entity.name) + "\n" + nullStringToEmpty(string: entity.status)
                cell.uploadButton.tag = indexPath.row
                cell.uploadButton.addTarget(self, action: #selector(uploadImagePicker), for: .touchUpInside)
             let url = URL.init(string: baseUrl + "/storage/" +  nullStringToEmpty(string: entity.url))
            
                print(">>>>>URL",url)
                cell.imgView.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "imgPlaceHolder"))
            
                return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
       
             return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
           
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
              return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }

}





extension EditProfileViewController {
    
    @objc func uploadImagePicker(sender: UIButton) {
      
//        self.showImage { (image) in
//                   if image != nil {
//                       
//                       
//                       let image : UIImage = image!
//                       let data = image.jpegData(compressionQuality: 0.2)
//                       print(">>>>>>>>>data",data)
//                    
//                }
//        }
    }
}

