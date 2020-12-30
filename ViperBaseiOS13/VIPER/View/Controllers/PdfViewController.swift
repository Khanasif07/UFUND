//
//  PDFOPENER.swift
//  Project
//
//  Created by Deepika on 28/05/19.
//  Copyright © 2019 css. All rights reserved.
//




import UIKit
import PDFKit


class PdfViewController: UIViewController {
    
    let pdfView = PDFView()
    lazy var headerView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(hex: secondaryColor)
        return view
    }()
    
    lazy var backButton: UIButton = {
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "PDF Viewer"
        label.textColor = UIColor(hex: primaryColor)
        Common.setFont(to: label, isTitle: true, size: 20, fontType: .bold)
        return label
    }()
    
    var urlString: String = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        // Do any additional setup after loading the view.
        setNavigationBar()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
       
        
        pdfView.autoScales = false
        
        if let document = PDFDocument(url: URL(string: urlString)!) {
            pdfView.document = document
           
        }
    }
    
    
    func setNavigationBar() {
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(backButton)
        
        backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
    }
    
    @objc func goBack() {
        
        self.dismiss(animated: true, completion: nil)
    }
}
