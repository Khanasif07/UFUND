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
    var addAssetModel = ProductModel(json: [:])
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
    var sections : [AddProductCell] = [.basicDetailsAssets,.productSpecifics,.documentImage]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTableView.layoutIfNeeded()
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
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
    private func initialSetup() {
        self.mainTableView.registerCell(with: UploadDocumentTableCell.self)
        self.mainTableView.registerCell(with: UserProfilePhoneNoCell.self)
        self.mainTableView.registerCell(with: UserProfileImageCell.self)
        self.mainTableView.registerCell(with: UserProfileTableCell.self)
        self.mainTableView.registerHeaderFooter(with: UserProfileHeaderView.self)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
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
          switch sections[indexPath.section] {
            case .basicDetailsAssets:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            cell.titleLbl.text = self.generalInfoArray[indexPath.row].0
            cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row].0
            cell.textFIeld.text = self.generalInfoArray[indexPath.row].1
            return  cell
        case .productSpecifics:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
            } else {
                 cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
            }
            cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
            cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
            cell.textFIeld.text = self.bankInfoArray[indexPath.row].1
            return  cell
        default:
             let cell = tableView.dequeueCell(with: UploadDocumentTableCell.self, indexPath: indexPath)
             cell.uploadBtnsTapped = { [weak self] (sender)  in
                guard let selff = self else {return}
                selff.showImage { (image) in
                    if image != nil {
                        
                        let image : UIImage = image!
                        let data = image.jpegData(compressionQuality: 0.2)
//                        self.prodTokenImgData = data
//                        self.prodTokenImg.image = image
                    }
                }
             }
             cell.isFromAddProduct = false
            cell.tabsCollView.layoutIfNeeded()
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
                        switch indexPath.row {
                        case 0:
                            self.addAssetModel.asset_title = text
                        case 1:
                            self.addAssetModel.tokenname = text
                        case 2:
                            self.addAssetModel.tokenvalue = Int(text)
                        case 3:
                            self.addAssetModel.tokensymbol = text
                        case 4:
                            self.addAssetModel.tokensupply = Int(text)
                        case 5:
                            self.addAssetModel.decimal = Int(text)
                        default:
                            self.addAssetModel.asset_amount = Int(text)
                        }
                    } else if indexPath.section == 1 {
                        switch indexPath.row {
                        case 0:
                            self.addAssetModel.category_id = Int(text)
                        case 1:
                            self.addAssetModel.asset_type = text
                        case 2:
                            self.addAssetModel.token_type = Int(text)
                        case 3:
                            self.addAssetModel.asset_description = text
                        default:
                            self.addAssetModel.asset_description = text
                        }
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


enum AddProductCell{
    case basicDetailsAssets
    case basicDetailsProduct
    case productSpecifics
    case dAteSpecifics
    case documentImage
    
    var sectionCount: Int {
        switch self{
        case .basicDetailsAssets:
            return 7
        case .basicDetailsProduct:
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
        case .basicDetailsAssets,.basicDetailsProduct:
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
