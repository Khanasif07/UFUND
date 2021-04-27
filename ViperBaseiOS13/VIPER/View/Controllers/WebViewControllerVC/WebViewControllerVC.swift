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
        case privacyPolicy
        case termsCondition
        var text :String {
            switch self {
            case .privacyPolicy:
                return Constants.string.privacy_policy.localized
            case .termsCondition:
                return Constants.string.terms_conditions.localized
            }
        }
        
        var url : String {
            switch self {
            case .privacyPolicy:
                return "privacy-policy"
            case .termsCondition:
                return "terms-and-conditions"
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
        setupView()
        loadUrl()
        titleLbl.text = webViewType.text
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.setZoomScale(1.0, animated: false)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
         scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
