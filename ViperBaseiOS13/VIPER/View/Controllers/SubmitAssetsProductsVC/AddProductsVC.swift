//
//  AddProductsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 30/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import PDFKit
import MobileCoreServices

class AddProductsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    let userProfileInfoo : [UserProfileAttributes] = UserProfileAttributes.allCases
    var addProductModel  =  ProductModel(json: [:])
    var imgDataArray = [(UIImage,Data,Bool)]()
    var selectedIndexPath: IndexPath?
    var categoryListing = [CategoryModel]()
    var sortTypeAppliedCategory = CategoryModel()
    var generalInfoArray = [("Product Name",""),("Brand",""),("Number of Products",""),("HS Code",""),("EAN Code",""),("UPC Code",""),("ZipCode",""),("City",""),("State",""),("Country","")]
    var bankInfoArray = [("Category",""),("Value of Product",""),("Enter Investment (%)",""),("Description","")]
    var dateInfoArray = [("Start Date",""),("End Date",""),("Investment Date",""),("Maturity Count",""),("Maturity Date","")]
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var datePicker = CustomDatePicker()
    var sections : [AddProductCell] = [.basicDetailsProduct,.productSpecifics,.dateSpecificsProducts,.documentImage]
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
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    @IBAction func requestBtnAction(_ sender: UIButton) {
         requestBtn.isSelected.toggle()
        self.addProductModel.request_deploy =  requestBtn.isSelected ? 1 : 0
    }
    
}

// MARK: - Extension For Functions
//===========================
extension AddProductsVC {
    
    private func initialSetup() {
        self.imgDataArray = [(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false)]
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: UploadDocumentTableCell.self)
        self.mainTableView.registerCell(with: UserProfilePhoneNoCell.self)
        self.mainTableView.registerCell(with: UserProfileTableCell.self)
        self.mainTableView.registerCell(with: AddDescTableCell.self)
        self.mainTableView.registerHeaderFooter(with: UserProfileHeaderView.self)
        self.mainTableView.tableFooterView = footerView
        self.mainTableView.tableFooterView?.height = 125.0
    }
    
    public func hitSendRequestApi(){
        self.loader.isHidden = false
        let params = self.addProductModel.getDictForAddProduct()
        let documentData : [String:(Data,String,String)] =   [ProductCreate.keys.regulatory_investigator:(imgDataArray[0].1,"regulatory.pdf",FileType.pdf.rawValue),
                     ProductCreate.keys.document :(imgDataArray[1].1,"document.pdf",FileType.pdf.rawValue),
                     ProductCreate.keys.product_image :(imgDataArray[2].1,"Asset.jpg",FileType.image.rawValue),
                    
            ]
        
        self.presenter?.UploadData(api: Base.campaigner_create_product.rawValue, params: params, imageData: documentData , methodType: .POST, modelClass: SuccessDict.self, token: true)
    }
    
}

