//
//  AddProductsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 30/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

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
    var categoryListing = [CategoryModel]()
    var sortTypeAppliedCategory = CategoryModel()
    var generalInfoArray = [("Product Name",""),("Brand",""),("Number of Products",""),("HS Code",""),("EAN Code",""),("UPC Code",""),("ZipCode",""),("City",""),("State",""),("Country","")]
    var bankInfoArray = [("Category",""),("Value of Product",""),("Enter Investment (%)",""),("Description","")]
    var dateInfoArray = [("Start Date",""),("End Date",""),("Investment Date",""),("Maturity Count",""),("Maturity Date","")]
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var sections : [AddProductCell] = [.basicDetailsProduct,.productSpecifics,.dAteSpecifics,.documentImage]
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
    }
    
}

// MARK: - Extension For Functions
//===========================
extension AddProductsVC: PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
    private func initialSetup() {
        self.imgDataArray = [(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false),(#imageLiteral(resourceName: "checkOut"),Data(),false)]
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
            if indexPath.row == 2{
                cell.textFIeld.keyboardType = .numberPad
            } else {
                 cell.textFIeld.keyboardType = .default
            }
            return  cell
        case .productSpecifics:
            if indexPath.row == sections[indexPath.section].sectionCount - 1 {
                let cell = tableView.dequeueCell(with: AddDescTableCell.self, indexPath: indexPath)
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
//                cell.textView.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                cell.textFIeld.delegate = self
                if indexPath.row == 1 || indexPath.row == 2{
                    cell.textFIeld.keyboardType = .numberPad
                } else {
                     cell.textFIeld.keyboardType = .default
                }
                if indexPath.row == 0{
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
                    cell.textFIeld.text = self.sortTypeAppliedCategory.category_name
                } else {
                    cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: nil, normalImage: nil, size: CGSize(width: 0, height: 0))
                }
                cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
                cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
                return  cell
            }
        case .dAteSpecifics:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "icCalendar"), normalImage: #imageLiteral(resourceName: "icCalendar"), size: CGSize(width: 20, height: 20))
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
                selff.showImage { (image) in
                    if image != nil {
                        let image : UIImage = image!
                        let data = image.jpegData(compressionQuality: 0.2)
                        selff.imgDataArray[index.row] = (image,data!,true)
                        selff.mainTableView.reloadData()
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
                        self.addProductModel.hs_code = text
                    case 3:
                        self.addProductModel.ean_upc_code = text
                    case 4:
                        self.addProductModel.hs_code = text
                    default:
                        self.addProductModel.hs_code = text
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
                        self.addProductModel.start_date = text
                    case 1:
                        self.addProductModel.end_date = text
                    case 2:
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

//MARK:- Sorting
//==============
extension AddProductsVC: ProductSortVCDelegate{
    func sortingAppliedInCategory(sortType: CategoryModel) {
        self.sortTypeAppliedCategory = sortType
        self.mainTableView.reloadData()
    }
}
