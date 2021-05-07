//
//  AddAssetsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 30/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
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
    var productSpecifics = [("Category",""),("Asset Type",""),("Token Type",""),("Description","")]
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var dateInfoArray = [(Constants.string.startDate,""),(Constants.string.endDate,""),("Reward Date",""),("Reward","")]
    var datePicker = CustomDatePicker()
    var sections : [AddProductCell] = [.basicDetailsAssets,.assetsSpecifics,.dateSpecificsAssets,.documentImage]
    
    // MARK: - LifecycleAddProductCell
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.mainTableView.tableFooterView?.height = isDeviceIPad ? 175.0 : 125.0
      
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
        switch sections[indexPath.section] {
        case .documentImage:
            return isDeviceIPad ? 405.0 : 330.0
        default:
            return  UITableView.automaticDimension
        }
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
        case .assetsSpecifics:
            if indexPath.row == sections[indexPath.section].sectionCount - 1 {
                let cell = tableView.dequeueCell(with: AddDescTableCell.self, indexPath: indexPath)
                cell.textView.delegate = self
                cell.titleLbl.text = self.productSpecifics[indexPath.row ].0
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
                cell.titleLbl.text = self.productSpecifics[indexPath.row ].0
                cell.textFIeld.placeholder = self.productSpecifics[indexPath.row].0
                return  cell
            }
          case .dateSpecificsAssets:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            switch indexPath.row {
            case 0:
                cell.textFIeld.text = self.addAssetModel.start_date
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "icCalendar"), normalImage: #imageLiteral(resourceName: "icCalendar"), size: CGSize(width: 20, height: 20),isUserInteractionEnabled: false)
                cell.textFIeld.inputView = datePicker
            case 1:
                cell.textFIeld.text = self.addAssetModel.end_date
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "icCalendar"), normalImage: #imageLiteral(resourceName: "icCalendar"), size: CGSize(width: 20, height: 20),isUserInteractionEnabled: false)
                cell.textFIeld.inputView = datePicker
            case 2:
                cell.textFIeld.text = self.addAssetModel.reward_date
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "icCalendar"), normalImage: #imageLiteral(resourceName: "icCalendar"), size: CGSize(width: 20, height: 20),isUserInteractionEnabled: false)
                cell.textFIeld.inputView = datePicker
                
            default:
                 cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                 cell.textFIeld.text = self.addAssetModel.reward
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
    
    public func isCheckParamsData()-> Bool{
        guard let assetName = self.addAssetModel.asset_title, !assetName.isEmpty else {
             ToastManager.show(title: Constants.string.enterAssetName, state: .warning)
            return false
        }
        guard let tokenName =  self.addAssetModel.tokenname, !tokenName.isEmpty else{
              ToastManager.show(title: Constants.string.enterTokenName, state: .warning)
            return false
        }
        guard let tokenValue =  self.addAssetModel.tokenvalue, !(tokenValue == 0)else{
              ToastManager.show(title: Constants.string.enterTotalToken, state: .warning)
            return false
        }
        guard let tokenSymbol =  self.addAssetModel.tokensymbol , !tokenSymbol.isEmpty else {
              ToastManager.show(title: Constants.string.enterTokenSymbol, state: .warning)
            return false
        }
        guard let decimal = self.addAssetModel.decimal ,!(decimal == 0.0)  else {
              ToastManager.show(title: Constants.string.enterDecimal, state: .warning)
            return false
        }
        guard let assetValue = self.addAssetModel.asset_amount ,!(assetValue == 0) else{
              ToastManager.show(title: Constants.string.enterAssetValue, state: .warning)
            return false
        }
        guard let decrip = self.addAssetModel.asset_description , !decrip.isEmpty else{
              ToastManager.show(title: Constants.string.enterDesctription, state: .warning)
            return false
        }
        guard let assetCategoryID = self.addAssetModel.category_id , !(assetCategoryID == 0) else{
              ToastManager.show(title: Constants.string.selectCategory, state: .warning)
            return false
        }
        guard let assetID = self.addAssetModel.asset_id , !(assetID == 0) else{
              ToastManager.show(title: Constants.string.selectAsset, state: .warning)
            return false
        }
        guard let tokenID = self.addAssetModel.token_id , !(tokenID == 0) else{
                     ToastManager.show(title: Constants.string.selectAsset, state: .warning)
            return false
               }
        if !self.imgDataArray[2].2{
            ToastManager.show(title: Constants.string.uploadAssetImg, state: .warning)
            return false
        }
        if !self.imgDataArray[3].2{
                   ToastManager.show(title: Constants.string.uploadTokenImage, state: .warning)
                   return false
               }
        if !self.imgDataArray[0].2{
            ToastManager.show(title: Constants.string.uploadRegulatory, state: .warning)
            return false
        }
        if !self.imgDataArray[1].2{
            ToastManager.show(title: Constants.string.uploadDocument, state: .warning)
            return false
               }
        return true
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
                            self.addAssetModel.tokenvalue = Double(text)
                            cell.textFIeld.text = text
                        case 3:
                            self.addAssetModel.tokensymbol = text
                            cell.textFIeld.text = text
                        case 4:
                            self.addAssetModel.tokensupply = Int(text)
                            cell.textFIeld.text = text
                        case 5:
                            self.addAssetModel.decimal = Double(text)
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
                        self.addAssetModel.startDate = datePicker.selectedDate()
                        self.addAssetModel.start_date = datePicker.selectedDate()?.convertToStringDefault()
                        self.addAssetModel.rewardDate = nil
                        self.addAssetModel.reward_date = ""
                        self.addAssetModel.endDate = nil
                        self.addAssetModel.end_date = ""
                        self.mainTableView.reloadData()
                    case 1:
                        if self.addAssetModel.startDate == nil {
                             return
                        }
                        cell.textFIeld.text = datePicker.selectedDate()?.convertToStringDefault()
                        self.addAssetModel.end_date = datePicker.selectedDate()?.convertToStringDefault()
                        self.addAssetModel.endDate = datePicker.selectedDate()
                        self.addAssetModel.rewardDate = nil
                        self.addAssetModel.reward_date = ""
                        self.mainTableView.reloadData()
                    case 2:
                        if self.addAssetModel.startDate == nil || self.addAssetModel.endDate == nil{
                            return
                        }
                        cell.textFIeld.text = datePicker.selectedDate()?.convertToStringDefault()
                        self.addAssetModel.rewardDate = datePicker.selectedDate()
                        self.addAssetModel.reward_date = datePicker.selectedDate()?.convertToStringDefault()
                    default:
                        print("")
                    }
                }
                }
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell {
            if  let indexPath = mainTableView.indexPath(forItem: cell){
                if sections[indexPath.section] == .assetsSpecifics {
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
                        if self.addAssetModel.startDate == nil {
                            self.view.endEditing(true)
                            ToastManager.show(title: Constants.string.selectStartDate, state: .warning)
                             return
                        }
                        self.datePicker.datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: self.addAssetModel.startDate ?? Date())
                        self.datePicker.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 50, to: Date())
                        self.datePicker.pickerMode = .date
                    case 2:
                        if self.addAssetModel.startDate == nil || self.addAssetModel.endDate == nil{
                            self.view.endEditing(true)
                            ToastManager.show(title: Constants.string.selectStartEndDate, state: .warning)
                            return
                        }
                        self.datePicker.datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: self.addAssetModel.endDate ?? Date())
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        if let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell {
            if  let indexPath = mainTableView.indexPath(forItem: cell){
                if indexPath.section == 0 {
                    switch indexPath.row {
                    case 5:
                        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                        if updatedText.count == 1 {
                            return true
                        } else if updatedText.count == 2 {
                            return (updatedText.first == "0" || updatedText.first == "1") && updatedText.last != "9" 
                        } else {
                            return updatedText.count <= 2
                        }
                    default:
                        return true
                    }
                }
            }
        }
        return true
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
                            self.imgDataArray[indexx.row] =  (#imageLiteral(resourceName: "pdfIcon"),imageData,true)
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


//    MARK:- UITextViewDelegate
//    ==========================
extension AddAssetsVC : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.addAssetModel.asset_description = text
    }
    
}
