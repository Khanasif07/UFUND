import Foundation
import UIKit

let mainPresenter : PresenterInputProtocol & InterectorToPresenterProtocol = Presenter()
let mainInteractor : PresenterToInterectorProtocol & WebServiceToInteractor = Interactor()
let mainRouter : PresenterToRouterProtocol = Router()
let mainWebservice : WebServiceProtocol = Webservice()

var presenterObject :PresenterInputProtocol?

class Router: PresenterToRouterProtocol{
    
    static let main = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    
    static func createModule() -> UIViewController {
        
        let view = main.instantiateViewController(withIdentifier: Storyboard.Ids.TutorialViewController) as?  TutorialViewController
        view?.presenter = mainPresenter
        mainPresenter.view = view
        mainPresenter.interactor = mainInteractor
        mainPresenter.router = mainRouter
        mainInteractor.presenter = mainPresenter
        mainInteractor.webService = mainWebservice
        mainWebservice.interactor = mainInteractor
        presenterObject = view?.presenter
       
        if retrieveUserData() {
            
            switch User.main.trulioo_kyc_status ?? 0 {
            case 0:
                let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                return vc
            case 1:
                let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                return vc
            default:
                return  main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
            }
//            let digitalId = UserDefaults.standard.value(forKey: "digitalId")  as? Int
            
//            if  User.main.kyc == 0 {
//
//
//
//                let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
//
//                return vc
//
//
//
//            } else {
            
//            if User.main.kyc == 0{
//                let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.UserProfileVC) as! UserProfileVC
//                vc.isKYCIncomplete = true
//                return vc
//                return  main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
//            }else {
//                return main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
//            }
                
//                if  User.main.pin_status == 1  || digitalId == 1 {
//
//
//                    let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.OtpController) as! OtpController
//                     vc.changePINStr = "changePINStr"
//                    return vc
//
//
//
//                } else {
//
//                    return main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
//                }
                
                           
       // }
           
            
        } else {
            
            let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.TutorialViewController) as! TutorialViewController
            return vc

            
            
        }
        
    }
    
}












