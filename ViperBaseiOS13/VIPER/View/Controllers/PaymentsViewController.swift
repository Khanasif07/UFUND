//
//  PaymentsViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 26/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit

class PaymentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cashLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var AddCardPayment: UIButton!
    @IBOutlet weak var emptyCardView: UIView!
    @IBOutlet weak var noSavedCardLbl: UILabel!
    @IBOutlet weak var addCardLbl: UILabel!
    @IBOutlet weak var paymentCashView: UIView!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    var testArr = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //emptyCardView.isHidden = true
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        } 
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: XIB.Names.PaymentsListCell, bundle: nil), forCellReuseIdentifier: XIB.Names.PaymentsListCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        heightConstraint.constant = CGFloat(testArr.count * 80 + 80)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localize()
    }
}

//MARK: - Localization
extension PaymentsViewController {
    func localize() {
        cashLbl.text = Constants.string.cash.localize()
        cashLbl.textColor = UIColor(hex: darkTextColor)
        paymentCashView.applyEffectToView()
        paymentMethodLbl.textColor = UIColor(hex: cellContentColur)
        paymentMethodLbl.text = Constants.string.paymentMethods.localize()
        titleLbl.text = Constants.string.payment.localize().uppercased()
        titleLbl.textColor = UIColor(hex: darkTextColor)
        AddCardPayment.setTitleColor(UIColor(hex: placeHolderColor), for: .normal)
        AddCardPayment.setTitle(Constants.string.addCardsForYourPayment.localize(), for: .normal)
        addCardLbl.textColor = UIColor(hex: darkTextColor)
        noSavedCardLbl.textColor = UIColor(hex: lightTextColor)
        noSavedCardLbl.text = Constants.string.thereIsNoSavedCard.localize()
        addCardLbl.text = Constants.string.addCard.localize()
    }
}

//MARK: - Button Actions
extension PaymentsViewController {
    
    @IBAction func redirectToAddMoreCard(_ sender: UIButton) {
        
    }
    
    @IBAction func redirectToAddCard(_ sender: UIButton) {
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
    }
       
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension PaymentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArr.count
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        view.backgroundColor = .clear
        let titleLbl = UILabel()
        titleLbl.frame = CGRect(x: 0, y: 0, width: (80 * tableView.frame.width)/100, height: 50)
        titleLbl.text = nullStringToEmpty(string: Constants.string.yourCard.localize())
        titleLbl.textColor = UIColor(hex: cellContentColur)
        titleLbl.textAlignment = .left
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(titleLbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.PaymentsListCell, for: indexPath) as! PaymentsListCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.cardNumberLbl.text = "4242 4242 4242 XXXX"
        cell.imgView.image = #imageLiteral(resourceName: "visa")
        return  cell
    }
    
}
