//
//  CategoryListingVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoryListingVC: UIViewController {
    // MARK: - IB Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    var isSearchOn: Bool  =  false
    var categoryType: CategoryType = .Products
    var searchedCategoryListing = [CategoryModel]()
    var selectedCategoryListing : [CategoryModel] = ProductFilterVM.shared.selectedCategoryListing
    var categoryListing: [CategoryModel]? = ProductFilterVM.shared.categoryListing
    var searchText: String? {
           didSet{
               if let searchedText = searchText{
                   if searchedText.isEmpty{
                       self.tableView.reloadData()
                   } else {
                    self.searchedCategoryListing = categoryListing?.filter({(($0.category_name?.lowercased().contains(s: searchedText.lowercased()))!)}) ?? []
                       self.tableView.reloadData()
                   }
               }
           }
       }
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doIntitialSetup()
        addFooterView()
        registerXib()
    }
    
    // MARK: - Helper methods
    
    private func doIntitialSetup() {
        searchBar.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        getCategoryList()
    }
    
    private func addFooterView() {
          let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
          customView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
          tableView.tableFooterView = customView
      }
    
    private func registerXib() {
        tableView.registerCell(with: CategoryListTableCell.self)
    }
    
    private func getCategoryList(){
        if categoryListing?.endIndex == 0 {
            self.loader.isHidden = false
            if categoryType == .Products {
                self.presenter?.HITAPI(api: Base.categories.rawValue, params: [ProductCreate.keys.category_type: 1], methodType: .GET, modelClass: CategoriesModel.self, token: true)
            } else {
                self.presenter?.HITAPI(api: Base.categories.rawValue, params: [ProductCreate.keys.category_type: 2], methodType: .GET, modelClass: CategoriesModel.self, token: true)
            }
        }
    }
    
    func removeSelectedPower(model : CategoryModel) {
        if self.selectedCategoryListing.count != 0 {
            for power in self.selectedCategoryListing.enumerated() {
                if power.element.id == model.id {
                    self.selectedCategoryListing.remove(at: power.offset)
                    ProductFilterVM.shared.selectedCategoryListing.remove(at: power.offset)
                    break
                }
            }
        }
    }
    
    func setSelectedPowers(model : CategoryModel) {
        if self.categoryListing?.count != 0 {
            self.selectedCategoryListing.append(model)
             ProductFilterVM.shared.selectedCategoryListing.append(model)
        } else {
            self.selectedCategoryListing = [model]
            ProductFilterVM.shared.selectedCategoryListing = [model]
        }
    }
}

// MARK: - UITableViewDataSource and Delegate methods

extension CategoryListingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if isSearchOn { return self.searchedCategoryListing.count }
         else { return categoryListing?.count ?? 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
        cell.category = isSearchOn ? self.searchedCategoryListing[indexPath.row] : categoryListing?[indexPath.row] ?? CategoryModel()
        let isPowerSelected = self.selectedCategoryListing.contains(where: {$0.id == (isSearchOn ? self.searchedCategoryListing[indexPath.row].id : categoryListing?[indexPath.row].id)})
        cell.statusButton.isSelected = isPowerSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedCategoryListing.contains(where: {$0.id == (isSearchOn ? self.searchedCategoryListing[indexPath.row].id : categoryListing?[indexPath.row].id)}){
            if isSearchOn ? self.searchedCategoryListing[indexPath.row].id == 0 : categoryListing?[indexPath.row].id == 0  {
                self.selectedCategoryListing = []
                ProductFilterVM.shared.selectedCategoryListing = []
                self.selectedCategoryListing = []
            } else {
                self.removeSelectedPower(model: isSearchOn ? self.searchedCategoryListing[indexPath.row] : categoryListing?[indexPath.row] ?? CategoryModel())
                if ProductFilterVM.shared.selectedCategoryListing.endIndex == (categoryListing?.endIndex ?? 0) - 1 && ProductFilterVM.shared.selectedCategoryListing.contains(where: {$0.id == 0}){
                    ProductFilterVM.shared.selectedCategoryListing.remove(at: ProductFilterVM.shared.selectedCategoryListing.firstIndex(where: {$0.id == 0}) ?? 0)
                    self.selectedCategoryListing.remove(at: ProductFilterVM.shared.selectedCategoryListing.firstIndex(where: {$0.id == 0}) ?? 0)
                } else{}
            }
        } else {
            if isSearchOn ? self.searchedCategoryListing[indexPath.row].id == 0 : categoryListing?[indexPath.row].id == 0   {
                ProductFilterVM.shared.selectedCategoryListing = categoryListing ?? []
                self.selectedCategoryListing = categoryListing ?? []
            } else {
                if ProductFilterVM.shared.selectedCategoryListing.endIndex == (categoryListing?.endIndex ?? 0) - 2{
                    ProductFilterVM.shared.selectedCategoryListing = categoryListing ?? []
                    self.selectedCategoryListing = categoryListing ?? []
                } else{
                    ProductFilterVM.shared.selectedCategoryListing.append(isSearchOn ? self.searchedCategoryListing[indexPath.row] : categoryListing?[indexPath.row] ?? CategoryModel())
                    self.selectedCategoryListing.append(isSearchOn ? self.searchedCategoryListing[indexPath.row] : categoryListing?[indexPath.row] ?? CategoryModel())
                }
            }
        }
        self.tableView.reloadData()
    }
}


//MARK:- UISearchBarDelegate
//========================================
extension CategoryListingVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isSearchOn = !searchText.isEmpty
        self.searchText = searchText
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
            self.isSearchOn = true
        }else{
            self.isSearchOn = false
        }
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
            self.isSearchOn = true
        }else{
            self.isSearchOn = false
        }
        searchBar.resignFirstResponder()
    }
}

extension CategoryListingVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        if let addionalModel = dataDict as? CategoriesModel{
            var category = CategoryModel()
            category.id = 0
            category.category_name = "All"
            categoryListing = addionalModel.data
            categoryListing?.insert(category, at: 0)
            ProductFilterVM.shared.categoryListing = categoryListing ?? []
        }
        self.tableView.reloadData()
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
        
    }
 
}

