//
//  WYWebViewController.swift
//  WYPDFConverterSwift
//
//  Created by 杨新威 on 2017/6/20.
//  Copyright © 2017年 杨新威. All rights reserved.
//

import UIKit

class WYWebViewController: UIViewController ,UIDocumentInteractionControllerDelegate,UIWebViewDelegate{

    var webView : UIWebView!
    var filePath : String!
    var fileName : String!
    var docVc : UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = fileName
        
        let url = URL.init(fileURLWithPath: filePath)
        let request = URLRequest.init(url: url)
        
        webView = UIWebView.init(frame: self.view.frame)
        webView.scalesPageToFit = true
        webView.delegate = self
        webView.loadRequest(request as URLRequest)
        self.view.addSubview(webView)
        
        docVc = UIDocumentInteractionController.init()
        docVc.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "PDF转换", style: .plain, target: self, action: #selector(webView2PDF))
    }
    
    func webView2PDF() {
        
        let result = WYPDFConverter.converterPDFWithWebView(webView,fileName: fileName + ".pdf")
    
        if result {
            print("convert success")
            
            docVc.url = NSURL.fileURL(withPath: fileName + ".pdf")
            docVc.presentPreview(animated: true)
        }
        
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webView.stringByEvaluatingJavaScript(from: "document.body.innerText='fail load'")
    }
    
   
}
