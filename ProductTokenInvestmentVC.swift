//
//  ProductTokenInvestmentVC.swift
//  
//
//  Created by Admin on 26/04/21.
//

import UIKit

class ProductTokenInvestmentVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var bottomBtnView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var productBtn: UIButton!
    @IBOutlet weak var tokenBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension ProductTokenInvestmentVC {
    
    private func initialSetup() {
        
    }
}

// MARK: - Extension For TableView
//===========================
extension ProductTokenInvestmentVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
