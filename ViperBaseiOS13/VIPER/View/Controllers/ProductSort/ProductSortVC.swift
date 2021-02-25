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
    @IBOutlet weak var tableViewHConst: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var dataContainerView: UIView!
    
    // MARK: - Variables
    //===========================
    var sortTypeApplied: String  = ""
    weak var delegate :ProductSortVCDelegate?
    var sortArray = [(Constants.string.sort_by_latest,false),(Constants.string.sort_by_oldest,false),(Constants.string.sort_by_name_AZ,false),(Constants.string.sort_by_name_ZA,false)]
    
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
        tableViewHConst.constant = mainTableView.frame.height + 15.0
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
        self.setSelectedSortingData()
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: ProductSortTableCell.self)
    }
    
    private func setSelectedSortingData(){
        if let index =  self.sortArray.firstIndex(where: { (sortTuple) -> Bool in
            return  sortTuple.0 == sortTypeApplied
        }){
            self.sortArray[index].1 =  true
        }
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
        return   47.0
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.popOrDismiss(animation: true)
        }
    }
}

