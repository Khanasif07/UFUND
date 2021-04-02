//
//  AddAssetsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 30/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import PDFKit
import MobileCoreServices


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
    var selectedIndexPath : IndexPath?
    var categoryListing = [CategoryModel]()
    var assetTypeListing = [AssetTokenTypeModel]()
    var tokenTypeListing = [AssetTokenTypeModel]()
    var sortTypeAppliedCategory = CategoryModel()
    var sortTypeAppliedAsset = AssetTokenTypeModel()
    var sortTypeAppliedToken = AssetTokenTypeModel()
    var sortTypeAppliedReward = ""
    let assetsByRewardsDetails : [(String,Bool)] =   [("Interest",false),("Share",false),("Goods",false)]
    var generalInfoArray = [("Name of Asset",""),("Token Name",""),("Value of Token",""),("Token Symbol",""),("Token Supply",""),("Decimal",""),("Value of Asset","")]
    var bankInfoArray = [("Category",""),("Asset Type",""),("Token Type",""),("Description","")]
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var dateInfoArray = [("Start Date",""),("End Date",""),("Reward Date",""),("Reward","")]
    var datePicker = CustomDatePicker()
    var sections : [AddProductCell] = [.basicDetailsAssets,.productSpecifics,.dateSpecificsAssets,.documentImage]
    
    // MARK: - LifecycleAddProductCell
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
        addAssetModel.request_deploy =  requestBtn.isSelected ? 1 : 0
    }
    
}

