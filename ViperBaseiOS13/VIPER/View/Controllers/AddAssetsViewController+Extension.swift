//
//  AddAssetsViewController+Extension.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 14/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

extension AddAssetsViewController  {
    
    @IBAction func goBack(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    @IBAction func productSelection(_ sender: UIButton) {
           isClickTokenAssets = false
       }
       
       @IBAction func tokenAssetsSelection(_ sender: UIButton) {
           isClickTokenAssets = true
       }
    
    @IBAction func productRegulartorInvestor(_ sender: UIButton) {
        isFromProductRegular = true
        self.showPdfDocument()
    }
    
    @IBAction func prodDocUpload(_ sender: UIButton) {
        isFromProductRegular = false
        self.showPdfDocument()
    }
    @IBAction func prodChildAssetImgUpload(_ sender: UIButton) {
        
        self.showImage { (image) in
            if image != nil {
                
                let image : UIImage = image!
                let data = image.jpegData(compressionQuality: 0.2)
                self.prodChildImgArray.append(image)
                self.imageDataArray.append(data!)
                
                
                if self.prodChildImgArray.count == 1 {
                    self.prodCollectHeight.constant = 120
                    self.prodCollectionView.reloadData()
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
             }
    }
    
    @IBAction func prodAssetsImg(_ sender: UIButton) {
        
        
        self.showImage { (image) in
                   if image != nil {
                       
                       let image : UIImage = image!
                    //self.productImageName  = image.accessibilityIdentifier!
                       let data = image.jpegData(compressionQuality: 0.2)
                       self.prodAssetsImgData = data
                       self.prodAssetsImg.image = image
                   }
               }
    }
   
    
    @IBAction func prodTokenIm(_ sender: UIButton) {
        self.showImage { (image) in
                          if image != nil {
                              
                              let image : UIImage = image!
                              let data = image.jpegData(compressionQuality: 0.2)
                              self.prodTokenImgData = data
                              self.prodTokenImg.image = image
                          }
            }
    }
    
    
    @IBAction func productCategoryList(_ sender: UIButton) {
        
        
        if categoryArray.count > 0
        {
     
        
        }else{
            
    
            
        }
     
    }
}


extension AddAssetsViewController {
    
    @IBAction func sendRequestClickEvent(_ sender: UIButton) {
        
        switch isClickTokenAssets {
        case true:
            
       /*     param[ProductCreate.keys.tokenname] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.tokensymbol] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.tokenvalue] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.tokensupply] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.decimal] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.token_image] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.asset_title] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.asset_image] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.asset_description] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.asset_amount] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.asset_child_image] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.category_id] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.asset_type] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.regulatory_investigator] = nullStringToEmpty(string: "") as AnyObject
            param[ProductCreate.keys.document] = nullStringToEmpty(string: "") as AnyObject*/
            
            
     guard let assetName = self.nameOfAssetsTxtFld.text, !assetName.isEmpty else
        {
               return ToastManager.show(title: Constants.string.enterAssetName, state: .warning)
        }
            
      guard let tokenName = self.nameOfTokenTxtFld.text, !tokenName.isEmpty else
        {
              return  ToastManager.show(title: Constants.string.enterTokenName, state: .warning)
        }
            
        guard let tokenValue = self.tokenValuTxtFld.text, !tokenValue.isEmpty else
        {
             return  ToastManager.show(title: Constants.string.enterTokenName, state: .warning)
        }
         
        guard let tokenSymbol = self.tokenSymbolTxtFld.text , !tokenSymbol.isEmpty else {
              
         return  ToastManager.show(title: Constants.string.enterTokenSymbol, state: .warning)

        }
        guard let totalToken = self.totalTokenTxtFld.text , !totalToken.isEmpty else
        {
                
          return  ToastManager.show(title: Constants.string.enterTotalToken, state: .warning)

         }
            
        guard let decimal = self.decimalTxtFld.text ,!decimal.isEmpty else
        {
        
            return  ToastManager.show(title: Constants.string.enterDecimal, state: .warning)
                
        }
         
        guard let assetValue = self.valueOfAssetsTxtFld.text ,!assetValue.isEmpty else
        {
            
            return  ToastManager.show(title: Constants.string.enterAssetValue, state: .warning)
                    
        }
            
         guard let decrip = self.desTxtFld.text , !decrip.isEmpty else
         {
            return  ToastManager.show(title: Constants.string.enterDesctription, state: .warning)

            
         }
            
            if assetCategoryID == 0
            {
             ToastManager.show(title: Constants.string.selectCategory, state: .warning)

            return

            }
            
            if assetID == 0
            {
             ToastManager.show(title: Constants.string.selectAsset, state: .warning)
                return
            }
             if tokenID == 0
             {
              ToastManager.show(title: Constants.string.selectToken, state: .warning)
              return
             }
            
            if self.assetsImgData ==  nil
            {
             ToastManager.show(title: Constants.string.uploadAssetImg, state: .warning)
             return
            }
            
            
           if self.tokenImageData == nil
           {
            
            ToastManager.show(title: Constants.string.uploadTokenImage, state: .warning)
            return
            
           }
            
            if self.pdfRegularatorData == nil
            {
            ToastManager.show(title: Constants.string.uploadRegulatory, state: .warning)
            return
        
        
            }
            if self.pdfDocumnetData == nil
            {
                ToastManager.show(title: Constants.string.uploadDocument, state: .warning)
                return
            }
            
            
                       param[ProductCreate.keys.tokenname] = tokenName
                       param[ProductCreate.keys.tokensymbol] = tokenSymbol
                       param[ProductCreate.keys.tokenvalue] = tokenValue
                       param[ProductCreate.keys.tokensupply] = Double(totalToken)
                       param[ProductCreate.keys.decimal] = decimal
                       param[ProductCreate.keys.asset_title] = assetName
                       param[ProductCreate.keys.asset_description] = decrip
                       param[ProductCreate.keys.asset_amount] = Double(assetValue)
                       param[ProductCreate.keys.category_id] = self.assetCategoryID
                       param[ProductCreate.keys.asset_type] = assetID
                       param[ProductCreate.keys.token_type] = tokenID
    
                param["request_deploy"] = isCheck

            dataDic =   [ProductCreate.keys.regulatory_investigator:(pdfRegularatorData!,"regulatory.pdf",FileType.pdf.rawValue),
                         ProductCreate.keys.document :(pdfDocumnetData!,"document.pdf",FileType.pdf.rawValue),
                         ProductCreate.keys.asset_image :(assetsImgData!,"Asset.jpg",FileType.image.rawValue),
                         ProductCreate.keys.token_image :(self.tokenImageData!,"Token.jpg",FileType.image.rawValue)
                         ]
            
            if assetImageDataArray.count > 0
            {
                for (index,value) in self.assetImageDataArray.enumerated()
                {
                    let key = "asset_child_image[\(index)]"
                    dataDic[key] = (value,"ExtraImage\(index).jpg",FileType.image.rawValue)
                    
                }
     }
     
            self.loader.isHidden = false
            self.presenter?.UploadData(api: Base.assetCreate.rawValue, params: param, imageData: dataDic , methodType: .POST, modelClass: SuccessDict.self, token: true)
         
        default:
            
            
            guard let productName = productNameTxtFld.text , !productName.isEmpty else {
                
              return  ToastManager.show(title:Constants.string.pleaseEnterProductName, state: .warning)
                
            }
            
            guard let brandName = brandTxtFld.text , !brandName.isEmpty else {
                
              return  ToastManager.show(title:Constants.string.enterBrand, state: .warning)
                
            }
            
        
            if self.categoryID == 0
            {
                
                ToastManager.show(title:Constants.string.enterNameOfProduct, state: .warning)
                return
                
            }
            
            guard let productValue = valOfProductTxtFld.text , !productValue.isEmpty else
            {
                
                return  ToastManager.show(title:Constants.string.enterProductValue, state: .warning)
                
            }
            
            guard let eanCode = eanTxtFld.text , !eanCode.isEmpty else
            {
                
                return  ToastManager.show(title:Constants.string.enterEAN, state: .warning)
                
            }
            
            guard let hsCode = hsCodeTxtFld.text , !hsCode.isEmpty else {
                
                return  ToastManager.show(title:Constants.string.enterHSCode, state: .warning)

                
            }
            
            guard let startDate = statDateTxtFld.text , !startDate.isEmpty else {
                
                return  ToastManager.show(title:Constants.string.startDate, state: .warning)

                
            }
            
            
            guard let endDate = endDateTxtFld.text , !endDate.isEmpty else {
                
                return  ToastManager.show(title:Constants.string.endDate, state: .warning)

                
            }
            
            guard let maurityDate = matirutydateTxtFld.text, !maurityDate.isEmpty else {
                  return  ToastManager.show(title: "Select maturity date", state: .warning)
            }
            
            guard let descr = productDecTxtView.text, !descr.isEmpty else {
                
                
                return  ToastManager.show(title:Constants.string.enterDesctription, state: .warning)

                
            }
            
            if pdfProdRegularatorData == nil
            {
               
                  ToastManager.show(title:Constants.string.uploadRegulatory, state: .warning)
                  return
                
            }else if pdfProdDocumnetData == nil {
                
                ToastManager.show(title:Constants.string.uploadDocument, state: .warning)
                return
                
                
            }
            else if prodAssetsImgData == nil {
                
                ToastManager.show(title:Constants.string.uploadMainImage, state: .warning)
                               return
                
                
            }else if prodTokenImgData == nil
            {
                
                ToastManager.show(title:Constants.string.uploadTokenImage, state: .warning)
                                             return
       
            }

            param[ProductCreate.keys.product_title] = productName
            param[ProductCreate.keys.category_id] = self.categoryID
            param[ProductCreate.keys.product_description] = descr
            param[ProductCreate.keys.product_value] = Double(productValue)
            param[ProductCreate.keys.brand] = brandName
            param[ProductCreate.keys.ean_upc_code] = eanCode
            param[ProductCreate.keys.hs_code] = hsCode
            param[ProductCreate.keys.products] = 1
            param["start_date"] = startDate
            param["end_date"] = endDate
            
            param["maturity_count"] = self.maturityCount
            param["maturity_date"] = maurityDate
            
            
            
            param["request_deploy"] = productCheck
 
            dataDic =   [ProductCreate.keys.regulatory_investigator:(pdfProdRegularatorData!,self.regulatoryPDFName,FileType.pdf.rawValue),
                         ProductCreate.keys.document :(pdfProdDocumnetData!,"document.pdf",FileType.pdf.rawValue),
                         ProductCreate.keys.product_image :(prodAssetsImgData!,"ProductImage.jpg",FileType.image.rawValue),
                         ]
            
            if imageDataArray.count > 0
            {
                for (index,value) in self.imageDataArray.enumerated()
                {
                    let key = "product_child_image[\(index)]"
                    dataDic[key] = (value,"ExtraImage\(index)",FileType.image.rawValue)
                    
                }
            }
            
            print(">>dataDic",dataDic)
            self.loader.isHidden = false

            self.presenter?.UploadData(api: Base.productCreate.rawValue, params: param, imageData: dataDic , methodType: .POST, modelClass: SuccessDict.self, token: true)
     
        }
        
    }
    
    @IBAction func uploadAssetsVal(_ sender: UIButton) {
        
        
        self.showImage { (image) in
            
            
            if image != nil {
                
                let image : UIImage = image!
                let data = image.jpegData(compressionQuality: 0.2)
                self.assetsImgData = data
                self.assetsImgView.image = image
            }
        }
    }
    @IBAction func uploadTokenImg(_ sender: UIButton) {
        self.showImage { (image) in
            if image != nil {
                
                let image : UIImage = image!
                let data = image.jpegData(compressionQuality: 0.2)
                self.tokenImageData = data
                self.tokenImgView.image = image
            }
        }
    }
}

//MARK: - PresenterOutputProtocol

extension AddAssetsViewController: PresenterOutputProtocol {
   
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
        case Base.assetCreate.rawValue, Base.productCreate.rawValue:
            
            self.loader.isHidden = true
            self.successDict = dataDict as? SuccessDict
            ToastManager.show(title: nullStringToEmpty(string: self.successDict?.success?.msg), state: .success)
//            self.viewDidLoad()
            
            self.navigationController?.popViewController(animated: true)
            
        case Base.category.rawValue:
            
            self.loader.isHidden = true
            self.additonDict = dataDict as? AdditionsModel
            self.categoryArray = self.additonDict?.token_categories ?? []
            self.assetTypeArray = self.additonDict?.asset_type ?? []
            self.tokenTypeArray = self.additonDict?.token_type ?? []
            self.productArray =  self.additonDict?.product_categories ?? []
            self.maturityCount = self.additonDict?.maturity_count ?? []
            
            self.countid = self.maturityCount.map({ (Int($0) ?? 0)})
            
            if self.categoryArray.count > 0 || self.assetTypeArray.count > 0,self.tokenTypeArray.count > 0 || self.productArray.count > 0 {
                setDropDownValues()
            }
            
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden =  true
        ToastManager.show(title: nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
        
    }
}
