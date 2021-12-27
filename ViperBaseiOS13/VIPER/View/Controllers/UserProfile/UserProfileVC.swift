//
//  UserProfileVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 08/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class UserProfileVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    var isKYCIncomplete: Bool = false
    var param  =  [String:Any]()
    var tempIndexPath: IndexPath?
    var imageData: Data?
    var profileImg: UIImage?
    var profileImgUrl : URL?
    var userDetails: UserDetails?
    var userProfile: UserProfile?
    var generalInfoArray = [("First Name",""),("Last Name",""),("Phone Number",""),("Email",""),("Investor Type",""),("Revenue",""),("Income",""),("Total Annual Revenue","")]
    var bankInfoArray = [("Bank Name",""),("Account Name",""),("Account Number",""),("Routing Number",""),("IBAN Number",""),("Swift Number",""),("Account Type",""),("Bank Address","")]
    var companyDetailArray = [("Company Name",""),("Email",""),("Telephone",""),("Company Address","")]
    var addressDetailArray = [("Address Line 1",""),("Address Line 2",""),("ZipCode",""),("City",""),("State",""),("Country","")]
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var customPickerIncome = WCCustomPickerView()
    var customPickerInvestor =  WCCustomPickerView()
    var customPickerAccount =  WCCustomPickerView()
    
    var isEnableEdit = false {
        didSet {
            if isEnableEdit {
                self.editBtn.setBackGroundColor(color: UIColor.rgb(r: 68, g: 194, b: 126))
                self.editBtn.setTitle("Update", for: .normal)
                self.editBtn.setTitleColor(.white,for: .normal)
                self.editBtn.setImage(nil, for: .normal)
            } else {
                self.editBtn.setTitle(" Edit", for: .normal)
                self.editBtn.setImage(#imageLiteral(resourceName: "icEdit"), for: .normal)
                self.editBtn.setTitleColor(UIColor.rgb(r: 255, g: 31, b: 45), for: .normal)
                self.editBtn.setBackGroundColor(color: .white)
            }
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func editProfileBtnAction(_ sender: UIButton) {
        if self.isEnableEdit {
            for userData in  self.generalInfoArray {
                if userData.0 == "First Name"{
                    if  userData.1.isEmpty {
                        ToastManager.show(title: "Please Enter First Name", state: .warning)
                        return
                    } else {
                        param[ProfileUpdate.keys.name] = userData.1
                    }
                }else if userData.0 == "Last Name"{
                    if  userData.1.isEmpty {
                        ToastManager.show(title: "Please Enter Last Name", state: .warning)
                        return
                    } else {
                        param[ProfileUpdate.keys.last_name] = userData.1
                    }
                }else if userData.0 == "Email"{
                    if  userData.1.isEmpty {
                        ToastManager.show(title: "Please Enter email", state: .warning)
                        return
                    } else {
                        param[ProfileUpdate.keys.email] = userData.1
                    }
                } else if userData.0 == "Phone Number" {
                    if  userData.1.isEmpty {
                        ToastManager.show(title: "Please Enter Mobile Number", state: .warning)
                        return
                    } else {
                        param[ProfileUpdate.keys.mobile] = userData.1
                    }
                } else if userData.0 == "Investor Type" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.account_type] = userData.1
                    }
                } else if userData.0 == "Revenue" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.revenue] = userData.1
                    }
                }else if userData.0 == "Income" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.income_type] = userData.1
                    }
                } else if userData.0 == "Total Annual Revenue" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.total_annual_revenue] = userData.1
                    }
                }
            }
            
            self.addressDetailArray.forEach { (userData) in
                 if userData.0 == "Address Line 1" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.address1] = userData.1
                    }
                } else if userData.0 == "Address Line 2" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.address2] = userData.1
                    }
                }else if userData.0 == "ZipCode" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.zip_code] = userData.1
                    }
                }else if userData.0 == "City" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.city] = userData.1
                    }
                }else if userData.0 == "State" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.state] = userData.1
                    }
                } else if userData.0 == "Country" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.country] = userData.1
                    }
                }
            }
            self.bankInfoArray.forEach { (userData) in
                if userData.0 == "Bank Name"{
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.bank_name] = userData.1
                    }
                }else if userData.0 == "Account Name"{
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.account_name] = userData.1
                    }
                } else if userData.0 == "Account Number" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.account_number] = userData.1
                    }
                }  else if userData.0 == "Account Type" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.user_account_type] = userData.1
                    }
                }
                else if userData.0 == "Routing Number" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.routing_number] = userData.1
                    }
                } else if userData.0 == "IBAN Number" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.iban_number] = userData.1
                    }
                }else if userData.0 == "Swift Number" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.swift_number] = userData.1
                    }
                }
                else if userData.0 == "Bank Address" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.bank_address] = userData.1
                    }
                }
            }
            
            self.companyDetailArray.forEach { (userData) in
                if userData.0 == "Company Name"{
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.company_name] = userData.1
                    }
                }else if userData.0 == "Email"{
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.company_email] = userData.1
                    }
                } else if userData.0 == "Telephone" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.company_telephone] = userData.1
                    }
                } else if userData.0 == "Company Address" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.company_address] = userData.1
                    }
                }
            }
            param[ProfileUpdate.keys.countryCode] = userProfile?.countryCode ?? ""
            if imageData != nil {
                self.loader.isHidden = false
                AWSS3Manager.shared.uploadImage(image: profileImg ?? UIImage(), progress: { (progress) in
                    print(progress)
                }) { (successUrl, error) in
                    if let url = successUrl {
                        self.param[ProfileUpdate.keys.picture] = url
                        self.presenter?.HITAPI(api: Base.new_profile.rawValue, params: self.param, methodType: .POST, modelClass: UserDetails.self, token: true)
                        print(url)
                    }
                    if let _ = error{
                        ToastManager.show(title:  nullStringToEmpty(string: Constants.string.failedImg.localize()), state: .error)
                    }
                }
            } else {
                self.loader.isHidden = false
                self.param[ProfileUpdate.keys.picture] = self.userProfile?.picture ?? ""
                self.presenter?.HITAPI(api: Base.new_profile.rawValue, params: param, methodType: .POST, modelClass: UserDetails.self, token: true)
            }
        } else {
            self.isEnableEdit = true
            self.mainTableView.reloadData()
    }
}

    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension UserProfileVC: PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        if isEnableEdit {
            if api == Base.profile.rawValue {
                self.loader.isHidden = true
                let popUpVC = EditProfilePopUpVC.instantiate(fromAppStoryboard: .Main)
                popUpVC.editProfileSuccess = { [weak self] (sender) in
                    guard let selff = self else { return }
                    if User.main.kyc == 0{
                        ToastManager.show(title:  nullStringToEmpty(string: "Your profile KYC is not verified! Please update your details for KYC. If already submitted please wait for KYC Approval."), state: .error)
                    }else {
                        selff.navigationController?.popViewController(animated: true)
                    }
                }
                self.present(popUpVC, animated: true, completion: nil)
                if User.main.kyc == 0{
                    ToastManager.show(title:  nullStringToEmpty(string: "Your profile KYC is not verified! Please update your details for KYC. If already submitted please wait for KYC Approval."), state: .error)
                }
            }
        } else {
            self.userDetails = dataDict as? UserDetails
            self.userProfile = self.userDetails?.user
            self.loader.isHidden = true
            self.generalInfoArray[0].1 = self.userProfile?.name ?? ""
            self.generalInfoArray[1].1 = self.userProfile?.last_name ?? ""
            self.generalInfoArray[2].1 = self.userProfile?.mobile ?? ""
            self.generalInfoArray[3].1 = self.userProfile?.email ?? ""
            self.generalInfoArray[4].1 = "\(self.userProfile?.account_type ?? "")"
            self.generalInfoArray[5].1 =  "\(self.userProfile?.revenue ?? 0.0)"
            self.generalInfoArray[6].1 = self.userProfile?.income_type ?? ""
            self.generalInfoArray[7].1 = "\(self.userProfile?.total_annual_revenue ?? 0.0)"
            
            self.bankInfoArray[0].1 = self.userProfile?.bank_name ?? ""
            self.bankInfoArray[1].1 = self.userProfile?.account_name ?? ""
            self.bankInfoArray[2].1 = self.userProfile?.account_number ?? ""
            self.bankInfoArray[3].1 = self.userProfile?.routing_number ?? ""
            self.bankInfoArray[4].1 = self.userProfile?.iban_number ?? ""
            self.bankInfoArray[5].1 = self.userProfile?.swift_number ?? ""
            self.bankInfoArray[6].1 = self.userProfile?.user_account_type ?? ""
            self.bankInfoArray[7].1 = self.userProfile?.bank_address ?? ""
            
            self.addressDetailArray[0].1 = self.userProfile?.address1 ?? ""
            self.addressDetailArray[1].1 = self.userProfile?.address2 ?? ""
            self.addressDetailArray[2].1 = self.userProfile?.zip_code ?? ""
            self.addressDetailArray[3].1 = self.userProfile?.city ?? ""
            self.addressDetailArray[4].1 = self.userProfile?.state ?? ""
            self.addressDetailArray[5].1 = self.userProfile?.country ?? ""
            
            self.companyDetailArray[0].1 = self.userProfile?.company_name ?? ""
            self.companyDetailArray[1].1 = self.userProfile?.company_email ?? ""
            self.companyDetailArray[2].1 = self.userProfile?.company_telephone ?? ""
            self.companyDetailArray[3].1 = self.userProfile?.company_address ?? ""
            
            User.main.picture  = self.userProfile?.picture
            User.main.name  = self.userProfile?.name
            if self.userProfile?.id != nil {
                User.main.id = self.userProfile?.id
            }
            User.main.email  = self.userProfile?.email
            User.main.mobile = self.userProfile?.mobile
            User.main.kyc = self.userProfile?.kyc
            User.main.signup_by = self.userProfile?.signup_by
            User.main.social_email_verify = self.userProfile?.social_email_verify
            storeInUserDefaults()
            if !(self.userProfile?.picture?.isEmpty ?? true){
                self.profileImgUrl = URL(string: nullStringToEmptyForImg(string: self.userProfile?.picture))
            }
            self.mainTableView.reloadData()
            if User.main.kyc == 0{
                ToastManager.show(title: "Your profile KYC is not verified! Please update your details for KYC. If already submitted please wait for KYC Approval." ,state: .error)
            }
            if (User.main.signup_by ?? "") == "5" {
                if !(User.main.social_email_verify ?? true) {
                    ToastManager.show(title: "Please verify your email first." ,state: .error)
                    return
                }
            }
        }
        
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title: nullStringToEmpty(string: error.localizedDescription.trimString()),state: .error)
    }
    
    private func initialSetup() {
        self.isEnableEdit = false
        self.backBtn.isHidden = (User.main.kyc == 0)
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        self.mainTableView.registerCell(with: UserProfilePhoneNoCell.self)
        self.mainTableView.registerCell(with: UserProfileImageCell.self)
        self.mainTableView.registerCell(with: UserProfileTableCell.self)
        self.mainTableView.registerHeaderFooter(with: UserProfileHeaderView.self)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.getProfileDetails()
        self.customPickerViewSetup()
    }
    
    func getProfileDetails(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: UserDetails.self, token: true)
    }
    
    private func customPickerViewSetup(){
        [customPickerIncome,customPickerAccount,customPickerInvestor].forEach { (pickerView) in
            pickerView?.delegate = self
        }
        customPickerIncome.dataArray = ["Monthly","Yearly","Other"]
        customPickerAccount.dataArray = ["Personal","Business"]
        customPickerInvestor.dataArray = ["Individual","Business"]
    }
    
    private func present(to identifier : String) {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: identifier) as? CountryPickerVC
            viewController?.countryDelegate = self
            self.present(viewController!, animated: true, completion: nil)
        }

}