// MARK: - Extension For Functions
//===========================
extension AddAssetsVC {
    private func initialSetup() {
        self.imgDataArray = [(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false)]
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
    
    public func hitSendRequestApi(){
        self.isCheckParamsData()
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
            switch indexPath.row {
            case 0:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addAssetModel.asset_title
            case 1:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addAssetModel.tokenname
            case 2:
                cell.textFIeld.keyboardType = .numberPad
                cell.textFIeld.text =  self.addAssetModel.tokenvalue == nil ? "" :  "\(self.addAssetModel.tokenvalue ?? 0)"
            case 3:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addAssetModel.tokensymbol
            case 4:
                cell.textFIeld.keyboardType = .numberPad
                cell.textFIeld.text = self.addAssetModel.tokensupply == nil ?  "" : "\(self.addAssetModel.tokensupply ?? 0)"
            case 5:
                cell.textFIeld.keyboardType = .numberPad
                cell.textFIeld.text = self.addAssetModel.decimal == nil ? "" : "\(self.addAssetModel.decimal ?? 0)"
            default:
                cell.textFIeld.keyboardType = .numberPad
                cell.textFIeld.text = self.addAssetModel.asset_amount == nil ? "" : "\(self.addAssetModel.asset_amount ?? 0)"
            }
            return  cell
        case .productSpecifics:
            if indexPath.row == sections[indexPath.section].sectionCount - 1 {
                let cell = tableView.dequeueCell(with: AddDescTableCell.self, indexPath: indexPath)
                cell.textView.delegate = self
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
          case .dateSpecificsAssets:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            switch indexPath.row {
            case 0:
                cell.textFIeld.text = self.addAssetModel.start_date
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "icCalendar"), normalImage: #imageLiteral(resourceName: "icCalendar"), size: CGSize(width: 20, height: 20))
                cell.textFIeld.inputView = datePicker
            case 1:
                cell.textFIeld.text = self.addAssetModel.end_date
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "icCalendar"), normalImage: #imageLiteral(resourceName: "icCalendar"), size: CGSize(width: 20, height: 20))
                cell.textFIeld.inputView = datePicker
            case 2:
                cell.textFIeld.text = self.addAssetModel.reward_date
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "icCalendar"), normalImage: #imageLiteral(resourceName: "icCalendar"), size: CGSize(width: 20, height: 20))
                cell.textFIeld.inputView = datePicker
                
            default:
                 cell.textFIeld.text = self.addAssetModel.reward
                 cell.textFIeld.text = self.sortTypeAppliedReward
                 cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
            }
            cell.titleLbl.text = self.dateInfoArray[indexPath.row ].0
            cell.textFIeld.placeholder = self.dateInfoArray[indexPath.row].0
            return  cell
        default:
            let cell = tableView.dequeueCell(with: UploadDocumentTableCell.self, indexPath: indexPath)
            cell.imgDataArray = self.imgDataArray
            cell.uploadBtnsTapped = { [weak self] (index)  in
                guard let selff = self else {return}
                if index.row == 0 || index.row == 1 {
                    selff.selectedIndexPath = index
                    selff.showPdfDocument()
                } else {
                    selff.showImage { (image) in
                        if image != nil {
                            let image : UIImage = image!
                            let data = image.jpegData(compressionQuality: 0.2)
                            selff.imgDataArray[index.row] = (image,data!,true)
                            selff.mainTableView.reloadData()
                        }
                    }
                }
            }
            cell.isFromAddProduct = false
            cell.tabsCollView.layoutIfNeeded()
            return  cell
        }
    }
    
    private func isCheckParamsData(){
        guard let assetName = self.addAssetModel.asset_title, !assetName.isEmpty else {
            return ToastManager.show(title: Constants.string.enterAssetName, state: .warning)
        }
        guard let tokenName =  self.addAssetModel.tokenname, !tokenName.isEmpty else{
            return  ToastManager.show(title: Constants.string.enterTokenName, state: .warning)
        }
        guard let tokenValue =  self.addAssetModel.tokenvalue, !(tokenValue == 0)else{
            return  ToastManager.show(title: Constants.string.enterTotalToken, state: .warning)
        }
        guard let tokenSymbol =  self.addAssetModel.tokensymbol , !tokenSymbol.isEmpty else {
            return  ToastManager.show(title: Constants.string.enterTokenSymbol, state: .warning)
        }
        guard let decimal = self.addAssetModel.decimal ,!(decimal == 0)  else {
            return  ToastManager.show(title: Constants.string.enterDecimal, state: .warning)
        }
        guard let assetValue = self.addAssetModel.asset_amount ,!(assetValue == 0) else{
            return  ToastManager.show(title: Constants.string.enterAssetValue, state: .warning)
        }
        
        guard let decrip = self.addAssetModel.asset_description , !decrip.isEmpty else{
            return  ToastManager.show(title: Constants.string.enterDesctription, state: .warning)
        }
        
        guard let assetCategoryID = self.addAssetModel.category_id , !(assetCategoryID == 0) else{
            return  ToastManager.show(title: Constants.string.selectCategory, state: .warning)
        }
        guard let assetID = self.addAssetModel.asset_id , !(assetID == 0) else{
            return  ToastManager.show(title: Constants.string.selectAsset, state: .warning)
        }
        guard let tokenID = self.addAssetModel.token_id , !(tokenID == 0) else{
                   return  ToastManager.show(title: Constants.string.selectAsset, state: .warning)
               }
        if !self.imgDataArray[2].2{
            ToastManager.show(title: Constants.string.uploadAssetImg, state: .warning)
            return
        }
        if !self.imgDataArray[3].2{
                   ToastManager.show(title: Constants.string.uploadTokenImage, state: .warning)
                   return
               }
        if !self.imgDataArray[0].2{
            ToastManager.show(title: Constants.string.uploadRegulatory, state: .warning)
            return
        }
        if !self.imgDataArray[1].2{
            ToastManager.show(title: Constants.string.uploadDocument, state: .warning)
            return
               }
        self.loader.isHidden = false
        let params = self.addAssetModel.getDictForAddAsset()
        let documentData: [String:(Data,String,String)] =   [ProductCreate.keys.regulatory_investigator:(imgDataArray[0].1,"regulatory.pdf",FileType.pdf.rawValue),
                     ProductCreate.keys.document :(imgDataArray[1].1,"document.pdf",FileType.pdf.rawValue),
                     ProductCreate.keys.asset_image :(imgDataArray[2].1,"Asset.jpg",FileType.image.rawValue),
                     ProductCreate.keys.token_image :(imgDataArray[3].1,"Token.jpg",FileType.image.rawValue)
            ]
        
        self.presenter?.UploadData(api: Base.campaigner_create_asset.rawValue, params: params, imageData: documentData , methodType: .POST, modelClass: SuccessDict.self, token: true)
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
                            cell.textFIeld.text = text
                        case 1:
                            self.addAssetModel.tokenname = text
                            cell.textFIeld.text = text
                        case 2:
                            self.addAssetModel.tokenvalue = Int(text)
                            cell.textFIeld.text = text
                        case 3:
                            self.addAssetModel.tokensymbol = text
                            cell.textFIeld.text = text
                        case 4:
                            self.addAssetModel.tokensupply = Int(text)
                            cell.textFIeld.text = text
                        case 5:
                            self.addAssetModel.decimal = Int(text)
                            cell.textFIeld.text = text
                        default:
                            self.addAssetModel.asset_amount = Int(text)
                            cell.textFIeld.text = text
                        }
                    }
                 if indexPath.section == 2 {
                    switch indexPath.row {
                    case 0:
                        cell.textFIeld.text = datePicker.selectedDate()?.convertToStringDefault()
                        self.addAssetModel.start_date = text
                    case 1:
                        cell.textFIeld.text = datePicker.selectedDate()?.convertToStringDefault()
                        self.addAssetModel.end_date = text
                    case 2:
                        cell.textFIeld.text = datePicker.selectedDate()?.convertToStringDefault()
                        self.addAssetModel.reward_date = text
                    default:
                        self.addAssetModel.reward_date = text
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
                if sections[indexPath.section] == .dateSpecificsAssets {
                    switch indexPath.row {
                    case 0:
                        self.datePicker.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
                        self.datePicker.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 50, to: Date())
                        self.datePicker.pickerMode = .date
                    case 1:
                        self.datePicker.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
                        self.datePicker.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 50, to: Date())
                        self.datePicker.pickerMode = .date
                    case 2:
                        self.datePicker.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
                        self.datePicker.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 50, to: Date())
                        self.datePicker.pickerMode = .date
                    case 3:
                        self.view.endEditing(true)
                        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
                        vc.delegate = self
                        vc.usingForSort = .filter
                        vc.sortArray = self.assetsByRewardsDetails
                        vc.sortTypeApplied = sortTypeAppliedReward
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
        self.addAssetModel.category_id =  sortType.id
        self.mainTableView.reloadData()
    }
    
    func sortingAppliedInAssetType(sortType: AssetTokenTypeModel){
        self.sortTypeAppliedAsset = sortType
        self.addAssetModel.asset_id =  sortType.id
        self.mainTableView.reloadData()
    }
    
    func sortingAppliedInTokenType(sortType: AssetTokenTypeModel){
        self.sortTypeAppliedToken = sortType
        self.addAssetModel.token_id =  sortType.id
        self.mainTableView.reloadData()
    }
    
    func sortingApplied(sortType: String) {
        self.sortTypeAppliedReward = sortType
        self.addAssetModel.reward =  sortType
        self.mainTableView.reloadData()
    }
}

//MARK: - UIDocumentPickerDelegate
extension AddAssetsVC: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        let filename =  url.lastPathComponent
//        print(">>>>> filename",filename,isFromProductRegular
            if let myURL = url as? URL {
                print("import result : \(myURL)")
                DispatchQueue.global(qos: .userInitiated).async {
                    do{
                        let imageData: Data = try Data(contentsOf: myURL)
                        if let indexx = self.selectedIndexPath {
                            self.imgDataArray[indexx.row] =  (#imageLiteral(resourceName: "bg2"),imageData,true)
                        }
                        print(">>>",imageData)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
                self.mainTableView.reloadData()
            }
    }
    
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UPLOAD PDF DOCUMENT
    func showPdfDocument() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
}

//    MARK:- PresenterOutputProtocol
//    ==========================
extension AddAssetsVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
         self.loader.isHidden = true
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
        
    }
    
}

//    MARK:- UITextViewDelegate
//    ==========================
extension AddAssetsVC : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.addAssetModel.asset_description = text
    }
    
}
