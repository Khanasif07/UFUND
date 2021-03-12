//
//  AddAssetsViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 04/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import PDFKit
import MobileCoreServices
import iOSDropDown
import Alamofire

protocol DateDelegate {
    
    func didReceiveDOB (isReceive: Bool,DOB: String?,isFrom: String?,endDate: Date?)
}



class AddAssetsViewController: UIViewController {
    var currentDateEnd : Date?
    @IBOutlet weak var maurityCountTxtFld: DropDown!
  
    @IBOutlet weak var matirutydateTxtFld: UITextField!
    @IBOutlet weak var maturityView: UIView!
    @IBOutlet weak var maturityCountView: UIView!
    @IBAction func openEndDatePicker(_ sender: UIButton) {
        
        let customAlertViewController = DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
               customAlertViewController.delegate = self
        customAlertViewController.isFrom = "End"
               customAlertViewController.providesPresentationContextTransitionStyle = true;
               customAlertViewController.definesPresentationContext = true;
               customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
               customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
               self.present(customAlertViewController, animated: false, completion: nil)
    }
    @IBAction func openStartDatePicker(_ sender: UIButton) {
        
        let customAlertViewController = DatePickerViewController(nibName: "DatePickerViewController", bundle: nil)
               customAlertViewController.delegate = self
               customAlertViewController.isFrom = "Start"
               customAlertViewController.providesPresentationContextTransitionStyle = true;
               customAlertViewController.definesPresentationContext = true;
               customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
               customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
               self.present(customAlertViewController, animated: false, completion: nil)
    }
    @IBOutlet weak var endDateTxtFld: UITextField!
    @IBOutlet weak var statDateTxtFld: UITextField!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var startDateView: UIView!
    var param  =  [String:Any]()
    @IBOutlet weak var titleLbl: UILabel!
    var isClickTokenAssets = true {
        
        didSet {
            
            if isClickTokenAssets {
                
                tokrnLbl.textColor = UIColor.white
                productLbl.textColor = UIColor(hex: placeHolderColor)
                tokenAssetsGradinateBut.isHidden = false
                productGradinateBut.isHidden = true
                
                productView.isHidden = true
                tokenAssetsView.isHidden = false
                
            } else {
                
                productLbl.textColor = UIColor.white
                       
                tokrnLbl.textColor = UIColor(hex: placeHolderColor)
                tokenAssetsGradinateBut.isHidden = true
                productGradinateBut.isHidden = false
                
                productView.isHidden = false
                tokenAssetsView.isHidden = true
            }
        }
    }
    lazy var loader  : UIView = {
             return createActivityIndicator(self.view)
       }()
    var isCheck = 0
    var successDict: SuccessDict?
    @IBOutlet weak var tokrnLbl: UILabel!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var tokenAssetsGradinateBut: UIButton!
    @IBOutlet weak var productGradinateBut: UIButton!
    @IBOutlet weak var prodCollectionView: UICollectionView!
    @IBOutlet weak var prodAssetsImg: UIImageView!
    @IBOutlet weak var prodTokenImg: UIImageView!
    @IBOutlet weak var prodDesLbl: UILabel!
    @IBOutlet weak var productView: UIScrollView!
    @IBOutlet weak var tokenAssetsView: UIScrollView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var view13: UIView!
    @IBOutlet weak var view12: UIView!
    @IBOutlet weak var view11: UIView!
    @IBOutlet weak var view10: UIView!
    @IBOutlet weak var view9: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    var imgPlaceHolder: [UIImage] = []
    var prodChildImgArray: [UIImage] = []
    var pdfRegularatorData: Data?
    var pdfDocumnetData: Data?
    var tokenImageData: Data?
    var prodAssetsImgData: Data?
    var prodTokenImgData: Data?
    var pdfProdRegularatorData: Data?
    var pdfProdDocumnetData: Data?
    @IBOutlet weak var checkProdButton: UIButton!
    var assetsImgData: Data?
    var isFromRegular: Bool?
    var isFromProductRegular: Bool?
    @IBOutlet weak var productNameTxtFld: UITextField!
    @IBOutlet weak var productNameView: UIView!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var reqDocLbl: UILabel!
    @IBOutlet weak var documentCheckButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var assetsImgView: UIImageView!
    @IBOutlet weak var tokenImgView: UIImageView!
    @IBOutlet weak var prodCollectHeight: NSLayoutConstraint!
    @IBOutlet weak var documentTxtFld: UITextField!
    @IBOutlet weak var regulatoryInvestmentTxtFld: UITextField!
    @IBOutlet weak var desTxtFld: UITextView!
    @IBOutlet weak var tokenTypeValueTxtFld: DropDown!
    @IBOutlet weak var assetsTypeValueTxtFld: DropDown!
    @IBOutlet weak var categoryValTxtFld: DropDown!
    @IBOutlet weak var valueOfAssetsTxtFld: UITextField!
    @IBOutlet weak var decimalTxtFld: UITextField!
    @IBOutlet weak var totalTokenTxtFld: UITextField!
    @IBOutlet weak var tokenValuTxtFld: UITextField!
    @IBOutlet weak var nameOfTokenTxtFld: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameOfAssetsTxtFld: UITextField!
    @IBOutlet weak var tokenSymbolTxtFld: UITextField!
    @IBOutlet weak var valOfProductTxtFld: UITextField!
    @IBOutlet weak var valOfProductView: UIView!
    
