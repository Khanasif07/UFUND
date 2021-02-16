//
//  CategoryListingVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class CategoryListingVC: UIViewController {
    // MARK: - IB Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    var isSearchOn: Bool  =  false
    var searchedCategoryListing = [Categories]()
    var selectedCategoryListing : [Categories] = []
    var categoryListing: [Categories]?
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
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doIntitialSetup()
        registerXib()
    }
    
    // MARK: - Helper methods
    
    private func doIntitialSetup() {
        searchBar.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerXib() {
        tableView.registerCell(with: CategoryListTableCell.self)
    }
    
    func removeSelectedPower(model : Categories) {
        if self.selectedCategoryListing.count != 0 {
            for power in self.selectedCategoryListing.enumerated() {
                if power.element.id == model.id {
                    self.selectedCategoryListing.remove(at: power.offset)
                    break
                }
            }
        }
    }
    
    func setSelectedPowers(model : Categories) {
        if self.categoryListing?.count != 0 {
            self.selectedCategoryListing.append(model)
        } else {
            self.selectedCategoryListing = [model]
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
        cell.category = isSearchOn ? self.searchedCategoryListing[indexPath.row] : categoryListing?[indexPath.row] ?? Categories()
        let isPowerSelected = self.selectedCategoryListing.contains(where: {$0.id == (isSearchOn ? self.searchedCategoryListing[indexPath.row].id : categoryListing?[indexPath.row].id)})
        cell.statusButton.isSelected = isPowerSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedCategoryListing.contains(where: {$0.id == (isSearchOn ? self.searchedCategoryListing[indexPath.row].id : categoryListing?[indexPath.row].id)}){
            self.removeSelectedPower(model: isSearchOn ? self.searchedCategoryListing[indexPath.row] : categoryListing?[indexPath.row] ?? Categories())
        } else {
            self.setSelectedPowers(model: isSearchOn ? self.searchedCategoryListing[indexPath.row] : categoryListing?[indexPath.row] ?? Categories())
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
