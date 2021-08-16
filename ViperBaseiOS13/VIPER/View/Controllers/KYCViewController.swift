//
//  KYCViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 24/12/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

struct SelectedDoc {
    
    var id: Int?
    var file: Data?
    var img: UIImage?

    init(id: Int?,file: Data?,img: UIImage?) {
        self.id = id
        self.file = file
        self.img = img
    }
}


class KYCVerifiyDoc {
    
    var id : Int?
       var user_id : Int?
       var document_id : Int?
       var url : String?
       var unique_id : Int?
       var status : String?
       var expires_at : String?
       var created_at : String?
       var updated_at : String?
       var image : String?
       var name : String?
    
    init(id : Int?, user_id : Int?,document_id : Int?,url : String?,unique_id : Int?, status : String?,expires_at : String?, created_at : String?,updated_at : String?, image : String?, name : String?) {
        
        
        self.id = id
        self.user_id = user_id
        self.document_id = document_id
        self.url = url
        self.unique_id = unique_id
        self.status = status
        self.expires_at = status
        self.created_at = created_at
        self.updated_at = updated_at
        self.image = image
        self.name = name
    }
}


class KYCViewController: UIViewController {

    
    @IBAction func kycClickEvent(_ sender: UIButton) {
       
        var param = [String: AnyObject]()
        var imageArray = [String: Data]()
                               
        
        param[RegisterParam.keys.name] = nullStringToEmpty(string: firstNameKycTxT.text) as AnyObject
        param[RegisterParam.keys.last_name] = nullStringToEmpty(string: lastNameKycTxT.text) as AnyObject
//        param[RegisterParam.keys.mobile] = nullStringToEmpty(string: mobileNumberTxtFld.text) as AnyObject
    
        
        for (index,ids) in self.selectedDoc.enumerated() {
            
            param["document_ids[\(index)]"] = ids.id as AnyObject
            imageArray["\(index)"] = ids.file
            
        }
             
        print("param",param)
        print(">>>>>>>>>imageArray",imageArray)
        
        self.presenter?.IMAGEPOST(api: Base.kycUpdate.rawValue, params: param, methodType: .POST, imgData: imageArray, imgName: "", modelClass: SuccessDict.self, token: true)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var docsTxtFld: UITextField!
    @IBOutlet weak var collectionParentView: UIView!
    @IBOutlet weak var lastNameKycTxT: UITextField!
    @IBOutlet weak var firstNameKycTxT: UITextField!
    @IBOutlet weak var countryTxtFld: UITextField!
    @IBOutlet weak var KycSaveButton: UIButton!
    @IBOutlet weak var kycLbl: UILabel!
    var selectedDoc = [SelectedDoc]()
    var selectedIndex = 0
    var successDict: SuccessDict?
    
    @IBOutlet weak var stackView: UIStackView!
    
    var viewEffect = 0 {
        didSet {
            
            UIView.animate(withDuration: 0.1) {
                for view in self.stackView.subviews {
                    view.applyEffectToView(borderColor: UIColor.systemRed)
                }
            }
        }
    }
    
    private lazy var loader  : UIView = {
               return createActivityIndicator(self.view)
    }()
    
    var userProfile: UserProfile?
    var kycDetail: KYCDetail?
    var kycDocument = [Documents]()
    var kycDocumentAlreadyUploaded = [KYCUpdatedDocument]()
    var isFromList = false
    
    var kycVerifyDoc = [KYCVerifiyDoc]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        viewEffect = 0
        
        KycSaveButton.setGradientBackground()
        firstNameKycTxT.applyEffectToTextField(placeHolderString: Constants.string.firstName.localize())
        docsTxtFld.applyEffectToTextField(placeHolderString: Constants.string.documentType.localize())
        lastNameKycTxT.applyEffectToTextField(placeHolderString: Constants.string.lastName.localize())
        countryTxtFld.applyEffectToTextField(placeHolderString: Constants.string.country.localize())
        
        countryTxtFld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
        docsTxtFld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
        
        let nibPost = UINib(nibName: XIB.Names.CollectionImageCell, bundle: nil)
        collectionView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.CollectionImageCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.alwaysBounceHorizontal = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getKYC()
        
    }
            
            override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                localize()
            }
            
        }

        //MARK: - Localization
        extension KYCViewController {
            
            func localize() {
                
                
                KycSaveButton.setTitle(Constants.string.save.localize(), for: .normal)
                KycSaveButton.setTitleColor(.white, for: .normal)
                kycLbl.text = Constants.string.kyc.localize().uppercased()
                
            }
        }


        //MARK: - Button Action
        extension KYCViewController {
            
            @IBAction func goBack(_ sender: UIButton) {
                
                self.popOrDismiss(animation: true)
//               presentAlertViewController()
            }
            
           
            
        }

        //MARK: - UITextField Delegate
        extension KYCViewController: UITextFieldDelegate {
            
            func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
                view.endEditingForce()
                return true
            }
            
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                view.endEditingForce()
                return true
            }
        }