// MARK: - Extension For TableView
//===========================
extension UserProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return [generalInfoArray,addressDetailArray,companyDetailArray,bankInfoArray].endIndex
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return generalInfoArray.endIndex + 1
        case 1:
            return addressDetailArray.endIndex
        case 2:
            return companyDetailArray.endIndex
        default:
            return bankInfoArray.endIndex
        }
       }
       
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: UserProfileHeaderView.self)
        switch section {
        case 0:
            view.titleLbl.text = "GENERAL"
        case 1:
            view.titleLbl.text = "ADDRESS DETAILS"
        case 2:
            view.titleLbl.text = "COMPANY DETAILS"
        default:
            view.titleLbl.text  = "BANK DETAILS"
        }
        return view
    }
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(with: UserProfileImageCell.self, indexPath: indexPath)
                cell.profileImgBtnTapped = { [weak self] (sender) in
                    guard let selff = self else { return }
                    if selff.isEnableEdit {
                    selff.showImage { (image) in
                        let proImg : UIImage = image!
                        cell.profileImgView.image = proImg
                        selff.profileImg = proImg
                        selff.imageData = proImg.jpegData(compressionQuality: 0.2)!
                    }
                  }
                }
                if self.profileImgUrl == nil && self.profileImg == nil {
                    cell.profileImgView.sd_setImage(with: self.profileImgUrl ?? nil , placeholderImage: #imageLiteral(resourceName: "icPlaceHolder"))
                } else if  self.profileImgUrl == nil && self.profileImg != nil {
                    cell.profileImgView.image = self.profileImg
                } else if self.profileImgUrl != nil && self.profileImg != nil{
                     cell.profileImgView.image = self.profileImg
                }else {
                    cell.profileImgView.sd_setImage(with: self.profileImgUrl ?? nil , placeholderImage: #imageLiteral(resourceName: "icPlaceHolder"))
                }
                cell.profileImgView.isUserInteractionEnabled = isEnableEdit
                cell.profileImgView.backgroundColor = .clear
                return  cell
            default:
                switch generalInfoArray[indexPath.row - 1].0 {
                case "Phone Number":
                    let cell = tableView.dequeueCell(with: UserProfilePhoneNoCell.self, indexPath: indexPath)
                    cell.phoneTextField.delegate = self
                    cell.countryPickerTapped = { [weak self] (sender) in
                        guard let selff = self else { return }
                        if selff.isEnableEdit {
                            selff.present(to: Storyboard.Ids.CountryPickerVC)
                        }
                        
                    }
                    cell.phoneTextField.keyboardType = .default
                    cell.phoneTextField.isUserInteractionEnabled = isEnableEdit
                    cell.countryTxtFld.text = self.userProfile?.countryCode ?? ""
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.phoneTextField.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.phoneTextField.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                case "Revenue","Total Annual Revenue":
                    let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                    cell.textFIeld.delegate = self
                    cell.textFIeld.keyboardType = .decimalPad
                    cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                case "Email":
                    let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                    cell.textFIeld.delegate = self
                    cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                case "Income":
                    let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                    cell.textFIeld.inputView = customPickerIncome
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                    cell.textFIeld.delegate = self
                    cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                case "Investor Type":
                    let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                    cell.textFIeld.inputView = customPickerInvestor
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                    cell.textFIeld.delegate = self
                    cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                default:
                    let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                    cell.textFIeld.delegate = self
                    cell.textFIeld.keyboardType = .default
                    cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.text = self.generalInfoArray[indexPath.row - 1].1
                    cell.textFIeld.inputView = nil
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
                    return  cell
                }
            }
        case 1:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            cell.textFIeld.keyboardType = .default
            cell.titleLbl.text = self.addressDetailArray[indexPath.row ].0
            cell.textFIeld.placeholder = self.addressDetailArray[indexPath.row].0
            cell.textFIeld.isUserInteractionEnabled = isEnableEdit
            cell.textFIeld.text = self.addressDetailArray[indexPath.row].1
            return  cell
        case 2:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            switch bankInfoArray[indexPath.row].0 {
            case "Telephone":
                cell.textFIeld.keyboardType = .default
            default:
                 cell.textFIeld.keyboardType = .emailAddress
            }
            cell.titleLbl.text = self.companyDetailArray[indexPath.row ].0
            cell.textFIeld.placeholder = self.companyDetailArray[indexPath.row].0
            cell.textFIeld.isUserInteractionEnabled = isEnableEdit
            cell.textFIeld.text = self.companyDetailArray[indexPath.row].1
            return  cell
        default:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            switch bankInfoArray[indexPath.row].0 {
            case "Account Type":
                cell.textFIeld.inputView = customPickerAccount
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                cell.textFIeld.delegate = self
                cell.textFIeld.keyboardType = .default
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
                cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
                cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                cell.textFIeld.text = self.bankInfoArray[indexPath.row].1
                return  cell
            case "Account Number","Routing Number":
                cell.textFIeld.delegate = self
                cell.textFIeld.keyboardType = .namePhonePad
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
                cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
                cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                cell.textFIeld.text = self.bankInfoArray[indexPath.row].1
                return  cell
            default:
                cell.textFIeld.delegate = self
                cell.textFIeld.keyboardType = .emailAddress
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
                cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
                cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                cell.textFIeld.text = self.bankInfoArray[indexPath.row].1
                cell.textFIeld.inputView = nil
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
                return  cell
            }
        }
    }
}
 
