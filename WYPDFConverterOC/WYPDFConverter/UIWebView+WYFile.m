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
    
//    返回视图的打印格式化
    UIViewPrintFormatter *format = [self viewPrintFormatter];
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:format startingAtPageAtIndex:0];
    
    // 设置PDF文件每页的尺寸
    CGRect pageRect =  CGRectMake(0, 0, 600, 768);
//    呈现每个页面的上下文的尺寸大小
    CGRect printableRect = CGRectInset(pageRect, 50, 50);
    
    [render setValue:[NSValue valueWithCGRect:pageRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    NSMutableData *pdfData = [NSMutableData data];
    //    文档信息 可设置为nil
    //    CFMutableDictionaryRef myDictionary = CFDictionaryCreateMutable(nil, 0,
    //                                             &kCFTypeDictionaryKeyCallBacks,
    //                                             &kCFTypeDictionaryValueCallBacks);
    
    //    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
    //    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
    
    UIGraphicsBeginPDFContextToData(pdfData, pageRect, NULL);
    
    for (NSInteger i = 0; i < [render numberOfPages]; i++) {
        
        UIGraphicsBeginPDFPage();
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        [render drawPageAtIndex:i inRect:bounds];
    }
    
    UIGraphicsEndPDFContext();
    
    return pdfData;
    
}

- (UIImage *)convert2Image{
    

    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, NO, scale);
    //保存现在的位置和尺寸
    CGPoint savedContentOffset = self.scrollView.contentOffset;
    CGRect savedFrame = self.frame;
    //设置尺寸和内容一样大
    self.scrollView.contentOffset = CGPointZero;
    self.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //恢复原来的位置和尺寸
    self.scrollView.contentOffset = savedContentOffset;
    self.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
