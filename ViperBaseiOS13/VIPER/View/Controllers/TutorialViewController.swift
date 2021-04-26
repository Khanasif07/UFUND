//
//  TutorialViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 19/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper


public  struct TutorialContent {
    
    var title: String?
    var description: String?
    
}

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var inverstorButton: UIButton!
    @IBOutlet weak var campaignerButton: UIButton!
    @IBOutlet weak var welcomeBack: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        withRenderingMode(originalImage: #imageLiteral(resourceName: "logo"), imgView: logoImg, imgTintColur: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        localize()
//               setFont()
        
//       welcomeBack.text = "Welcome to \n\nUFUND"
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        localize()
//        setFont()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    
}

//MARK: - Localization
extension TutorialViewController {
    
    func localize() {
        
        inverstorButton.setCornerRadius()
        campaignerButton.setCornerRadius()
        
        inverstorButton.backgroundColor = .white
        campaignerButton.backgroundColor = .white
        
        inverstorButton.setTitle(Constants.string.investor.localize().uppercased(), for: .normal)
        campaignerButton.setTitle(Constants.string.campaigner.localize().uppercased(), for: .normal)
        
        orLbl.text = nullStringToEmpty(string: Constants.string.or.localize())
    }
    
    func setFont() {
        orLbl.textColor = UIColor.white
        campaignerButton.setTitleColor(UIColor(hex: primaryColor), for: .normal)
        inverstorButton.setTitleColor(UIColor(hex: primaryColor), for: .normal)
    }
}

//MARK: - Button Actions
extension TutorialViewController {
    
    @IBAction func inverstorFlowSelected(_ sender: UIButton) {
        
        UserDefaults.standard.set(UserType.investor.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as? SignInViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func campaingerFlowSelected(_ sender: UIButton) {
        UserDefaults.standard.set(UserType.campaigner.rawValue, forKey: UserDefaultsKey.key.isFromInvestor)
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as? SignInViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - PresenterOutputProtocol

extension TutorialViewController: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        print("Called")
    }
    
    func showError(error: CustomError) {
        print(error)
    }
}