// MARK: - Extension For TextField Delegate
//====================================
extension UserProfileVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell {
            if  let indexPath = mainTableView.indexPath(forItem: cell){
                switch indexPath.section {
                case 0:
                    self.generalInfoArray[indexPath.row - 1].1 = text
                case 1:
                    self.addressDetailArray[indexPath.row].1 = text
                case 2:
                    self.companyDetailArray[indexPath.row].1 = text
                default:
                    self.bankInfoArray[indexPath.row].1 = text
                }
            }
        }
        if let cell = mainTableView.cell(forItem: textField) as? UserProfilePhoneNoCell {
            if  let indexPath = mainTableView.indexPath(forItem: cell){
                self.generalInfoArray[indexPath.row - 1].1 = text
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell {
        if  let indexPath = mainTableView.indexPath(forItem: cell){
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 5,7:
                    tempIndexPath = indexPath
                default:
                    tempIndexPath = nil
                }
            case 3:
                switch indexPath.row {
                case 6:
                    tempIndexPath = indexPath
                default:
                    tempIndexPath = nil
                }
            default:
                tempIndexPath = nil
            }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        let currentString: NSString = textField.text! as NSString
        //        let newString: NSString =
        //            currentString.replacingCharacters(in: range, with: string) as NSString
        //        if let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell {
        //                if  let indexPath = mainTableView.indexPath(forItem: cell){
        //                     if indexPath.section  == 0 {
        //                    switch  self.generalInfoArray[indexPath.row - 1].0  {
        //                    case "First Name","Last Name":
        //                        return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 50
        //                case cell?.mobNoTxtField:
        //                    return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 10
        //                    case "Email":
        //                        return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        //                    default:
        //                        return false
        //                    }
        //                }
        //            }
        //        }
        return true
    }
}
    

//MARK:- WCCustomPickerViewDelegate
//===========================

extension UserProfileVC: WCCustomPickerViewDelegate {
    func userDidSelectRow(_ text: String) {
        switch tempIndexPath?.section {
        case 0:
            self.generalInfoArray[(tempIndexPath?.row ?? 0) - 1].1 = text
            mainTableView.reloadRows(at: [tempIndexPath!], with: .none)
        case 3:
            self.bankInfoArray[tempIndexPath?.row ?? 0].1 = text
            mainTableView.reloadRows(at: [tempIndexPath!], with: .none)
        default:
            print("Do Nothing")
        }
    }
}

//MARK:- UserProfileVC
//===========================

extension UserProfileVC : CountryDelegate{
    func sendCountryCode(code: String) {
        self.userProfile?.countryCode = code
        self.mainTableView.reloadData()
    }
}
