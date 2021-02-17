//
//  CurrencyVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
class CurrencyVC: UIViewController {
    // MARK: - IB Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    // MARK: - Variables
    var isSearchOn: Bool  =  false
    var searchedCurrencyListing = [CurrencyModel]()
    var selectedCurrencyListing : [CurrencyModel] = ProductFilterVM.shared.selectedCurrencyListing
    var currencyListing: [CurrencyModel]? = ProductFilterVM.shared.currencyListing
    var searchText: String? {
           didSet{
               if let searchedText = searchText{
                   if searchedText.isEmpty{
                       self.tableView.reloadData()
                   } else {
                    self.searchedCurrencyListing = currencyListing?.filter({(($0.currency?.lowercased().contains(s: searchedText.lowercased()))!)}) ?? []
                       self.tableView.reloadData()
                   }
               }
           }
       }
//    let currencyListing: [Currency] = Currency.allCases
    
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
    
    func removeSelectedPower(model : CurrencyModel) {
        if self.selectedCurrencyListing.count != 0 {
            for power in self.selectedCurrencyListing.enumerated() {
                if power.element.id == model.id {
                    self.selectedCurrencyListing.remove(at: power.offset)
                    ProductFilterVM.shared.selectedCurrencyListing.remove(at: power.offset)
                    break
                }
            }
        }
    }
    
    func setSelectedPowers(model : CurrencyModel) {
        if self.currencyListing?.count != 0 {
            self.selectedCurrencyListing.append(model)
            ProductFilterVM.shared.selectedCurrencyListing.append(model)
        } else {
            self.selectedCurrencyListing = [model]
            ProductFilterVM.shared.selectedCurrencyListing =  [model]
        }
    }
}

// MARK: - UITableViewDataSource and Delegate methods

extension CurrencyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if isSearchOn { return self.searchedCurrencyListing.count }
                else { return currencyListing?.count ?? 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
        //        cell.currency = currencyListing[indexPath.row]
        //        cell.statusButton.isSelected = ProductFilterVM.shared.currency.contains(currencyListing[indexPath.row].rawValue)
        cell.currency = isSearchOn ? self.searchedCurrencyListing[indexPath.row] : currencyListing?[indexPath.row] ?? CurrencyModel()
        let isPowerSelected = self.selectedCurrencyListing.contains(where: {$0.id == (isSearchOn ? self.searchedCurrencyListing[indexPath.row].id : currencyListing?[indexPath.row].id)})
        cell.statusButton.isSelected = isPowerSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if ProductFilterVM.shared.currency.contains(currencyListing[indexPath.row].rawValue) {
        //            ProductFilterVM.shared.currency.remove(at: ProductFilterVM.shared.currency.firstIndex(of: currencyListing[indexPath.row].rawValue)!)
        //        } else {
        //            ProductFilterVM.shared.currency.append(currencyListing[indexPath.row].rawValue)
        //        }
        if self.selectedCurrencyListing.contains(where: {$0.id == (isSearchOn ? self.searchedCurrencyListing[indexPath.row].id : currencyListing?[indexPath.row].id)}){
            self.removeSelectedPower(model: isSearchOn ? self.searchedCurrencyListing[indexPath.row] : currencyListing?[indexPath.row] ?? CurrencyModel())
        } else {
            self.setSelectedPowers(model: isSearchOn ? self.searchedCurrencyListing[indexPath.row] : currencyListing?[indexPath.row] ?? CurrencyModel())
        }
        self.tableView.reloadData()
    }
}

//MARK:- UISearchBarDelegate
//========================================
extension CurrencyVC: UISearchBarDelegate{
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
