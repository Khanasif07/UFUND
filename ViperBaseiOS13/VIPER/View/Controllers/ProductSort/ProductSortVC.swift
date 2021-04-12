//
//  ProductSortVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit

protocol ProductSortVCDelegate:class {
    func sortingApplied(sortType: String)
    func sortingAppliedInCategory(sortType: CategoryModel)
    func sortingAppliedInAssetType(sortType: AssetTokenTypeModel)
    func sortingAppliedInTokenType(sortType: AssetTokenTypeModel)
}

extension ProductSortVCDelegate {
    func sortingApplied(sortType: String){}
    func sortingAppliedInCategory(sortType: CategoryModel) {}
    func sortingAppliedInAssetType(sortType: AssetTokenTypeModel){}
    func sortingAppliedInTokenType(sortType: AssetTokenTypeModel){}
}

class ProductSortVC: UIViewController {
    enum UsingForSort{
        case filter
        case addAssets
        case assetType
        case tokenType
        case addProducts
        case reward
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableViewHConst: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    // MARK: - Variables
    //===========================
    var usingForSort : UsingForSort = .filter
    weak var delegate :ProductSortVCDelegate?
    var sortArray = [(Constants.string.sort_by_latest,false),(Constants.string.sort_by_oldest,false),(Constants.string.sort_by_name_AZ,false),(Constants.string.sort_by_name_ZA,false)]
    var sortTypeApplied: String  = ""
    var sortTypeAppliedCategory = CategoryModel()
    var sortTypeAppliedAsset = AssetTokenTypeModel()
    var sortTypeAppliedToken = AssetTokenTypeModel()
    var sortDataArray = [CategoryModel]()
    var sortTypeAssetListing = [AssetTokenTypeModel]()
    var sortTypeTokenListing = [AssetTokenTypeModel]()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.dataContainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15.0)
        mainTableView.frame = CGRect(x: mainTableView.frame.origin.x, y: mainTableView.frame.origin.y, width: mainTableView.frame.size.width, height: mainTableView.contentSize.height)
        if mainTableView.frame.height + 15.0 >= (UIScreen.main.bounds.height){
            tableViewHConst.constant = UIScreen.main.bounds.height - 220.0
        } else{
            tableViewHConst.constant = mainTableView.frame.height + 15.0
        }
        mainTableView.reloadData()
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension ProductSortVC {
    
    private func initialSetup() {
        switch usingForSort {
        case .filter:
            self.titleLbl.text = Constants.string.sort_by.localize()
            self.setSelectedSortingData()
        case .assetType:
            self.titleLbl.text = Constants.string.asset_type.localize()
            self.setSelectedSortingDataForAssetType()
        case .tokenType:
            self.titleLbl.text = Constants.string.token_type.localize()
            self.setSelectedSortingDataForTokenType()
        default:
            self.titleLbl.text = Constants.string.category.localize()
            self.setSelectedSortingDataForCategory()
        }
        self.tableViewSetup()
        self.setUpTapGesture()
    }
    
    private func tableViewSetup(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: ProductSortTableCell.self)
    }
    
    private func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backgroundView.addGestureRecognizer(tap)
    }
    
    private func setSelectedSortingData(){
        if let index =  self.sortArray.firstIndex(where: { (sortTuple) -> Bool in
            return  sortTuple.0 == sortTypeApplied
        }){
            self.sortArray[index].1 =  true
        }
    }
    
    private func setSelectedSortingDataForCategory(){
        if let index =  self.sortDataArray.firstIndex(where: { (sortData) -> Bool in
            return  sortData.id == sortTypeAppliedCategory.id
        }){
            self.sortDataArray[index].isSelected =  true
        }
    }
    
    private func setSelectedSortingDataForAssetType(){
        if let index =  self.sortTypeAssetListing.firstIndex(where: { (sortData) -> Bool in
            return  sortData.id == sortTypeAppliedAsset.id
        }){
            self.sortTypeAssetListing[index].isSelected =  true
        }
    }
    
    private func setSelectedSortingDataForTokenType(){
        if let index =  self.sortTypeTokenListing.firstIndex(where: { (sortData) -> Bool in
            return  sortData.id == sortTypeAppliedToken.id
        }){
            self.sortTypeTokenListing[index].isSelected =  true
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
         self.popOrDismiss(animation: true)
    }
}

