//
//  Interactor.swift
//  Swift_Base
//

import Foundation
import ObjectMapper
import Alamofire

class Interactor {
    var presenter: InterectorToPresenterProtocol?
    var webService: WebServiceProtocol?
    
}

extension Interactor : PresenterToInterectorProtocol {
    func UploadData<T>(api: String, params: [String : Any], imageData: [String:(Data,String,String)]?, methodType: HttpType, modelClass: T.Type, token: Bool) where T : Mappable {
        webService?.retrieveWithData(api: api, params: params, imageData: imageData, type: methodType, modelClass: modelClass, token: true, completion: nil)

    }
    
   
    
    func IMAGEWITHPDFUPLOADDATA<T>(api: String, params: [String : Any], methodType: HttpType, imgData: [String : Data]?, pdfData: [String : Data], imgName: String, modelClass: T.Type, token: Bool) where T : Mappable {
        
       webService?.retrieve(api: api, params: params, imageData: imgData, pdfData: pdfData, type:methodType , modelClass: modelClass, token: token, completion: nil)
        
    }
    
    func IMAGEPOSTfetchData<T>(api: String, params: [String : Any], methodType: HttpType, imgData: [String : Data]?, imgName: String, modelClass: T.Type, token: Bool) where T : Mappable {
        webService?.retrieve(api: api, params: params, imageData: imgData, pdfData: nil, type:methodType , modelClass: modelClass, token: token, completion: nil)
    }
    
    func FetchingData<T: Mappable>(api: String, params: Parameters?, methodType: HttpType, modelClass: T.Type, token: Bool) {
        webService?.retrieve(api: api, params: params, imageData: nil, pdfData: nil, type:methodType , modelClass: modelClass, token: token, completion: nil)
    }
    
    
    
    
    
    
    
//    func IMAGEPOSTfetchData<T: Mappable>(api: String, params: [String : Any],methodType: HttpType, imgData: [String : Data]?, imgName: String, modelClass: T.Type, token: Bool) {
//        webService?.retrieve(api: api, params: params, imageData: imgData, type:methodType , modelClass: modelClass, token: token, completion: nil)
//    }
    
}


extension Interactor : WebServiceToInteractor {
    func responseError(error: CustomError) {
        self.presenter?.dataError(error: error)
    }
    func responseSuccess<T: Mappable>(api : String, className:T.Type, responseDict:[String: Any], responseArray: [[String: Any]]){
        if(responseDict.isEmpty){  //Array
            let details = Mapper<T>().mapArray(JSONArray: responseArray)
            /* self.presenter?.DataFetchedArray(data: details, modelClass: className)*/
            self.presenter?.dataSuccess(api: api, dataArray: details, dataDict: nil, modelClass: className)
        }else{ //Dictionary:
            let details = Mapper<T>().map(JSONObject: responseDict)
            /* self.presenter?.DataFetchedArray(data: details, modelClass: className)*/
            self.presenter?.dataSuccess(api: api,dataArray: nil, dataDict: details, modelClass: className)
        }
        
    }
    
    func responseSuccessWithParams<T: Mappable>(statusCode: Int,params: [String:Any],api : String, className:T.Type, responseDict:[String: Any], responseArray: [[String: Any]]){
        if(responseDict.isEmpty){  //Array
            let details = Mapper<T>().mapArray(JSONArray: responseArray)
            /* self.presenter?.DataFetchedArray(data: details, modelClass: className)*/
            self.presenter?.dataSuccessWithParams(statusCode: statusCode, params: params,api: api, dataArray: details, dataDict: nil, modelClass: className)
        }else{ //Dictionary:
            let details = Mapper<T>().map(JSONObject: responseDict)
            /* self.presenter?.DataFetchedArray(data: details, modelClass: className)*/
            self.presenter?.dataSuccessWithParams(statusCode: statusCode, params: params,api: api,dataArray: nil, dataDict: details, modelClass: className)
        }
        
    }
    /***************/
    /*  func dictModelClass(className:Any,response:[String: Any]){
     print("CLASS NAME---\(className)")
     switch String(describing: className) {
     case "LoginModel":
     /* let details = Mapper<LoginModel>().map(JSONObject: response)
     self.presenter?.DataFetched(data: details!,modelClass: className) */
     break
     default:
     print("default")
     break
     }
     }
     /***************/
     func arrayModelClass(className:Any,arrayResponse:[[String: Any]]){
     print("CLASS NAME---\(className)")
     switch String(describing: className) {
     case "SampleGetEntity":
     let details = Mapper<SampleGetEntity>().mapArray(JSONArray: arrayResponse)
     self.presenter?.DataFetchedArray(data: details, modelClass: className)
     break
     default:
     print("default")
     break
     }
     }*/
    /***************/
    
    
}



