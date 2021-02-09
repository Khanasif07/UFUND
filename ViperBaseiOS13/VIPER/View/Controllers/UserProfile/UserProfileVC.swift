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
    var imageData: Data?
    var profileImgUrl : URL?
    var userDetails: UserDetails?
    var userProfile: UserProfile?
    var countryCode: String  = "+91"
    var generalInfoArray = [("First Name","Asif Khan"),("Last Name",""),("Phone Number",""),("Email",""),("Address Line1",""),("Address Line 2",""),("ZipCode",""),("City",""),("State",""),("Country","")]
    var bankInfoArray = [("Bank Name",""),("Account Name",""),("Account Number",""),("Routing Number",""),("IBAN Number",""),("Swift Number",""),("Account currency",""),("Bank Address","")]
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
        self.isEnableEdit = !self.isEnableEdit
        self.mainTableView.reloadData()
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension UserProfileVC: PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
          self.userDetails = dataDict as? UserDetails
        self.userProfile = self.userDetails?.user
        self.loader.isHidden = true
        self.generalInfoArray[0].1 = self.userProfile?.name ?? ""
        self.generalInfoArray[1].1 = self.userProfile?.last_name ?? ""
        self.generalInfoArray[2].1 = self.userProfile?.mobile ?? ""
        self.generalInfoArray[3].1 = self.userProfile?.email ?? ""
        self.generalInfoArray[4].1 = self.userProfile?.address ?? ""
        self.generalInfoArray.removeAll { (userTuple) -> Bool in
            userTuple.1.isEmpty == true
        }
        self.profileImgUrl = URL(string: baseUrl + "/" +  nullStringToEmpty(string: self.userProfile?.picture))
        self.mainTableView.reloadData()
        
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
        self.getProfileDetails()
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
                        selff.present(to: Storyboard.Ids.CountryPickerVC)
                    }
                    cell.countryCodeLbl.text = self.countryCode
                    cell.phoneTextField.delegate = self
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
            if cell.titleLbl.text ?? "" == "Account Currency" {
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
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
        let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell
        if  let indexPath = mainTableView.indexPath(forItem: cell ?? UserProfileTableCell()){
            if indexPath.section == 0 {
                self.generalInfoArray[indexPath.row - 1].1 = text
            } else {
                self.bankInfoArray[indexPath.row].1 = text
            }
        }
        
//        switch cell?.titleLbl.text ?? "" {
//          case "First Name":
//            self.generalInfoArray[0].1 = text
//          case "Last Name":
//            self.generalInfoArray[1].1 = text
//          case "Email":
//            self.generalInfoArray[2].1 = text
//          case "Address Line1":
//            self.generalInfoArray[3].1 = text
//          case "Phone Number":
//            self.generalInfoArray[3].1 = text
//          default:
//            self.generalInfoArray[4].1 = text
//              print(text)
//          }
//
      }
      
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//          let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell
//          let currentString: NSString = textField.text! as NSString
//          let newString: NSString =
//              currentString.replacingCharacters(in: range, with: string) as NSString
          return true
//          switch textField {
//          case cell?.nameTxtField:
//              return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 50
//          case cell?.mobNoTxtField:
//              return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 10
//          case cell?.emailIdTxtField:
//              return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
//          case cell?.passTxtField:
//              return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
//          case cell?.confirmPassTxtField:
//              return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
//          default:
//              return false
//          }
      }
}


extension UserProfileVC : CountryDelegate{
    func sendCountryCode(code: String) {
        self.countryCode = code
        self.mainTableView.reloadData()
    }
}






