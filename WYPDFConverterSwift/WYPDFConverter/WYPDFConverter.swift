//
//  WYPDFConverter.swift
//  WYPDFConverterSwift
//
//  Created by Apple on 2017/6/21.
//  Copyright © 2017年 杨新威. All rights reserved.
//

import UIKit

class WYPDFConverter: NSObject {
    
   class func convertPDFWithImages(images : Array<UIImage>,fileName : String) -> Bool {
        return true
    }
    
   class func converterPDFWithWebView(_ webView : UIWebView, fileName : String) -> Bool {
        let pdfPath = self.saveDirectory(fileName : fileName)
        print("/******************文件类型****************/\n"+pdfPath+"\n/************************************/");
        
        let pdfData = self.convert2PDFData(webView: webView)
        
        let result = pdfData.write(toFile: self.saveDirectory(fileName: fileName), atomically: true)
        
        return result
    }
    
    fileprivate class func convert2PDFData(webView : UIWebView) ->NSData {
        
        
        let format = webView.viewPrintFormatter()
        let render = UIPrintPageRenderer.init()
        
        render.addPrintFormatter(format, startingAtPageAt: 0)
        
        let pageRect = CGRect.init(x: 0, y: 0, width: 600, height: 768)
        let printableRect = pageRect.insetBy(dx: 50, dy: 50)
        
        
        
        render.setValue(NSValue.init(cgRect: pageRect), forKey: "paperRect")
        render.setValue(NSValue.init(cgRect: printableRect), forKey: "printableRect")
        
        let pdfData = NSMutableData.init()
        
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        
        for i in 0..<render.numberOfPages{
            UIGraphicsBeginPDFPage()
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return pdfData
    }

    
   class func saveDirectory(fileName:String) -> String {
       
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .cachesDirectory, in: .userDomainMask);
        let url = urlForDocument[0]
        return url.path + "/" + fileName
    }
}
