//
//  AWSS3Manager.swift
//  ViperBaseiOS13
//
//  Created by Admin on 02/06/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import UIKit
import AWSS3
import AVFoundation

typealias progressBlock = (_ progress: Double) -> Void //2
typealias completionBlock = (_ response: String?, _ error: Error?) -> Void //3

class AWSS3Manager {
    
    static let shared = AWSS3Manager() // 4
    private init () { }
    let bucketName = AppConstants.AWS_BUCKET //5
    
    
    //MARK: Setting S3 server with the credentials...
    //MARK: =========================================
    func setupAmazonS3(withPoolID poolID: String) {
        
        let credentialsProvider = AWSCognitoCredentialsProvider( regionType: .USEast1,
                                                                 identityPoolId: poolID)
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    // Upload image using UIImage object
    func uploadImage(image: UIImage, progress: progressBlock?, completion: completionBlock?) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return
        }
        
        let tmpPath = NSTemporaryDirectory() as String
        let width = image.size.width
        let height = image.size.height
        let name = "\(width)\(Int(Date().timeIntervalSince1970))_\(height).jpeg"
        
        let filePath = tmpPath + "/" + name
        let fileUrl = URL(fileURLWithPath: filePath)
        
        do {
            try imageData.write(to: fileUrl)
            self.uploadfile(fileUrl: fileUrl, fileName: name, contenType: "image", progress: progress, completion: completion)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
        }
    }
    
    
    // Upload video from local path url
    func uploadVideo(videoUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: videoUrl)
        let name = "\(Int(Date().timeIntervalSince1970)).mov"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)

        let path = NSTemporaryDirectory() + name

        self.convertVideo(toMPEG4FormatForVideo: videoUrl, outputURL: outputurl) { (session) in

            let data = NSData(contentsOf: outputurl as URL)
            do {
                try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
            } catch {
                print(error)
            }
            self.uploadfile(fileUrl: videoUrl, fileName: fileName, contenType: "video", progress: progress, completion: completion)
        }
    }
    
    // Upload auido from local path url
    func uploadAudio(audioUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: audioUrl)
        self.uploadfile(fileUrl: audioUrl, fileName: fileName, contenType: "audio", progress: progress, completion: completion)
    }
    
    // Upload files like Text, Zip, etc from local path url
    func uploadOtherFile(fileUrl: URL, conentType: String, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: fileUrl)
        self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: conentType, progress: progress, completion: completion)
    }
    
    // Get unique file name
    func getUniqueFileName(fileUrl: URL) -> String {
        let fileExtension = (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension).lowercased()
        var strExt: String = ""
        strExt += "." + fileExtension
        return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
    }
    
    //MARK:- AWS file upload
    
    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            print(awsProgress.fractionCompleted)
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(fileName)
                    print("Uploaded to:\(String(describing: publicURL))")
                    completion?(publicURL?.absoluteString, nil)
                } else {
                    completion?(nil, error)
                }
            })
        }
        
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("error is: \(error.localizedDescription)")
            }
            if let _ = task.result {
                // your uploadTask
            }
            return nil
        }
    }
    
    // MARK :- Cancel All uploads
    func cancelAllUploads() {
        AWSS3TransferUtility.default().enumerateToAssignBlocks(forUploadTask: { (uploadTask, progress, error) in
            uploadTask.cancel()
        }, downloadTask: nil)
    }
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler : @escaping (_ session : AVAssetExportSession) -> Void){
        
        do {
            try FileManager.default.removeItem(at: outputURL as URL)
        }
        catch {
            print(error)
        }
        let asset = AVURLAsset(url: inputURL as URL, options: nil)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        
        exportSession?.outputURL = outputURL as URL
        
        exportSession?.outputFileType = AVFileType.mov
        exportSession?.exportAsynchronously(completionHandler: {
            handler(exportSession!)
        })
    }
}
extension UIImage {
    
    func upload(progress: progressBlock?, completion: completionBlock?) {
        AWSS3Manager.shared.uploadImage(image: self, progress: progress, completion: completion)
    }
    
    func uploadAudioFile(audioUrl: URL,progress: progressBlock?, completion: completionBlock?) {
        AWSS3Manager.shared.uploadAudio(audioUrl: audioUrl, progress: progress, completion: completion)
    }
}

