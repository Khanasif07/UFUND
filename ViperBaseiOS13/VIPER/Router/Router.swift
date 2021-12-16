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
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCViewController) as? KYCViewController  else { return UIViewController() }
        return vc
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

            switch User.main.trulioo_kyc_status {
            case 0:
                let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                return vc
            case 1:
                return  main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
            default:
                let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                return vc
            }
        } else {

            let vc = main.instantiateViewController(withIdentifier: Storyboard.Ids.TutorialViewController) as! TutorialViewController
            return vc



        }
        
    }
    
}












