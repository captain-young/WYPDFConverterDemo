//
//  UIWebView+WYFile.h
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (WYFile)


/**
 webView转换为PDF数据
 */
- (NSData *)convert2PDFData;


/**
 转换成image图片
 */
- (UIImage *)convert2Image;

@end
