//
//  UIWebView+WYFile.m
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import "UIWebView+WYFile.h"

@implementation UIWebView (WYFile)

- (NSData *)convert2PDFData{
    
    UIViewPrintFormatter *format = [self viewPrintFormatter];
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:format startingAtPageAtIndex:0];
    
    // 设置PDF文件每页的尺寸
    CGRect pageRect = ({
        CGRect rect =  CGRectMake(0, 0, 600, 768);
        rect;
    });
    
    CGRect printableRect = CGRectInset(pageRect, 50, 50);
    
    [render setValue:[NSValue valueWithCGRect:pageRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    NSMutableData *pdfData = [NSMutableData data];
    //    文档信息 可设置为NULL
    //    CFMutableDictionaryRef myDictionary = CFDictionaryCreateMutable(NULL, 0,
    //                                             &kCFTypeDictionaryKeyCallBacks,
    //                                             &kCFTypeDictionaryValueCallBacks);
    
    //    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
    //    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
    
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, NULL);
    
    for (NSInteger i = 0; i < [render numberOfPages]; i++) {
        
        UIGraphicsBeginPDFPage();
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        [render drawPageAtIndex:i inRect:bounds];
    }
    
    UIGraphicsEndPDFContext();
    
    return pdfData;
    
}


@end
