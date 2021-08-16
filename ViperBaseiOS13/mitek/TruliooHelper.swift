//
//  TruliooHelper.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/08/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import UIKit

enum APIError: Error{
    case DataError(String)
    case ServerError(String)
    case JSONError(String)
    case UnknownError(String)
}

let maxImageSize = 15 * 1024 * 1024

public class TruliooHelper{
    
    

//Username: tinjapay_docv_production_api
//Password : UfundApp@2021!

    private let username = "tinjapay_docv_production_api"
    private let password = "UfundApp@2021!"
    
    // GG25 path
//    private let basePath = "https://api.globalgateway.io/"
    // GG20 path
    private let basePath = "https://api.globaldatacompany.com/"

    private let testAuthenticationPath = "connection/v1/testauthentication"
    private let verificationPath = "verifications/v1/verify"
    private let configurationCountryPath = "configuration/v1/countrycodes/Identity Verification"
    private let configurationDocTypePath = "configuration/v1/documentTypes/"
    
    func getCountryList(onSuccess:@escaping(Data, Int, HTTPURLResponse?) -> Void, onFailure:@escaping(Error, Int, URLResponse?) -> Void){
        let urlRequest = getUrlRequest(url: basePath+configurationCountryPath, isPost: false)
        if(urlRequest == nil){
            onFailure(APIError.UnknownError("Unable to read the url"), -1, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
            if let error = error{
                if let response = response as? HTTPURLResponse{
                    onFailure(error, response.statusCode, response)
                    return
                }
                onFailure(error, -1, response)
                return
            }
            if let response = response as? HTTPURLResponse{
                if(response.statusCode != 200){
                    if let errorData = data, let errorString = String(data:errorData, encoding: .utf8){
                        onFailure(APIError.ServerError(errorString),response.statusCode, response)
                    }
                    else{
                        onFailure(APIError.ServerError("Unknown server error, check response for detail"),response.statusCode, response)
                    }
                }
                else{
                    if let data = data{
                        onSuccess(data,response.statusCode, response)
                    }
                    else{
                        onFailure(APIError.ServerError("Unknown server error, check response for detail"),response.statusCode, response)
                    }
                }
            }
            else{
                onFailure(APIError.ServerError("Unknown server error, check response for detail"), -1, response)
            }
        }
        task.resume()

    }
    
    func getDocTypeList(countryCode:String, onSuccess:@escaping(Data, Int, HTTPURLResponse?) -> Void, onFailure:@escaping(Error, Int, URLResponse?) -> Void){
        let urlRequest = getUrlRequest(url: basePath+configurationDocTypePath+countryCode, isPost: false)
        if(urlRequest == nil){
            onFailure(APIError.UnknownError("Unable to read the url"), -1, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
            if let error = error{
                if let response = response as? HTTPURLResponse{
                    onFailure(error, response.statusCode, response)
                    return
                }
                onFailure(error, -1, response)
                return
            }
            if let response = response as? HTTPURLResponse{
                if(response.statusCode != 200){
                    if let errorData = data, let errorString = String(data:errorData, encoding: .utf8){
                        onFailure(APIError.ServerError(errorString),response.statusCode, response)
                    }
                    else{
                        onFailure(APIError.ServerError("Unknown server error, check response for detail"),response.statusCode, response)
                    }
                }
                else{
                    if let data = data{
                        onSuccess(data,response.statusCode, response)
                    }
                    else{
                        onFailure(APIError.ServerError("Unknown server error, check response for detail"),response.statusCode, response)
                    }
                }
            }
            else{
                onFailure(APIError.ServerError("Unknown server error, check response for detail"), -1, response)
            }
        }
        task.resume()
    }
    
    func testAuthentication(onSuccess:@escaping(Data, Int, HTTPURLResponse?) -> Void, onFailure:@escaping(Error, Int, URLResponse?) -> Void){
        
        let urlRequest = getUrlRequest(url: basePath+testAuthenticationPath, isPost: false)
        if(urlRequest == nil){
            onFailure(APIError.UnknownError("Unable to read the url"), -1, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
            if let error = error{
                if let response = response as? HTTPURLResponse{
                    onFailure(error, response.statusCode, response)
                    return
                }
                onFailure(error, -1, response)
                return
            }
            if let response = response as? HTTPURLResponse{
                if(response.statusCode != 200){
                    if let errorData = data, let errorString = String(data:errorData, encoding: .utf8){
                        onFailure(APIError.ServerError(errorString),response.statusCode, response)
                    }
                    else{
                        onFailure(APIError.ServerError("Unknown server error, check response for detail"),response.statusCode, response)
                    }
                }
                else{
                    if let data = data{
                        onSuccess(data,response.statusCode, response)
                    }
                    else{
                        onFailure(APIError.ServerError("Unknown server error, check response for detail"),response.statusCode, response)
                    }
                }
            }
            else{
                onFailure(APIError.ServerError("Unknown server error, check response for detail"), -1, response)
            }
        }
        task.resume()
    }
    
    
    func verify(piiInfo: PiiInfo, onSuccess:@escaping(Data, Int, HTTPURLResponse?) -> Void, onFailure:@escaping(Error, Int, URLResponse?) -> Void){
        
        var urlRequest = getUrlRequest(url: basePath+verificationPath, isPost: true)
        if(urlRequest == nil){
            onFailure(APIError.UnknownError("Unable to read the url"), -1, nil)
            return
        }
        
        urlRequest!.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let request = getVerifyRequest(piiInfo: piiInfo)
        do{
            let jsongString = try JSONEncoder().encode(request)
            urlRequest!.httpBody = jsongString
        }catch{
            onFailure(APIError.JSONError("Unable to create JSON request"),-1, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
            if let error = error{
                if let response = response as? HTTPURLResponse{
                    onFailure(error, response.statusCode, response)
                    return
                }
                onFailure(error, -1, response)
                return
            }
            if let response = response as? HTTPURLResponse{
                if(response.statusCode != 200){
                    if let errorData = data, let errorString = String(data:errorData, encoding: .utf8){
                        onFailure(APIError.ServerError(errorString),response.statusCode, response)
                    }
                    else{
                        onFailure(APIError.ServerError("Unknown server error, check response for detail"),response.statusCode, response)
                    }
                }
                else{
                    if let data = data{
                        onSuccess(data,response.statusCode, response)
                    }else{
                        onFailure(APIError.ServerError("Unknown data error, check response for detail"),response.statusCode, response)
                    }
                }
            }
            else{
                onFailure(APIError.ServerError("Unknown server error, check response for detail"), -1, response)
            }
        }
        task.resume()
    }
    
    private func getUrlRequest(url:String, isPost:Bool) -> URLRequest?{
        guard let url = URL(string: url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? url)
        else {
                return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(getloginString(), forHTTPHeaderField: "Authorization")
        if(isPost){
            urlRequest.httpMethod = "POST"
        }
        return urlRequest
    }
    
    private func getloginString() -> String{
        let tokenString = username + ":" + password
        let tokenData = tokenString.data(using: .utf8)!
        let base64TokenString = tokenData.base64EncodedString()
        return "Basic \(base64TokenString)"
    }
    
    private func getVerifyRequest(piiInfo: PiiInfo) -> DocumentVerificationRequest{
        let frontImageString = convertAndCompressImageToBase64(image: piiInfo.frontImage, metaData: piiInfo.frontMetaData)
        let backImageString = convertAndCompressImageToBase64(image: piiInfo.backImage, metaData: piiInfo.backMetaData)
        let liveImageString = convertAndCompressImageToBase64(image: piiInfo.liveImage, metaData: piiInfo.liveMetaData)
        
        let dataFields = DataFields(personInfo: PersonInfo(piiInfo: piiInfo), documentInfo: Document(frontImage: frontImageString!, backImage: backImageString, livePhoto: liveImageString, documentType: piiInfo.documentType))
        return DocumentVerificationRequest(countryCode: piiInfo.countryCode, dataFields: dataFields)
    }
    
    private func convertAndCompressImageToBase64(image:UIImage?, metaData:String?) -> String?{
        
        if (image == nil) {
            return nil
        }
        
        var quality:CGFloat = 1.0
        
        if (metaData == nil || metaData!.isEmpty)
        {
            var imageData = image!.jpegData(compressionQuality: quality)
            while(imageData!.count > maxImageSize && quality > 0){
                quality -= 0.1
                imageData = image!.jpegData(compressionQuality: quality)
            }
            return imageData?.base64EncodedString()
        }
        
        let newImage = createImageWithMetaData(image!, metaData: metaData)
        var imageData = getJpegData(newImage, compressionQuality: quality)
        
        while(imageData!.count > maxImageSize && quality > 0){
            quality -= 0.1
            imageData = getJpegData(newImage, compressionQuality: quality)
        }
        return imageData?.base64EncodedString()
    }
    
    private func createImageWithMetaData(_ originalImage:UIImage, metaData: String?) -> CIImage {
           
        let imageData = originalImage.jpegData(compressionQuality: 1.0)!
        let sourceImageData = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let sourceImageProperties = CGImageSourceCopyPropertiesAtIndex(sourceImageData, 0, nil)! as NSDictionary
        let mutable: NSMutableDictionary = sourceImageProperties.mutableCopy() as! NSMutableDictionary
        let tiffData: NSMutableDictionary = (mutable[kCGImagePropertyTIFFDictionary as String] as? NSMutableDictionary)!

        print("Original image properties: \(sourceImageProperties)")

        // tag it to tiff Software
        tiffData[kCGImagePropertyTIFFSoftware as String] = metaData

        // save original image data with updated exif data
        let typeIdentifier = CGImageSourceGetType(sourceImageData)!
        let imageDataWithExif: NSMutableData = NSMutableData(data: imageData)
        let destinationImage: CGImageDestination = CGImageDestinationCreateWithData((imageDataWithExif as CFMutableData), typeIdentifier, 1, nil)!
        
        CGImageDestinationAddImageFromSource(destinationImage, sourceImageData, 0, (mutable as CFDictionary))
        CGImageDestinationFinalize(destinationImage)

        let newImage: CIImage = CIImage(data: imageDataWithExif as Data, options: nil)!
        let newImageProperties: NSDictionary = newImage.properties as NSDictionary
              
        print("New image properties: \(newImageProperties)")
        
        return newImage
    }
    
    private func getJpegData(_ image: CIImage, compressionQuality: CGFloat) -> Data? {
        let context = CIContext()
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
        return context.jpegRepresentation(of: image, colorSpace: colorSpace!, options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption : compressionQuality])
    }
}
