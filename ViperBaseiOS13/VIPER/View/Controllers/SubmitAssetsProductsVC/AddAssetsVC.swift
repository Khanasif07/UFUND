//
//  AddAssetsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 30/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class AddAssetsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    let userProfileInfoo : [UserProfileAttributes] = UserProfileAttributes.allCases
    var param  =  [String:Any]()
    var imageData: Data?
    var profileImgUrl : URL?
    var userDetails: UserDetails?
    var userProfile: UserProfile?
    var countryCode: String  = "+91"
    var generalInfoArray = [("Name of Asset",""),("Token Name",""),("Value of Token",""),("Token Symbol",""),("Token Supply",""),("Decimal",""),("Value of Asset","")]
    var bankInfoArray = [("Category",""),("Asset Type",""),("Token Type",""),("Description","")]
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var sections : [AddProductCell] = [.basicDetails,.productSpecifics,.documentImage]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainTableView.reloadData()
    }
    
    // MARK: - IBActions
    //===========================
}

// MARK: - Extension For Functions
//===========================
extension AddAssetsVC: PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
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
            self.bankInfoArray[6].1 = self.userProfile?.bank_address ?? ""
            User.main.picture  = self.userProfile?.picture
            User.main.name  = self.userProfile?.name
            User.main.email  = self.userProfile?.email
            User.main.mobile = self.userProfile?.mobile
            storeInUserDefaults()
            self.profileImgUrl = URL(string: baseUrl + "/" +  nullStringToEmpty(string: self.userProfile?.picture))
            self.mainTableView.reloadData()
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
    private func initialSetup() {
        self.mainTableView.registerCell(with: UserProfilePhoneNoCell.self)
        self.mainTableView.registerCell(with: UserProfileImageCell.self)
        self.mainTableView.registerCell(with: UserProfileTableCell.self)
        self.mainTableView.registerHeaderFooter(with: UserProfileHeaderView.self)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
//        self.getProfileDetails()
    }
    
    func getProfileDetails(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: UserDetails.self, token: true)
    }
}

// MARK: - Extension For TableView
//===========================
extension AddAssetsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.endIndex
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.sections[section].sectionCount
       }
       
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = tableView.dequeueHeaderFooter(with: UserProfileHeaderView.self)
        view.titleLbl.text  = sections[section].titleValue
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
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            cell.titleLbl.text = self.generalInfoArray[indexPath.row].0
            cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row].0
            cell.textFIeld.text = self.generalInfoArray[indexPath.row].1
            return  cell
        case 1:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
            cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
            cell.textFIeld.text = self.bankInfoArray[indexPath.row].1
            return  cell
        default:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
            cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
            cell.textFIeld.text = self.bankInfoArray[indexPath.row].1
            return  cell
        }
    }
}
 
// MARK: - Extension For TextField Delegate
//====================================
extension AddAssetsVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell {
            if  let indexPath = mainTableView.indexPath(forItem: cell){
                if indexPath.section == 0 {
                    self.generalInfoArray[indexPath.row - 1].1 = text
                } else {
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


enum AddProductCell{
    case basicDetails
    case productSpecifics
    case dAteSpecifics
    case documentImage
    
    var sectionCount: Int {
        switch self{
        case .basicDetails:
            return 6
        case .productSpecifics:
            return 4
        case .dAteSpecifics:
            return 5
        case .documentImage:
            return 1
        }
    }
    
    var titleValue: String {
        switch self{
        case .basicDetails:
            return "Basic Details"
        case .productSpecifics:
            return "Product Specifics"
        case .dAteSpecifics:
            return "DAte Specifics"
        case .documentImage:
            return "Document & Image"
        }
    }
}
