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
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var requestBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    let userProfileInfoo : [UserProfileAttributes] = UserProfileAttributes.allCases
    var addAssetModel = ProductModel(json: [:])
    var imgDataArray = [(UIImage,Data,Bool)]()
    var categoryListing = [CategoryModel]()
    var assetTypeListing = [AssetTokenTypeModel]()
    var tokenTypeListing = [AssetTokenTypeModel]()
    var sortTypeAppliedCategory = CategoryModel()
    var sortTypeAppliedAsset = AssetTokenTypeModel()
    var sortTypeAppliedToken = AssetTokenTypeModel()
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
    @IBAction func requestBtnAction(_ sender: UIButton) {
          requestBtn.isSelected.toggle()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension AddAssetsVC: PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
            self.loader.isHidden = true
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
    private func initialSetup() {
        self.imgDataArray = [(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false)]
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: UploadDocumentTableCell.self)
        self.mainTableView.registerCell(with: UserProfilePhoneNoCell.self)
        self.mainTableView.registerCell(with: UserProfileImageCell.self)
        self.mainTableView.registerCell(with: UserProfileTableCell.self)
        self.mainTableView.registerCell(with: AddDescTableCell.self)
        self.mainTableView.registerHeaderFooter(with: UserProfileHeaderView.self)
        self.mainTableView.tableFooterView = footerView
        self.mainTableView.tableFooterView?.height = 125.0
      
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
            if indexPath.row == 2 || indexPath.row == 6 {
                cell.textFIeld.keyboardType = .numberPad
            } else {
                 cell.textFIeld.keyboardType = .default
            }
            return  cell
        case .productSpecifics:
            if indexPath.row == sections[indexPath.section].sectionCount - 1 {
                let cell = tableView.dequeueCell(with: AddDescTableCell.self, indexPath: indexPath)
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
                return cell
            } else {
                let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                if indexPath.row == 0 {
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                    cell.textFIeld.text = self.sortTypeAppliedCategory.category_name
                }else if  indexPath.row == 1 {
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                    cell.textFIeld.text = self.sortTypeAppliedAsset.name
                }else if indexPath.row == 2 {
                     cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                    cell.textFIeld.text = self.sortTypeAppliedToken.name
                } else {
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
                }
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
                cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
                return  cell
            }
        default:
             let cell = tableView.dequeueCell(with: UploadDocumentTableCell.self, indexPath: indexPath)
             cell.imgDataArray = self.imgDataArray
             cell.uploadBtnsTapped = { [weak self] (index)  in
                guard let selff = self else {return}
                selff.showImage { (image) in
                    if image != nil {
                        let image : UIImage = image!
                        let data = image.jpegData(compressionQuality: 0.2)
                        selff.imgDataArray[index.row] = (image,data!,true)
                        selff.mainTableView.reloadData()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell {
            if  let indexPath = mainTableView.indexPath(forItem: cell){
                if sections[indexPath.section] == .productSpecifics {
                    switch indexPath.row {
                    case 0:
                        self.view.endEditing(true)
                        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
                        vc.delegate = self
                        vc.usingForSort = .addAssets
                        vc.sortDataArray = self.categoryListing
                        vc.sortTypeAppliedCategory = self.sortTypeAppliedCategory
                        self.present(vc, animated: true, completion: nil)
                    case 1:
                        self.view.endEditing(true)
                        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
                        vc.delegate = self
                        vc.usingForSort = .assetType
                        vc.sortTypeAssetListing = self.assetTypeListing
                        vc.sortTypeAppliedAsset = sortTypeAppliedAsset
                        self.present(vc, animated: true, completion: nil)
                    case 2:
                        self.view.endEditing(true)
                        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
                        vc.delegate = self
                        vc.usingForSort = .tokenType
                        vc.sortTypeTokenListing = self.tokenTypeListing
                        vc.sortTypeAppliedToken = sortTypeAppliedToken
                        self.present(vc, animated: true, completion: nil)
                    default:
                        print("Do Nothing")
                    }
                }
            }
        }
    }
}
//MARK:- Sorting
//==============
extension AddAssetsVC: ProductSortVCDelegate{
    func sortingAppliedInCategory(sortType: CategoryModel) {
        self.sortTypeAppliedCategory = sortType
        self.mainTableView.reloadData()
    }
    
    func sortingAppliedInAssetType(sortType: AssetTokenTypeModel){
        self.sortTypeAppliedAsset = sortType
        self.mainTableView.reloadData()
    }
    
    func sortingAppliedInTokenType(sortType: AssetTokenTypeModel){
        self.sortTypeAppliedToken = sortType
        self.mainTableView.reloadData()
    }
}