    @IBOutlet weak var productCategoryTxtFld: DropDown!
    
    @IBOutlet weak var productCatView: UIView!
    @IBOutlet weak var productsView: UIView!
    @IBOutlet weak var productTxtFld: UITextField!
    @IBOutlet weak var brandTxtFld: UITextField!
    @IBOutlet weak var brandView: UIView!
    @IBOutlet weak var productDecTxtView: UITextView!
    @IBOutlet weak var hsView: UIView!
    @IBOutlet weak var hsCodeTxtFld: UITextField!
    @IBOutlet weak var eanTxtFld: UITextField!
    @IBOutlet weak var productDecView: UIView!
    @IBOutlet weak var productReguView: UIView!
    @IBOutlet weak var prodDocView: UIView!
    @IBOutlet weak var prodRegTxtFld: UITextField!
    @IBOutlet weak var prodDocTxtFld: UITextField!
    @IBOutlet weak var eanView: UIView!
    var imageDataArray = [Data]()
    var assetImageDataArray = [Data]()
    var regulatoryPDFName = String()
    var documentPDFName = String()
    var productImageName = String()
    
    var dataDic =  [String:(Data,String,String)]()
    
    var productArray = [CategoryModel]()
    var categoryArray = [CategoryModel]()
    var assetTypeArray = [CategoryModel]()
    var tokenTypeArray = [CategoryModel]()

    var additonDict : AdditionsModel?
    var categoryID = 0
    var assetCategoryID = 0
    var assetID = 0
    var tokenID = 0
    var productValue = 0.0
    
    var productCheck = 0
    
