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
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    let userProfileInfoo : [UserProfileAttributes] = UserProfileAttributes.allCases
    var param  =  [String:Any]()
    var imageData: Data?
    var profileImgUrl : URL?
    var userDetails: UserDetails?
    var userProfile: UserProfile?
    var countryCode: String  = "+91"
    var generalInfoArray = [("First Name",""),("Last Name",""),("Phone Number",""),("Email",""),("Address Line 1",""),("Address Line 2",""),("ZipCode",""),("City",""),("State",""),("Country","")]
    var bankInfoArray = [("Bank Name",""),("Account Name",""),("Account Number",""),("Routing Number",""),("IBAN Number",""),("Swift Number",""),("Account Currency",""),("Bank Address","")]
    var currencyListing = [CurrencyModel]()
    var selectedCurrency = CurrencyModel()
    var customPickerViewYear = WCCustomPickerView()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
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
            self.generalInfoArray.forEach { (userData) in
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
                } else if userData.0 == "Phone Number" {
                    if  userData.1.isEmpty {
                        ToastManager.show(title: "Please Enter Mobile Number", state: .warning)
                        return
                    } else {
                        param[ProfileUpdate.keys.mobile] = userData.1
                    }
                } else if userData.0 == "Address Line 1" {
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
                } else if userData.0 == "Address Line2" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.address2] = userData.1
                    }
                }
                else if userData.0 == "City" {
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
                } else if userData.0 == "Routing Number" {
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
                } else if userData.0 == "Account Currency" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.account_currency] = selectedCurrency.id
                    }
                }
                else if userData.0 == "Bank Address" {
                    if  !userData.1.isEmpty {
                        param[ProfileUpdate.keys.bank_address] = userData.1
                    }
                }
            }
            if imageData != nil {
                var dataDic =  [String:(Data,String,String)]()
                dataDic = [ProfileUpdate.keys.picture : (self.imageData!,"Profile.jpg",FileType.image.rawValue)]
                self.loader.isHidden = false
                self.presenter?.UploadData(api: Base.profile.rawValue, params: param, imageData: dataDic , methodType: .POST, modelClass: UserDetails.self, token: true)
            } else {
                self.loader.isHidden = false
                self.presenter?.HITAPI(api: Base.profile.rawValue, params: param, methodType: .POST, modelClass: UserDetails.self, token: true)
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
        if api == Base.productsCurrencies.rawValue{
            let currencyModelEntity = dataDict as? CurrencyModelEntity
            currencyListing = currencyModelEntity?.data ?? []
            self.customYearPicker()
            if let selectedIndex =  self.currencyListing.firstIndex(where: { (model) -> Bool in
                return  "\(model.id ?? 0)" == self.userProfile?.account_currency
            }){
              self.selectedCurrency = self.currencyListing[selectedIndex]
                self.bankInfoArray[6].1 =  self.selectedCurrency.currency ?? ""
            }
            return
        }
       
        if isEnableEdit {
            if api == Base.profile.rawValue {
            self.getProductsCurrenciesList()
            self.loader.isHidden = true
            let popUpVC = EditProfilePopUpVC.instantiate(fromAppStoryboard: .Main)
            popUpVC.editProfileSuccess = { [weak self] (sender) in
                guard let selff = self else { return }
                selff.navigationController?.popViewController(animated: true)
            }
            self.present(popUpVC, animated: true, completion: nil)
        }
        } else {
            self.userDetails = dataDict as? UserDetails
            self.userProfile = self.userDetails?.user
            self.loader.isHidden = true
            self.generalInfoArray[0].1 = self.userProfile?.name ?? ""
            self.generalInfoArray[1].1 = self.userProfile?.last_name ?? ""
            self.generalInfoArray[2].1 = self.userProfile?.mobile ?? ""
            self.generalInfoArray[3].1 = self.userProfile?.email ?? ""
            self.generalInfoArray[4].1 = self.userProfile?.address1 ?? ""
            self.generalInfoArray[5].1 = self.userProfile?.address2 ?? ""
            self.generalInfoArray[6].1 = self.userProfile?.zip_code ?? ""
            self.generalInfoArray[7].1 = self.userProfile?.city ?? ""
            self.generalInfoArray[8].1 = self.userProfile?.state ?? ""
            self.generalInfoArray[9].1 = self.userProfile?.country ?? ""
            
            self.bankInfoArray[0].1 = self.userProfile?.bank_name ?? ""
            self.bankInfoArray[1].1 = self.userProfile?.account_name ?? ""
            self.bankInfoArray[2].1 = self.userProfile?.account_number ?? ""
            self.bankInfoArray[3].1 = self.userProfile?.routing_number ?? ""
            self.bankInfoArray[4].1 = self.userProfile?.iban_number ?? ""
            self.bankInfoArray[5].1 = self.userProfile?.swift_number ?? ""
            self.bankInfoArray[7].1 = self.userProfile?.bank_address ?? ""
            if let selectedIndex =  self.currencyListing.firstIndex(where: { (model) -> Bool in
                return  "\(model.id ?? 0)" == self.userProfile?.account_currency
            }){
              self.selectedCurrency = self.currencyListing[selectedIndex]
                self.bankInfoArray[6].1 =  self.selectedCurrency.currency ?? ""
            }
            User.main.picture  = self.userProfile?.picture
            User.main.name  = self.userProfile?.name
            User.main.email  = self.userProfile?.email
            User.main.mobile = self.userProfile?.mobile
            storeInUserDefaults()
            self.profileImgUrl = URL(string: baseUrl + "/" +  nullStringToEmpty(string: self.userProfile?.picture))
            self.mainTableView.reloadData()
            self.getProductsCurrenciesList()
        }
        
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
    private func initialSetup() {
        self.isEnableEdit = false
        self.mainTableView.registerCell(with: UserProfilePhoneNoCell.self)
        self.mainTableView.registerCell(with: UserProfileImageCell.self)
        self.mainTableView.registerCell(with: UserProfileTableCell.self)
        self.mainTableView.registerHeaderFooter(with: UserProfileHeaderView.self)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.customYearPicker()
        self.getProfileDetails()
    }
    
    //MARK:- PRDUCTS LIST API CALL
    private func getProductsCurrenciesList() {
        self.presenter?.HITAPI(api: Base.productsCurrencies.rawValue, params: nil, methodType: .GET, modelClass: CurrencyModelEntity.self, token: true)
    }
    
    private func present(to identifier : String) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: identifier) as? CountryPickerVC
        viewController?.countryDelegate = self
        self.present(viewController!, animated: true, completion: nil)
    }
    
    func getProfileDetails(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: UserDetails.self, token: true)
    }
    
    private func customYearPicker(){
        self.customPickerViewYear.delegate = self
        self.customPickerViewYear.dataArray = currencyListing
    }
}