// MARK: - Extension For TableView
//===========================
extension AddProductsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].sectionCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: UserProfileHeaderView.self)
        view.titleLbl.text  = self.sections[section].titleValue
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
        case .basicDetailsProduct:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            cell.titleLbl.text = self.generalInfoArray[indexPath.row].0
            cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row].0
            switch indexPath.row {
            case 0:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addProductModel.product_title
            case 1:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addProductModel.brand
            case 2:
                cell.textFIeld.keyboardType = .numberPad
                cell.textFIeld.text =  self.addProductModel.products == nil ? "" :  "\(self.addProductModel.products ?? 0)"
            case 3:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addProductModel.hs_code
            case 4:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addProductModel.ean_upc_code
            case 5:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addProductModel.upc_code
            default:
                cell.textFIeld.keyboardType = .default
                cell.textFIeld.text = self.addProductModel.asset_amount == nil ? "" : "\(self.addProductModel.asset_amount ?? 0)"
            }
            return  cell
        case .productSpecifics:
            if indexPath.row == sections[indexPath.section].sectionCount - 1 {
                let cell = tableView.dequeueCell(with: AddDescTableCell.self, indexPath: indexPath)
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
                cell.textView.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                cell.textFIeld.delegate = self
                switch indexPath.row {
                case 0:
                    cell.textFIeld.keyboardType = .default
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                    cell.textFIeld.text = self.sortTypeAppliedCategory.category_name
                case 1:
                     cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
                    cell.textFIeld.keyboardType = .numberPad
                    cell.textFIeld.text = self.addProductModel.product_value == nil ? "" :  "\(self.addProductModel.product_value ?? 0)"
                case 2:
                     cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
                    cell.textFIeld.keyboardType = .numberPad
                    cell.textFIeld.text =  self.addProductModel.product_investment_count == nil ? "" :  "\(self.addProductModel.product_investment_count ?? 0)"
                default:
                    cell.textFIeld.keyboardType = .default
                    cell.textFIeld.text = self.addProductModel.product_description
                }
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
                cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
                return  cell
            }
        case .dateSpecificsProducts:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "icCalendar"), normalImage: #imageLiteral(resourceName: "icCalendar"), size: CGSize(width: 20, height: 20))
                cell.textFIeld.inputView = datePicker
            } else if indexPath.row == 3 {
                 cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
            } else {
                 cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
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
            cell.isFromAddProduct = true
            cell.tabsCollView.layoutIfNeeded()
            return  cell
        }
    }
}

// MARK: - Extension For TextField Delegate
//====================================
extension AddProductsVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        if let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell {
            if  let indexPath = mainTableView.indexPath(forItem: cell){
                if indexPath.section == 0 {
                    switch indexPath.row {
                    case 0:
                        self.addProductModel.product_title = text
                    case 1:
                        self.addProductModel.brand = text
                    case 2:
                        self.addProductModel.products = Int(text)
                    case 3:
                        self.addProductModel.hs_code = text
                    case 4:
                        self.addProductModel.ean_upc_code = text
                    default:
                        self.addProductModel.upc_code = text
                    }
                } else if indexPath.section == 1 {
                    switch indexPath.row {
                    case 0:
                        self.addProductModel.category_id = Int(text)
                    case 1:
                        self.addProductModel.product_value = Int(text)
                    case 2:
                        self.addProductModel.invest_profit_per = Int(text)
                    case 3:
                        self.addProductModel.product_description = text
                    default:
                        self.addProductModel.product_description = text
                    }
                } else if indexPath.section == 2 {
                    switch indexPath.row {
                    case 0:
                        cell.textFIeld.text = datePicker.selectedDate()?.convertToStringDefault()
                        self.addProductModel.start_date = text
                    case 1:
                        cell.textFIeld.text = datePicker.selectedDate()?.convertToStringDefault()
                        self.addProductModel.end_date = text
                    case 2:
                        cell.textFIeld.text = datePicker.selectedDate()?.convertToStringDefault()
                        self.addProductModel.maturity_date = text
                    default:
                        self.addProductModel.maturity_date = text
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
                        vc.usingForSort = .addProducts
                        vc.sortDataArray = self.categoryListing
                        vc.sortTypeAppliedCategory = self.sortTypeAppliedCategory
                        self.present(vc, animated: true, completion: nil)
                    default:
                        print("Do Nothing")
                    }
                }
                if sections[indexPath.section] == .dateSpecificsProducts{
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
                    default:
                        print("Do Nothing")
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && (string == " ") {
            return false
        }
        return true
    }
}

//MARK:- Sorting
//==============
extension AddProductsVC: ProductSortVCDelegate{
    func sortingAppliedInCategory(sortType: CategoryModel) {
        self.sortTypeAppliedCategory = sortType
        self.addProductModel.category_id =  sortType.id
        self.mainTableView.reloadData()
    }
}

//MARK: - UIDocumentPickerDelegate
extension AddProductsVC: UIDocumentPickerDelegate {
    
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
extension AddProductsVC : PresenterOutputProtocol {
    
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
extension AddProductsVC : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.addProductModel.product_description = text
    }
    
}
