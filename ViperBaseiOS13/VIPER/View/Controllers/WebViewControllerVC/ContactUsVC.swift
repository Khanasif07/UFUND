//
//  ContactUsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 05/05/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit
import ObjectMapper

class ContactUsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contactUsLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var skypeLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Variable
    //==========================
    private lazy var loader  : UIView = {
             return createActivityIndicator(self.view)
         }()
    var descText : String = ""
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
}

// MARK: - Extension For Functions
//===========================
extension ContactUsVC {
    
    private func initialSetup() {
        self.setupTextAndFont()
        self.getContactUs()
        self.setUpTapGestureForPhone()
        self.setUpTapGestureForEmail()
    }
    
    func getContactUs() {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.contact_Us.rawValue, params: nil, methodType: .GET, modelClass: ContactUsModelEntity.self, token: false)
    }
    
    private func setupTextAndFont(){
        [contactUsLbl,skypeLbl,emailLbl,phoneLbl].forEach { (lbl) in
            lbl.font =  isDeviceIPad ? .setCustomFont(name: .regular, size: .x18) : .setCustomFont(name: .regular, size: .x14)
        }
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
    }
    
    private func setUpTapGestureForPhone() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.phoneTap(_:)))
        phoneLbl.isUserInteractionEnabled = true
        phoneLbl.addGestureRecognizer(tap)
    }
    
    private func setUpTapGestureForEmail() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.emailTap(_:)))
        emailLbl.isUserInteractionEnabled = true
        emailLbl.addGestureRecognizer(tap)
    }
    
    @objc func phoneTap(_ sender: UITapGestureRecognizer? = nil){
        var uc = URLComponents()
        uc.scheme = "tel"
        uc.path =  phoneLbl.text?.replacingOccurrences(of: " ", with: "%20") ?? ""
        if let phoneURL = uc.url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneURL)
            } else {
                UIApplication.shared.openURL(phoneURL)
            }
        }
    }
    
    @objc func emailTap(_ sender: UITapGestureRecognizer? = nil){
        let email = emailLbl.text ?? ""
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}


//MARK: - PresenterOutputProtocol

extension ContactUsVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any){
        switch api {
        case Base.contact_Us.rawValue:
            self.loader.isHidden = true
            let productModelEntity = dataDict as? ContactUsModelEntity
            if let productDict = productModelEntity?.data {
                self.emailLbl.text = productDict.first?.details ?? ""
                self.phoneLbl.text = productDict[1].details ?? ""
                self.skypeLbl.text = productDict.last?.details ?? ""
                self.contactUsLbl.text = productDict[2].details ?? ""
            }
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
