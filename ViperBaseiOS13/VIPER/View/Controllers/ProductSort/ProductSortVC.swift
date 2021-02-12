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
}

class ProductSortVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var dataContainerView: UIView!
    
    // MARK: - Variables
    //===========================
    weak var delegate :ProductSortVCDelegate?
    var sortArray = [("Sort by Latest",false),("Sort by Oldest",false),("Sort by Name (A-Z)",false),("Sort by Name (Z-A)",false)]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
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
        self.tableViewSetup()
        self.dataContainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15.0)
    }
    
    private func tableViewSetup(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: ProductSortTableCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension ProductSortVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortArray.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ProductSortTableCell.self, indexPath: indexPath)
        cell.sortTitleLbl.text = self.sortArray[indexPath.row].0
        cell.sortBtn.setImage(self.sortArray[indexPath.row].1 ? #imageLiteral(resourceName: "icRadioSelected") : #imageLiteral(resourceName: "icRadioUnselected"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return   (dataContainerView.frame.height  - 86.0 ) / 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.popOrDismiss(animation: true)
        }
    }
}

