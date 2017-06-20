//
//  WYWebViewController.swift
//  WYPDFConverterSwift
//
//  Created by 杨新威 on 2017/6/20.
//  Copyright © 2017年 杨新威. All rights reserved.
//

import UIKit

class WYWebViewController: UIViewController {

    var webView : UIWebView!
    var filePath : String!
    var fileName : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = fileName
        
        let url = URL.init(fileURLWithPath: filePath)
        let request = URLRequest.init(url: url)
        
        webView = UIWebView.init(frame: self.view.frame)
        webView.scalesPageToFit = true
        webView.loadRequest(request as URLRequest)
        self.view.addSubview(webView)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "PDF转换", style: .plain, target: self, action: #selector(webView2PDF))
    }
    
    func webView2PDF() {
        
    }
    
    func convert2PDFData() ->Data {
        
        
        let format = webView.viewPrintFormatter()
        let render = UIPrintPageRenderer.init()
        
        render.addPrintFormatter(format, startingAtPageAt: 0)
        
        render.setValue(NSValue.init(cgRect: CGRect.zero), forKey: "paperRect")
        render.setValue(NSValue.init(cgRect: CGRect.zero), forKey: "printableRect")
        
        let pdfData = Data.init()
        
        UIGraphicsBeginPDFContextToData(pdfData as! NSMutableData, CGRect.zero, nil)
        
        for i in 0..<render.numberOfPages{
            UIGraphicsBeginPDFPage()
            render .drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return pdfData
    }

}
