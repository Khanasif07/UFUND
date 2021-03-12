//
//  FilterSetViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 26/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import iOSDropDown
import ObjectMapper

protocol FilterDelegate {
    
    func didReceiveFilterData(tokenOrProduct: String, catogories: String, ids: Int, minValue: Double, maxValue: Double)
}

class FilterSetViewController: UIViewController {
  
    var delegate: FilterDelegate?
    var tokenOrProduct: String?
    @IBOutlet weak var dropDropButton: UIButton!
    @IBOutlet weak var rangeSeekSilder: CustomRangeSeekSlider!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var filterTxtFld: DropDown!
    @IBOutlet weak var allDropView: UIView!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    private lazy var loader  : UIView = {
                     return createActivityIndicator(self.view)
    }()
    var filterDataEntity : FilterDataEntity?
    var categories = [Categories]()
    var filterStr = [String]()
    var filterId = [Int]()
    var selectedId : Int?
    var selectedText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        getFilterData()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        filterTxtFld.didSelect{(selectedText , index ,id) in
            
            self.filterTxtFld.text = selectedText
            self.selectedId = id
            self.selectedText = nullStringToEmpty(string: selectedText)
            print("Selected String: \(selectedText) \n index: \(index) \n Id: \(id)")
            UserDefaults.standard.set(nullStringToEmpty(string: selectedText), forKey: UserDefaultsKey.key.filterCategories)
            
         }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        localize()
        applyButton.setGradientBackground()
        catView.applyShadow()
        allDropView.applyEffectToView()
        dropDropButton.tag = 101
        filterTxtFld.arrowColor = .clear
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    @IBAction func filterOpener(_ sender: UIButton) {
        
        if dropDropButton.tag == 101 {
            filterTxtFld.showList()
            dropDropButton.tag = 0
        } else {
            filterTxtFld.hideList()
            dropDropButton.tag = 101
        }
    }
}

extension FilterSetViewController {
    
    func localize() {
        
        titleLbl.textColor = UIColor(hex: darkTextColor)
        titleLbl.text = Constants.string.filter.uppercased()
        applyButton.setTitle(Constants.string.applyFilter.localize().uppercased(), for: .normal)
        reset.setTitle(Constants.string.RESET.localize().uppercased(), for: .normal)
        reset.setTitleColor(UIColor(hex: redTextColor), for: .normal)
        
    }
}

extension FilterSetViewController {
  
    @IBAction func goBack(_ sender: UIButton) {
          self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyFilter(_ sender: UIButton) {
        
        
        print(">>>self.selectedId",self.selectedId)
        UserDefaults.standard.set(Double(self.rangeSeekSilder.selectedMinValue), forKey: UserDefaultsKey.key.minValue)
        UserDefaults.standard.set(Double(self.rangeSeekSilder.selectedMaxValue), forKey: UserDefaultsKey.key.maxValue)
        UserDefaults.standard.set(nullStringToEmpty(string: selectedText), forKey: UserDefaultsKey.key.filterCategories)
        
        self.dismiss(animated:true, completion: { [weak self] in
        
        
                        guard let self = self else {
                            return
        }
            
        self.delegate?.didReceiveFilterData(tokenOrProduct: nullStringToEmpty(string: self.tokenOrProduct), catogories: nullStringToEmpty(string: self.selectedText), ids: self.selectedId ?? 0, minValue: Double(self.rangeSeekSilder.selectedMinValue) , maxValue: Double(self.rangeSeekSilder.selectedMaxValue))
        
        
        })
    }
    
    @IBAction func resetTheFilter(_ sender: UIButton) {
        
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.key.filterCategories)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.key.minValue)
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.key.maxValue)
        self.dismiss(animated:true, completion: { [weak self] in
        
        
                        guard let self = self else {
                            return
        }
         self.delegate?.didReceiveFilterData(tokenOrProduct: nullStringToEmpty(string: self.tokenOrProduct), catogories: nullStringToEmpty(string: self.selectedText), ids: self.selectedId ?? 0, minValue: Double(self.rangeSeekSilder.minValue) , maxValue: Double(self.rangeSeekSilder.maxValue))
        })
    }
}


extension FilterSetViewController : PresenterOutputProtocol {
   
    func getFilterData() {
        self.loader.isHidden = false
        print(">>>tokenOrProduct",tokenOrProduct)
        self.presenter?.HITAPI(api: Base.filter.rawValue + nullStringToEmpty(string: tokenOrProduct), params: nil, methodType: .GET, modelClass: FilterDataEntity.self, token: true)
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
     
        switch api {
            
        case nullStringToEmpty(string: Base.filter.rawValue) + nullStringToEmpty(string: tokenOrProduct):
            
            self.categories.removeAll()
            self.filterStr.removeAll()
            self.filterId.removeAll()
            
            
            self.loader.isHidden = true
            self.filterDataEntity = dataDict as? FilterDataEntity
            self.categories = self.filterDataEntity?.categories ?? []
            
            self.filterStr.append("All")
            self.filterId.append(0)
            
            let rangerMaxVal = (self.filterDataEntity?.range_max ?? 0.0) + 10
            
            if self.categories.count > 0 {
                
                for item in self.categories {
                    self.filterStr.append(nullStringToEmpty(string: item.category_name))
                    self.filterId.append(item.id ?? 0)
                }
                
            }
            
            print(">>>>>self.filterId",self.filterId)
            filterTxtFld.optionArray = filterStr
            filterTxtFld.optionIds = filterId
            
            if self.filterStr.count > 0 {
                
                if let filterData = UserDefaults.standard.value(forKey: UserDefaultsKey.key.filterCategories) as? String {
                    
                    
                    if self.filterStr.contains(nullStringToEmpty(string: filterData)) {
                        
                        filterTxtFld.text = nullStringToEmpty(string: filterData)
                        self.selectedText = nullStringToEmpty(string: filterData)
                        self.selectedId = 0
                    }
                    
                } else {
                    
                    filterTxtFld.text = nullStringToEmpty(string: self.filterStr.first)
                    self.selectedText = nullStringToEmpty(string: self.filterStr.first)
                    self.selectedId = 0
                }
                
                
            }
            
            rangeSeekSilder.minValue = CGFloat(self.filterDataEntity?.range_min ?? 0.0)
            rangeSeekSilder.maxValue = CGFloat(rangerMaxVal)
            
            
            if UserDefaults.standard.value(forKey: UserDefaultsKey.key.maxValue) != nil || UserDefaults.standard.value(forKey: UserDefaultsKey.key.minValue) != nil {
                
                if let minVal = UserDefaults.standard.value(forKey: UserDefaultsKey.key.minValue) as? Double {
                    
                    rangeSeekSilder.selectedMinValue = (self.filterDataEntity?.range_min ?? 0.0)...(self.filterDataEntity?.range_max ?? 0.0)  ~=  minVal ?  CGFloat(minVal) :  CGFloat(self.filterDataEntity?.range_min ?? 0.0)
                }
                
                if let maxValue = UserDefaults.standard.value(forKey: UserDefaultsKey.key.maxValue) as? Double {
                    
                    rangeSeekSilder.selectedMaxValue = (self.filterDataEntity?.range_min ?? 0.0)...(self.filterDataEntity?.range_max ?? 0.0)  ~=  maxValue  ? CGFloat(maxValue) : CGFloat(rangerMaxVal)
                }
            
            } else {
                
                rangeSeekSilder.selectedMaxValue = CGFloat(rangerMaxVal)
            }

        default:
            
            break
        }
  
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
    }
 
}


