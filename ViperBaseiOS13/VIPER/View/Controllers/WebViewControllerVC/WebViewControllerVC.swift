//
//  WebViewControllerVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 27/04/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import WebKit

class WebViewControllerVC: UIViewController {
    
    enum WebViewType {
        case deposit
        case privacyPolicy
        case termsCondition
        var text :String {
            switch self {
            case .privacyPolicy:
                return Constants.string.privacy_policy.localized
            case .termsCondition:
                return Constants.string.terms_conditions.localized
            case .deposit:
                return Constants.string.deposit.localized
            }
        }
        
        var url : String {
            switch self {
            case .privacyPolicy:
                return "privacy-policy"
            case .termsCondition:
                return "terms-and-conditions"
            case .deposit:
                return ""
            }
        }
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Variables
    //===========================
    var webViewType : WebViewType = .privacyPolicy
    private var isInjected: Bool = false
    var depositUrl = ""
    var amount = ""
    var webView : WKWebView!
    var request : URLRequest!
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    // MARK: - Functions
    //===========================
    private func initialSetup() {
        if webViewType == .deposit{
            setupViewForDeposit()
            loadUrlForDeposit()}
        else{
            setupView()
            loadUrl()}
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        titleLbl.text = webViewType.text
    }
    
    
    private func setupViewForDeposit() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: webConfig)
        webView.backgroundColor = .white
        containerView.addSubview(webView)
    }
    
    private func setupView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: webConfig)
        webView.scrollView.delegate = self
        webView.configuration.preferences.javaScriptEnabled = true
        webView.uiDelegate = self
        webView.backgroundColor = .white
        containerView.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func loadUrl() {
        guard let url = URL(string: baseUrl + "/" +  webViewType.url) else {return}
        request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func loadUrlForDeposit(){
        guard let url = URL(string: self.depositUrl) else {return}
        request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "amount=\(amount)"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: .utf8)
        webView.load(request) //if your `webView` is `UIWebView`
    }
    
}

extension WebViewControllerVC : WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate {
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
             scrollView.pinchGestureRecognizer?.isEnabled = false
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString{
            if url.contains(s: "payment-successapi"){
                NotificationCenter.default.post(name: Notification.Name.PaymentSucessfullyDone, object: nil)
                self.popOrDismiss(animation: true)
            }
        }
        print(webView.url?.absoluteString)
        if isInjected == true {
            return
        }
        self.isInjected = true
        // get HTML text
        let js = "document.body.outerHTML"
        webView.evaluateJavaScript(js) { (html, error) in
            let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
            webView.loadHTMLString(headerString + (html as! String), baseURL: nil)
        }
    }


    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.setZoomScale(1.0, animated: false)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
         scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

