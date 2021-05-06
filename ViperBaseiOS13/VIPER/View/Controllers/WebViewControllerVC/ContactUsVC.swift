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
    }
    
    func getContactUs() {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.contact_Us.rawValue, params: nil, methodType: .GET, modelClass: ContactUsModelEntity.self, token: false)
    }
    
    private func setupTextAndFont(){
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