// MARK: - Extension For TableView
//===========================
extension ProductSortVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch usingForSort {
        case .filter:
            return sortArray.endIndex
        case .assetType:
            return sortTypeAssetListing.endIndex
        case .tokenType:
            return sortTypeTokenListing.endIndex
        default:
            return sortDataArray.endIndex
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ProductSortTableCell.self, indexPath: indexPath)
        switch usingForSort {
        case .filter:
            cell.sortTitleLbl.text = self.sortArray[indexPath.row].0
            cell.sortBtn.setImage(self.sortArray[indexPath.row].1 ? #imageLiteral(resourceName: "icRadioSelected") : #imageLiteral(resourceName: "icRadioUnselected"), for: .normal)
        case .assetType:
            cell.sortTitleLbl.text = self.sortTypeAssetListing[indexPath.row].name
            cell.sortBtn.setImage(self.sortTypeAssetListing[indexPath.row].isSelected ? #imageLiteral(resourceName: "icRadioSelected") : #imageLiteral(resourceName: "icRadioUnselected"), for: .normal)
        case .tokenType:
            cell.sortTitleLbl.text = self.sortTypeTokenListing[indexPath.row].name
            cell.sortBtn.setImage(self.sortTypeTokenListing[indexPath.row].isSelected ? #imageLiteral(resourceName: "icRadioSelected") : #imageLiteral(resourceName: "icRadioUnselected"), for: .normal)
        default:
            cell.sortTitleLbl.text = self.sortDataArray[indexPath.row].category_name
            cell.sortBtn.setImage(self.sortDataArray[indexPath.row].isSelected ? #imageLiteral(resourceName: "icRadioSelected") : #imageLiteral(resourceName: "icRadioUnselected"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return   47.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch usingForSort {
        case .filter:
            if let indexx = self.sortArray.firstIndex(where: { (sortTuple) -> Bool in
                return sortTuple.1
            }){
                self.sortArray[indexx].1 = false
                self.sortArray[indexPath.row].1 = true
                self.delegate?.sortingApplied(sortType: self.sortArray[indexPath.row].0)
            } else {
                self.sortArray[indexPath.row].1 = true
                self.delegate?.sortingApplied(sortType: self.sortArray[indexPath.row].0)
            }
            self.mainTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.popOrDismiss(animation: true)
            }
        case .assetType:
            if let indexx = self.sortTypeAssetListing.firstIndex(where: { (sortTuple) -> Bool in
                return sortTuple.isSelected
            }){
                self.sortTypeAssetListing[indexx].isSelected = false
                self.sortTypeAssetListing[indexPath.row].isSelected = true
                self.delegate?.sortingAppliedInAssetType(sortType: self.sortTypeAssetListing[indexPath.row])
            } else {
                self.sortTypeAssetListing[indexPath.row].isSelected = true
                self.delegate?.sortingAppliedInAssetType(sortType: self.sortTypeAssetListing[indexPath.row])
            }
            self.mainTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.popOrDismiss(animation: true)
            }
        case .tokenType:
            if let indexx = self.sortTypeTokenListing.firstIndex(where: { (sortTuple) -> Bool in
                return sortTuple.isSelected
            }){
                self.sortTypeTokenListing[indexx].isSelected = false
                self.sortTypeTokenListing[indexPath.row].isSelected = true
                self.delegate?.sortingAppliedInTokenType(sortType: self.sortTypeTokenListing[indexPath.row])
            } else {
                self.sortTypeTokenListing[indexPath.row].isSelected = true
                self.delegate?.sortingAppliedInTokenType(sortType: self.sortTypeTokenListing[indexPath.row])
            }
            self.mainTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.popOrDismiss(animation: true)
            }
        default:
            if let indexx = self.sortDataArray.firstIndex(where: { (sortData) -> Bool in
                return sortData.isSelected
            }){
                self.sortDataArray[indexx].isSelected = false
                self.sortDataArray[indexPath.row].isSelected = true
                self.delegate?.sortingAppliedInCategory(sortType: self.sortDataArray[indexPath.row])
            } else {
                self.sortDataArray[indexPath.row].isSelected = true
                self.delegate?.sortingAppliedInCategory(sortType: self.sortDataArray[indexPath.row])
            }
            self.mainTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.popOrDismiss(animation: true)
            }
        }
    }
}