// MARK: - Extension For TableView
//===========================
extension UserProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 2
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return generalInfoArray.endIndex + 1
        default:
            return bankInfoArray.endIndex
        }
       }
       
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = tableView.dequeueHeaderFooter(with: UserProfileHeaderView.self)
           view.titleLbl.text  = section == 0 ? "GENERAL" : "BANK DETAILS"
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
                        selff.imageData = proImg.jpegData(compressionQuality: 0.2)!
                    }
                  }
                }
                cell.profileImgView.sd_setImage(with: self.profileImgUrl ?? nil , placeholderImage: #imageLiteral(resourceName: "profile"))
                cell.profileImgView.isUserInteractionEnabled = isEnableEdit
                cell.profileImgView.backgroundColor = UIColor(hex: primaryColor)
                return  cell
            default:
                if generalInfoArray[indexPath.row - 1].0 == "Phone Number" {
                    let cell = tableView.dequeueCell(with: UserProfilePhoneNoCell.self, indexPath: indexPath)
                    cell.countryPickerTapped = { [weak self] (sender) in
                        guard let selff = self else { return }
                        if selff.isEnableEdit {
                        selff.present(to: Storyboard.Ids.CountryPickerVC)
                        }
                    }
                    cell.countryCodeLbl.text = self.countryCode
                    cell.phoneTextField.delegate = self
                    cell.phoneTextField.keyboardType = .numberPad
                    cell.phoneTextField.isUserInteractionEnabled = isEnableEdit
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.phoneTextField.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.phoneTextField.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                } else {
                    let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                    cell.textFIeld.delegate = self
                    cell.textFIeld.isUserInteractionEnabled = isEnableEdit
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                }
            }
        default:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
            cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
            if self.bankInfoArray[indexPath.row ].0 == "Account Currency"  {
                cell.textFIeld.inputView = customPickerViewYear
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
            } else {
                 cell.textFIeld.inputView = nil
                 cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
            }
            cell.textFIeld.isUserInteractionEnabled = isEnableEdit
            cell.textFIeld.text = self.bankInfoArray[indexPath.row].1
            return  cell
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
                if indexPath.section == 0 {
                    self.generalInfoArray[indexPath.row - 1].1 = text
                } else {
                    self.bankInfoArray[indexPath.row].1 = text
                    if self.bankInfoArray[indexPath.row].0 == "Account Currency"{
                        cell.textFIeld.text = selectedCurrency.currency ?? ""
                        self.bankInfoArray[indexPath.row].1 = selectedCurrency.currency ?? ""
                    }
                }
            }
        }
        if let cell = mainTableView.cell(forItem: textField) as? UserProfilePhoneNoCell {
            if  let indexPath = mainTableView.indexPath(forItem: cell){
                self.generalInfoArray[indexPath.row - 1].1 = text
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
    

extension UserProfileVC : CountryDelegate{
    func sendCountryCode(code: String) {
        self.countryCode = code
        self.mainTableView.reloadData()
    }
}

//MARK:- WCCustomPickerViewDelegate
//===========================

extension UserProfileVC: WCCustomPickerViewDelegate {
    func userDidSelectRow(_ text: CurrencyModel) {
        self.selectedCurrency = text
    }
}
