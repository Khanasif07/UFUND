//
//  CategoriesVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var btnStackView: UIView!
    @IBOutlet weak var tokenBtn: UIButton!
    @IBOutlet weak var productBtn: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    // MARK: - Variables
    //===========================
    var tokenVC : CategoriesTokenVC!
    var productVC : CategoriesProductsVC!
    var isPruductSelected = true {
        didSet {
            if isPruductSelected {
                self.productBtn.setTitleColor(.white, for: .normal)
                self.tokenBtn.setTitleColor(.darkGray, for: .normal)
                self.productBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
                self.tokenBtn.setBackGroundColor(color: .clear)
            } else {
                self.productBtn.setTitleColor(.darkGray, for: .normal)
                self.tokenBtn.setTitleColor(.white, for: .normal)
                self.productBtn.setBackGroundColor(color: .clear)
                self.tokenBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
            }
        }
    }
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnStackView.setCornerRadius(cornerR: btnStackView.frame.height / 2.0)
        tokenBtn.setCornerRadius(cornerR: tokenBtn.frame.height / 2.0)
        productBtn.setCornerRadius(cornerR: productBtn.frame.height / 2.0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
       
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func productBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        isPruductSelected = true
        self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func tokenBtnTapped(_ sender: Any) {
        self.view.endEditing(true)
        isPruductSelected = false
        self.mainScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width,y: 0), animated: true)
        self.view.layoutIfNeeded()
    }
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func sortBtnAction(_ sender: UIButton) {
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension CategoriesVC : UIScrollViewDelegate{
    
    private func initialSetUp(){
        self.setUpFont()
        self.mainScrollView.delegate = self
        self.configureScrollView()
        self.instantiateViewController()
        self.isPruductSelected = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureScrollView(){
        self.mainScrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 1)
        self.mainScrollView.isPagingEnabled = true
    }
    
    private func instantiateViewController() {
        //instantiate the CategoriesTokenVC
        self.tokenVC = CategoriesTokenVC.instantiate(fromAppStoryboard: .Main)
        self.tokenVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.mainScrollView.frame = self.tokenVC.view.frame
        self.mainScrollView.addSubview(self.tokenVC.view)
        self.addChild(self.tokenVC)
        
        //instantiate the CategoriesProductsVC
        self.productVC = CategoriesProductsVC.instantiate(fromAppStoryboard: .Main)
        self.productVC.view.frame.origin = CGPoint.zero
        self.mainScrollView.frame = self.productVC.view.frame
        self.mainScrollView.addSubview(self.productVC.view)
        self.addChild(self.productVC)
    }
    
    private func setUpFont(){
        self.btnStackView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9176470588, blue: 0.9176470588, alpha: 0.7010701185)
        self.btnStackView.borderLineWidth = 1.5
        self.btnStackView.borderColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 0.1007089439)
    }
}
