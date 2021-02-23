
//
//  Presenter.swift
//  Swift_Base
//

import Foundation
import ObjectMapper
import Alamofire

class Presenter {
    var view: PresenterOutputProtocol?
    var interactor: PresenterToInterectorProtocol?
    var router: PresenterToRouterProtocol?
}

extension Presenter: PresenterInputProtocol {
    func UploadData<T>(api: String, params: [String : Any], imageData: [String : (Data, String,String)]?, methodType: HttpType, modelClass: T.Type, token: Bool) where T : Mappable {
        interactor?.UploadData(api: api, params: params, imageData: imageData, methodType: methodType, modelClass: modelClass, token: token)
    }
    
    
    
  
    func IMAGEWITHPDFUPLOAD<T>(api: String, params: [String : Any], pdfData: [String : Data], methodType: HttpType, imgData: [String : Data]?, imgName: String, modelClass: T.Type, token: Bool) where T : Mappable {
        
        interactor?.IMAGEWITHPDFUPLOADDATA(api: api, params: params, methodType: methodType, imgData: imgData, pdfData: pdfData, imgName: imgName, modelClass: modelClass, token: token)
        
    }
    
  
    func HITAPI<T: Mappable>(api: String, params: Parameters?, methodType: HttpType, modelClass: T.Type, token: Bool){
        interactor?.FetchingData(api: api, params: params, methodType: methodType, modelClass: modelClass, token: token)
    }
    func IMAGEPOST<T: Mappable>(api: String, params: [String : Any], methodType: HttpType, imgData: [String : Data]?, imgName: String, modelClass: T.Type, token: Bool) {
        interactor?.IMAGEPOSTfetchData(api: api, params: params, methodType: methodType, imgData: imgData, imgName: imgName, modelClass: modelClass, token: token)
    }
}

extension Presenter: InterectorToPresenterProtocol{
    func dataError(error: CustomError) {
        view?.showError(error: error)
    }
    func dataSuccess(api : String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        view?.showSuccess(api: api, dataArray: dataArray, dataDict: dataDict, modelClass: modelClass)
    }
    
    private func dataSucessWithParams(params:[String:Any],api : String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        view?.showSuccessWithParams(params: params,api: api, dataArray: dataArray, dataDict: dataDict, modelClass: modelClass)
    }
    
  
}



