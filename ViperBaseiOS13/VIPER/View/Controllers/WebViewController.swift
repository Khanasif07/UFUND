//
//  WebViewController.swift
//  Project
//
//  Created by Deepika on 28/11/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var containerview: UIView!
    var webView: WKWebView!
  
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var bgViw: UIView!
    @IBOutlet weak var titleBar: UILabel!
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    var successInfo : SuccessDict?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        titleBar.text = ""
    
     

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
  
     }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
          
           loadValueToSet()
           
       }
    
    func loadValueToSet() {
        // Adding webView content
               let preferences = WKPreferences()
                      preferences.javaScriptEnabled = true
                      let configuration = WKWebViewConfiguration()
                      configuration.preferences = preferences
        webView = WKWebView(frame: CGRect(x: containerview.frame.minX, y: containerview.frame.minY, width: view.frame.width, height: view.frame.height - 160), configuration: configuration)

                   self.containerview.addSubview(webView!)

                      if let path = Bundle.main.path(forResource: "coin_payment", ofType: "html") {
                        let htmlURL = URL(fileURLWithPath: path)
                            webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)

                          let merchant_id = successInfo?.merchant
                        let amount = String(successInfo?.amount  ?? 0.0)
                        let vsl = nullStringToEmpty(string: htmlURL.absoluteString) + "?merchant=" + nullStringToEmpty(string: merchant_id) + "&item_name=" + nullStringToEmpty(string: self.successInfo?.item_name) + "&currency=" + nullStringToEmpty(string: self.successInfo?.currency)  + "&amount=" + nullStringToEmpty(string: amount)
                         + "&base_url=" + nullStringToEmpty(string: baseUrl)


                                  print("**ApendedURL",vsl)

                                      let testVal = URL(string: vsl)
                                      guard let url = testVal else {
                                          print("No file at url")
                                          return
                                      }

                                      webView?.loadFileURL(url, allowingReadAccessTo: url)
                                      print("**FinalURL",url)

                                      webView?.navigationDelegate = self
                       webView.isUserInteractionEnabled = true
                                      webView?.scrollView.isScrollEnabled = true
                      } else {
                         print("File not found")
                      }




    }
}

//MARK: Charting
extension WebViewController: WKScriptMessageHandler, WKNavigationDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("*** From JS:")
        if(message.name == "callbackHandler") {
            print("*** From JS:  \(message.body)")
        
            
        }
    }
    
  

    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
         print("loaded")
        
     
        if let text = webView.url?.absoluteString {
                 print(">>>>text",text)
            
            if text.contains("success") {
                showToast(string: "Payment Success")
                self.navigationController?.popViewController(animated: true)
            } else if text.contains("failure") {
                 print(">>>>Dismiss View",text)
                  showToast(string: "Payment Failed")
                 self.navigationController?.popViewController(animated: true)
           
            } else if text.contains("feedback") ||  text.contains("mail") || text.contains("register") {
                 self.navigationController?.popViewController(animated: true)
            }
          
        }
    
    }
   
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
    {
            if navigationAction.request.url != nil
            {
                //do what you need with url
//                self.delegate?.openURL(url: navigationAction.request.url!)
                
                
                  print("*********** request *********",navigationAction.request.url)
                
                if let text = navigationAction.request.url?.absoluteString {
                         print(">>>>text",text)
                    
                    if text.contains("success") {
                        showToast(string: "Payment Success")
                        self.navigationController?.popViewController(animated: true)
                    } else if text.contains("failure") {
                         print(">>>>Dismiss View",text)
                          showToast(string: "Payment Failed")
                         self.navigationController?.popViewController(animated: true)
                   
                    } else if text.contains("feedback") ||  text.contains("mail") || text.contains("register") {
                         self.navigationController?.popViewController(animated: true)
                    }
                  
                }
            }
        decisionHandler(.allow)
    }
    
}

  

//MARK:- Show Custom Toast
extension WebViewController {
    
    private func showToast(string : String?) {
        ToastManager.show(title: nullStringToEmpty(string: string), state: .error)
        
      //  self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
}