    var countid = [Int]()
    var maturityCount = [String]()
    var maturityCountStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        isClickTokenAssets = true
        let nibPost = UINib(nibName: XIB.Names.AssetsImgCell, bundle: nil)
        collectionView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.AssetsImgCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.alwaysBounceHorizontal = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibPost1 = UINib(nibName: XIB.Names.AssetsImgCell, bundle: nil)
        prodCollectionView.register(nibPost1, forCellWithReuseIdentifier: XIB.Names.AssetsImgCell)
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        prodCollectionView.collectionViewLayout = layout1
        
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
        prodCollectionView.alwaysBounceHorizontal = false
        prodCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        prodCollectionView.backgroundColor = .clear
        prodCollectionView.delegate = self
        prodCollectionView.dataSource = self
        intialLoads()
        placeHolderSeter()
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        collectionHeight.constant = 0
        prodCollectHeight.constant = 0
    }
    
    
    func intialLoads()
    {
        
        productNameView.applyEffectToView()
        prodDocView.applyEffectToView()
        productReguView.applyEffectToView()
        productDecView.applyEffectToView()
        hsView.applyEffectToView()
        eanView.applyEffectToView()
        valOfProductView.applyEffectToView()
        productCatView.applyEffectToView()
        productsView.applyEffectToView()
        brandView.applyEffectToView()
        view13.applyEffectToView()
        view12.applyEffectToView()
        view11.applyEffectToView()
        view10.applyEffectToView()
        view9.applyEffectToView()
        view8.applyEffectToView()
        view7.applyEffectToView()
        view6.applyEffectToView()
        view5.applyEffectToView()
        view4.applyEffectToView()
        view3.applyEffectToView()
        view2.applyEffectToView()
        view1.applyEffectToView()
        endDateView.applyEffectToView()
        startDateView.applyEffectToView()
        
        getCategoryList()
        sendRequestButton.setGradientBackground()
        
        documentCheckButton.tag = 101
        checkProdButton.tag = 101
        
    }
    
    
    private func getCategoryList()
    {
        
    self.loader.isHidden = false
    self.presenter?.HITAPI(api: Base.category.rawValue, params: nil, methodType: .GET, modelClass: AdditionsModel.self, token: true)
  
    }
    
    
    @IBAction func checkProductDeploy(_ sender: UIButton) {
        
        if checkProdButton.tag == 101 {
            
            checkProdButton.setImage(#imageLiteral(resourceName: "checkIn"), for: .normal)
            checkProdButton.tag = 0
            productCheck = 1
        } else {
            checkProdButton.setImage(#imageLiteral(resourceName: "checkOut"), for: .normal)
            checkProdButton.tag = 101
            productCheck  = 0
        }
    }
    @IBAction func tokenAssetsCheck(_ sender: UIButton) {
        
        if documentCheckButton.tag == 101 {
                 
                 documentCheckButton.setImage(#imageLiteral(resourceName: "checkIn"), for: .normal)
                 documentCheckButton.tag = 0
                 isCheck = 1
             } else {
                 documentCheckButton.setImage(#imageLiteral(resourceName: "checkOut"), for: .normal)
                 documentCheckButton.tag = 101
                 isCheck = 0
             }
    }
    //MARK:- SETUP DROPDOWN VALUES
 
     func setDropDownValues()
     {
        
        var categoryList = [String]()
        var tokenList = [String]()
        var assetList = [String]()
        var categoryIDArray = [Int]()
        var assetIDArray = [Int]()
        var tokenIDArray = [Int]()
        
        
        var productCategoryList = [String]()
        var productIdList = [Int]()

        for index in 0..<self.categoryArray.count
        {
            
            categoryList.append(self.categoryArray[index].category_name!)
            categoryIDArray.append(self.categoryArray[index].id!)
     
        }
        for index in 0..<self.tokenTypeArray.count
        {
               tokenList.append(self.tokenTypeArray[index].name!)
               tokenIDArray.append(self.tokenTypeArray[index].id!)
        }
        
        for index in 0..<self.assetTypeArray.count
        {
               assetList.append(self.assetTypeArray[index].name!)
               assetIDArray.append(self.assetTypeArray[index].id!)
        }
        

           for index in 0..<self.productArray.count
           {
               
               productCategoryList.append(self.productArray[index].category_name!)
               productIdList.append(self.productArray[index].id!)
        
           }
        
        
        
        productCategoryTxtFld.optionArray = productCategoryList
        productCategoryTxtFld.optionIds = productIdList
        productCategoryTxtFld.arrowColor = .clear
        
        
        categoryValTxtFld.optionArray = categoryList
        categoryValTxtFld.optionIds = categoryIDArray
        categoryValTxtFld.arrowColor = .clear
        
        
        
        assetsTypeValueTxtFld.optionArray = assetList
        assetsTypeValueTxtFld.optionIds = assetIDArray
        assetsTypeValueTxtFld.arrowColor = .clear
        
        
        tokenTypeValueTxtFld.optionArray = tokenList
        tokenTypeValueTxtFld.optionIds = tokenIDArray
        tokenTypeValueTxtFld.arrowColor = .clear
        
        
        maurityCountTxtFld.optionArray = maturityCount
               maurityCountTxtFld.optionIds = countid
               maurityCountTxtFld.arrowColor = .clear
             
        matirutydateTxtFld.isUserInteractionEnabled = false
 
        productCategoryTxtFld.didSelect { (categoryName, index,id)  in
            self.categoryID = id
            print(categoryName)
            print(index)
            print(id)
        }
        
        categoryValTxtFld.didSelect { (categoryName, index,id)  in
            self.assetCategoryID = id
            print(categoryName)
            print(index)
            print(id)
        }
        
        
        maurityCountTxtFld.didSelect { (count, index,id)  in
            self.maurityCountTxtFld.text = count
            self.maturityCountStr = count
                 
            if self.currentDateEnd != nil {
                
                let currentDate = self.currentDateEnd
                var dateComponent = DateComponents()
                dateComponent.day = id
                let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate!)
                print("***currentDate",self.currentDateEnd)
                print("***futureDate",futureDate)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                
                self.matirutydateTxtFld.text = nullStringToEmpty(string: dateFormatter.string(from: futureDate!))
            }
            
               
        }
        
        
        
        assetsTypeValueTxtFld.didSelect { (name, index,id)  in
                   self.assetID = id
                   print(name)
                   print(index)
                   print(id)
               }
    
        tokenTypeValueTxtFld.didSelect
            { (name, index,id)  in
                          self.tokenID = id
                          print(name)
                          print(index)
                          print(id)
             }
        
  
    }
    
    
    
    func placeHolderSeter() {
        
       
        maturityView.applyEffectToView()
        maturityCountView.applyEffectToView()
        matirutydateTxtFld.applyEffectToTextField(placeHolderString: "Maturity Date")
        maurityCountTxtFld.applyEffectToTextField(placeHolderString: "Maturity Count")
        
        titleLbl.text = Constants.string.addAssets.localize().uppercased()
        tokrnLbl.text = String(Constants.string.TokenizedAssets.localize().uppercased().dropLast())
        productLbl.text =  String(Constants.string.Products.localize().uppercased().dropLast())
        tokenAssetsGradinateBut.setGradientBackgroundWithoutRadius()
        productGradinateBut.setGradientBackgroundWithoutRadius()
        statDateTxtFld.applyEffectToTextField(placeHolderString: "Start Date")
        endDateTxtFld.applyEffectToTextField(placeHolderString: "End Date")
        prodDocTxtFld.applyEffectToTextField(placeHolderString: "Document")
        productDecTxtView.text =  "Description"
        hsCodeTxtFld.applyEffectToTextField(placeHolderString: "HS CODE")
        eanTxtFld.applyEffectToTextField(placeHolderString: "EAN/UPC CODE")
        valOfProductTxtFld.applyEffectToTextField(placeHolderString: "Value of Product")
        productTxtFld.applyEffectToTextField(placeHolderString: "Products")
        brandTxtFld.applyEffectToTextField(placeHolderString: "Brand")
        productNameTxtFld.applyEffectToTextField(placeHolderString: "Name of Product")
        sendRequestButton.setTitle("Send Request".uppercased(), for: .normal)
        tokenValuTxtFld.applyEffectToTextField(placeHolderString: "Token Value")
        nameOfAssetsTxtFld.applyEffectToTextField(placeHolderString: "Name of asset")
        nameOfTokenTxtFld.applyEffectToTextField(placeHolderString: "Name of Token")
        tokenSymbolTxtFld.applyEffectToTextField(placeHolderString: "Token Symbol")
        totalTokenTxtFld.applyEffectToTextField(placeHolderString: "Total Supply")
        decimalTxtFld.applyEffectToTextField(placeHolderString: "Decimals")
        valueOfAssetsTxtFld.applyEffectToTextField(placeHolderString: "Value of asset")
        categoryValTxtFld.applyEffectToTextField(placeHolderString: "Select Category")
        assetsTypeValueTxtFld.applyEffectToTextField(placeHolderString: "Select Asset")
        tokenValuTxtFld.applyEffectToTextField(placeHolderString: "Token Value")
        tokenTypeValueTxtFld.applyEffectToTextField(placeHolderString: "Select Token")
        desTxtFld.text = "Description"
        prodRegTxtFld.applyEffectToTextField(placeHolderString: "Regulatory Investigator")
        regulatoryInvestmentTxtFld.applyEffectToTextField(placeHolderString: "Regulatory Investigator")
        documentTxtFld.applyEffectToTextField(placeHolderString: "Documents")
        reqDocLbl.text = "Request for deployment"
        prodDesLbl.text = "Request for deployment"
        productCategoryTxtFld.applyEffectToTextField(placeHolderString: "Select Category")
        tokenValuTxtFld.keyboardType = .decimalPad
        totalTokenTxtFld.keyboardType = .numberPad
        decimalTxtFld.keyboardType = .numberPad
        valueOfAssetsTxtFld.keyboardType = .decimalPad
        valOfProductTxtFld.keyboardType = .decimalPad
        prodDocTxtFld.delegate = self
        productDecTxtView.delegate = self
        hsCodeTxtFld.delegate = self
        eanTxtFld.delegate = self
        valOfProductTxtFld.delegate = self
        productTxtFld.delegate = self
        brandTxtFld.delegate = self
        productNameTxtFld.delegate = self
        tokenValuTxtFld.delegate = self
        nameOfAssetsTxtFld.delegate = self
        nameOfTokenTxtFld.delegate = self
        tokenSymbolTxtFld.delegate = self
        totalTokenTxtFld.delegate = self
        decimalTxtFld.delegate = self
        valueOfAssetsTxtFld.delegate = self
        categoryValTxtFld.delegate = self
        assetsTypeValueTxtFld.delegate = self
        tokenValuTxtFld.delegate = self
        tokenTypeValueTxtFld.delegate = self
        desTxtFld.delegate = self
        prodRegTxtFld.delegate = self
        regulatoryInvestmentTxtFld.delegate = self
        documentTxtFld.delegate = self
        productCategoryTxtFld.delegate = self
        maurityCountTxtFld.delegate = self
        desTxtFld.textColor = UIColor(hex: placeHolderColor)
        productDecTxtView.textColor = UIColor(hex: placeHolderColor)
        
    }
}


extension AddAssetsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return imgPlaceHolder.count > 0 ? imgPlaceHolder.count : 0
        } else {
            return prodChildImgArray.count > 0 ? prodChildImgArray.count : 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.AssetsImgCell, for: indexPath) as! AssetsImgCell
            cell.backgroundColor = .clear
            cell.imgView.image = imgPlaceHolder[indexPath.row]
            cell.closeButton.tag = indexPath.row
            cell.closeButton.addTarget(self, action: #selector(uploadImagePicker), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.AssetsImgCell, for: indexPath) as! AssetsImgCell
            cell.backgroundColor = .clear
            cell.imgView.image = prodChildImgArray[indexPath.row]
            cell.closeButton.tag = indexPath.row
            cell.closeButton.addTarget(self, action: #selector(uploadProductChildImagePicker), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width / 3, height: 120)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}

extension AddAssetsViewController {
    
    @objc func uploadImagePicker(sender: UIButton) {
        
        self.imgPlaceHolder.remove(at: sender.tag)
        
        if self.imgPlaceHolder.count == 0 {
            self.collectionHeight.constant = 0
            
        } else {
            let calVal = self.imgPlaceHolder.count % 3
            
            
            if calVal == 0 {
                
                self.collectionHeight.constant = CGFloat(self.imgPlaceHolder.count / 3 * 120)
                
            } else {
                
                let tableHeight : Int = Int(self.imgPlaceHolder.count / 3)
                self.collectionHeight.constant = CGFloat(tableHeight * 120 + 120)
            }
            
            self.collectionView.reloadData()
            
        }
    }
    
    
    @objc func uploadProductChildImagePicker(sender: UIButton) {
        self.prodChildImgArray.remove(at: sender.tag)
        
        if self.prodChildImgArray.count == 0 {
            
            self.prodCollectHeight.constant = 0
           
        } else {
            let calVal = self.prodChildImgArray.count % 3
          
            
            if calVal == 0 {
                
                self.prodCollectHeight.constant = CGFloat(self.prodChildImgArray.count / 3 * 120)
                
            } else {
                
                let tableHeight : Int = Int(self.prodChildImgArray.count / 3)
                self.prodCollectHeight.constant = CGFloat(tableHeight * 120 + 120)
            }
            
            self.prodCollectionView.reloadData()
            
        }
    }
    
    @IBAction func openerDocument(_ sender: UIButton) {
        isFromRegular = false
        self.showPdfDocument()
    }
    @IBAction func openerRegulatoryInvestment(_ sender: UIButton) {
        isFromRegular = true
        self.showPdfDocument()
    }
    
}

//MARK: - UIDocumentPickerDelegate
extension AddAssetsViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        
        let filename =  url.lastPathComponent
    
        print(">>>>> filename",filename,isFromProductRegular)
        
        
        
     if isFromRegular == true {
            
            regulatoryInvestmentTxtFld.text = filename
        self.regulatoryPDFName = filename
            if let myURL = url as? URL {
                print("import result : \(myURL)")
                DispatchQueue.global(qos: .userInitiated).async {
                    do{
                        let imageData: Data = try Data(contentsOf: myURL)
                        
                        print(">>>",imageData)
                        self.pdfRegularatorData = imageData
                        
                        
                    }catch{
                        print("Unable to load data: \(error)")
                    }
                }
            }
            
        } else if isFromRegular == false {
            documentTxtFld.text = filename
          self.documentPDFName = filename
            if let myURL = url as? URL {
                print("import result : \(myURL)")
                DispatchQueue.global(qos: .userInitiated).async {
                  
                    do{
                        let imageData: Data = try Data(contentsOf: myURL)
                        
                        print(">>>",imageData)
                        self.pdfDocumnetData = imageData
                        
                        
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
            }
        } else if isFromProductRegular == true {
            prodRegTxtFld.text = filename
         self.regulatoryPDFName = filename
            if let myURL = url as? URL {
                print("import result : \(myURL)")
                DispatchQueue.global(qos: .userInitiated).async {
                    do{
                        let imageData: Data = try Data(contentsOf: myURL)
                        
                        print(">>>",imageData)
                        self.pdfProdRegularatorData = imageData
                        
                        
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
            }
            
            
        } else if isFromProductRegular == false  {
            prodDocTxtFld.text = filename
            if let myURL = url as? URL {
                print("import result : \(myURL)")
                DispatchQueue.global(qos: .userInitiated).async {
                    do{
                        let imageData: Data = try Data(contentsOf: myURL)
                        
                        print(">>>",imageData)
                        self.pdfProdDocumnetData = imageData
                        
                        
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
            }
            
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



extension AddAssetsViewController {
    
    @IBAction func uploadAssetsImg(_ sender: UIButton) {
        
        self.showImage { (image) in
            if image != nil {
                
                let image : UIImage = image!
                let data = image.jpegData(compressionQuality: 0.2)
                self.assetImageDataArray.append(data!)
                self.imgPlaceHolder.append(image)
                if self.imgPlaceHolder.count == 1 {
                    self.collectionHeight.constant = 120
                    self.collectionView.reloadData()
                } else {
                    
                    let calVal = self.imgPlaceHolder.count % 3
                    
                    
                    if calVal == 0 {
                        
                        self.collectionHeight.constant = CGFloat(self.imgPlaceHolder.count / 3 * 120)
                        
                    } else {
                        
                        let tableHeight : Int = Int(self.imgPlaceHolder.count / 3)
                        self.collectionHeight.constant = CGFloat(tableHeight * 120 + 120)
                    }
                    
                    self.collectionView.reloadData()
                    
                }
                
                
            }
        }
    }
}


extension AddAssetsViewController {
    
    @IBAction func tokenValue(_ sender: UIButton) {
        
    }
    
    @IBAction func assetsTypeVal(_ sender: UIButton) {
        
    }
    
    @IBAction func opernerCategoryValue(_ sender: UIButton) {
        
    }
}

extension AddAssetsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.text = nil
        textView.textColor = UIColor.black
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if desTxtFld.text.isEmpty {
            desTxtFld.text = "Description"
            desTxtFld.textColor = UIColor.lightGray
        }
        
        if productDecTxtView.text.isEmpty {
            productDecTxtView.text = "Description"
            productDecTxtView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}


extension AddAssetsViewController : UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if  textField == productCategoryTxtFld {
            self.view.endEditingForce()
            productCategoryTxtFld.showList()
            
        }
        if textField == assetsTypeValueTxtFld {
             self.view.endEditingForce()
            assetsTypeValueTxtFld.showList()
            
        }
        if textField == tokenTypeValueTxtFld {
             self.view.endEditingForce()
            tokenTypeValueTxtFld.showList()
            
        }
        if textField == categoryValTxtFld {
             self.view.endEditingForce()
            categoryValTxtFld.showList()
            
        }
        
        if textField == maurityCountTxtFld {
            
            self.view.endEditingForce()
            
            if self.endDateTxtFld.text == "" {
                ToastManager.show(title: "Please Select End Start", state: .warning)
            } else {
                 maurityCountTxtFld.showList()
                
            }
        }
        
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditingForce()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
    

}



extension AddAssetsViewController: DateDelegate {
    func didReceiveDOB (isReceive: Bool,DOB: String?,isFrom: String?,endDate: Date?) {
        if isReceive == true {
                 
            if isFrom == "Start" {
                self.statDateTxtFld.text = nullStringToEmpty(string: DOB)
            }  else {
                self.endDateTxtFld.text = nullStringToEmpty(string: DOB)
                self.currentDateEnd = endDate
                print("*** self.currentDateEnd", self.currentDateEnd)
                
                
             
                               
                          if self.maturityCountStr != "" {
                              
                              let currentDate = self.currentDateEnd
                              var dateComponent = DateComponents()
                              dateComponent.day = Int(self.maturityCountStr ?? "")
                              let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate!)
                              print("***currentDate",self.currentDateEnd)
                              print("***futureDate",futureDate)
                              let dateFormatter = DateFormatter()
                              dateFormatter.dateFormat = "yyyy-MM-dd"
                              
                              
                              self.matirutydateTxtFld.text = nullStringToEmpty(string: dateFormatter.string(from: futureDate!))
                          }
            }
            
        }
    }
    
   
}
extension Date {

    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