extension  KYCViewController {
    
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



extension KYCViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
//            return kycVerifyDoc.count > 0 ? kycVerifyDoc.count  : 0
            return 2
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.CollectionImageCell, for: indexPath) as! CollectionImageCell
                cell.backgroundColor = .clear
//                let entity = kycVerifyDoc[indexPath.row]
//
//
//                        cell.documNameLbl.text = nullStringToEmpty(string: entity.name) + "\n" + nullStringToEmpty(string: entity.status)
//                cell.uploadButton.tag = indexPath.row
//                cell.uploadButton.addTarget(self, action: #selector(uploadImagePicker), for: .touchUpInside)
           
             
            
//            if isFromList {
//
//                let url = URL.init(string: baseUrl + "/storage/" +  nullStringToEmpty(string: entity.url))
//                cell.imgView.sd_setImage(with: url , placeholderImage: nil)
//                print(">>>url",url)
//
//                if nullStringToEmpty(string: entity.status) == "APPROVED" {
//
//                    cell.uploadButton.isHidden = true
//
//                } else {
//
//                     cell.uploadButton.isHidden = false
//
//                }
//            } else {
//
//                 cell.uploadButton.isHidden = false
//            }
            
            
            
//            if selectedDoc.count > 0 {
//
//                for ids in selectedDoc {
//
//                    if ids.id == entity.id {
//
//                        cell.imgView.image = ids.img
//                    }
//                }
//            }
                return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
       
                return CGSize(width: collectionView.frame.width / 2, height: 120)
           
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }
        
        

}

extension KYCViewController {
    
    @objc func uploadImagePicker(sender: UIButton) {
        selectedIndex = sender.tag
       
        self.showImage { (image) in
            
                   if image != nil {
                       
                    let entity = self.kycVerifyDoc[self.selectedIndex]
                       let image : UIImage = image!
                       let data = image.jpegData(compressionQuality: 0.2)
                      
                    
                    let doc = SelectedDoc(id: entity.id, file: data, img: image)
                    if self.selectedDoc.count > 0 {
                        
                        for ids in self.selectedDoc {
                            
                            print(">>>ids",ids)
                            
                            if ids.id == doc.id {
                                self.selectedDoc.append(doc)
                                self.collectionView.reloadData()
                            } else {
                                self.selectedDoc.append(doc)
                                self.collectionView.reloadData()
                            }
                        }
                    } else {
                         self.selectedDoc.append(doc)
                        self.collectionView.reloadData()
                    }
                    
                }
        }
        
       
    }
}

//MARK: - PresenterOutputProtocol

extension KYCViewController: PresenterOutputProtocol {
    
  
    func getKYC() {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.kyc.rawValue, params: nil, methodType: .GET, modelClass: KYCDetail.self, token: true)
    }
    
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
            
        case Base.kyc.rawValue:
            
            self.loader.isHidden = true
            self.kycDetail = dataDict as? KYCDetail
            self.kycDocument = self.kycDetail?.document ?? []
            self.userProfile = self.kycDetail?.user
            self.kycDocumentAlreadyUploaded = self.kycDetail?.kyc_document ?? []
        
         
            if self.userProfile != nil {
                
                        firstNameKycTxT.text = nullStringToEmpty(string:  self.userProfile?.name)
                        lastNameKycTxT.text = nullStringToEmpty(string: self.userProfile?.last_name)
//                        mobileNumberTxtFld.text = nullStringToEmpty(string: self.userProfile?.mobile)

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
            
               
            if kycDocumentAlreadyUploaded.count >  0 {
                
                if self.kycVerifyDoc.filter( { $0.status == "DISAPPROVED" || $0.status == "" } ).count == 0 {
                    
                     let digitalId = UserDefaults.standard.value(forKey: "digitalId")  as? Int
                    
                    
                    if User.main.g2f_temp == 1 || User.main.pin_status == 1  || digitalId == 1 {
                        
                        
                        
                        let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.OtpController) as! OtpController
                        vc.changePINStr = "changePINStr"
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                        
                    } else {
                        
                        self.push(id: Storyboard.Ids.DrawerController, animation: true)
                    }
                    
                }
                
            }
            
                            
        
            let calVal = kycVerifyDoc.count % 3
            print(">>>calVal",calVal)
            
            if calVal == 0 {
               isFromList = false
                collectionHeight.constant = CGFloat(kycVerifyDoc.count / 3 * 120)
                
            } else {
                isFromList = true
                let tableHeight : Int = Int(kycVerifyDoc.count / 3)
                collectionHeight.constant = CGFloat(tableHeight * 120 + 120)
            }
        
            collectionView.reloadData()
     
           
            
        case Base.kycUpdate.rawValue:
            
            self.loader.isHidden = true
            self.successDict = dataDict as? SuccessDict
            
            if self.successDict?.success?.msg != "" {
                ToastManager.show(title:  SuccessMessage.string.loginSucess.localize(), state: .success)
                self.push(id: Storyboard.Ids.DrawerController, animation: true)
            }
           
          
        
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
