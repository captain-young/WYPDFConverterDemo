//
//  WYPDFConverter.h
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIWebView+WYFile.h"

@interface WYPDFConverter : NSObject

/**
image to PDF

@param fileName 文件名
@param images 图片数组
*/
+ (BOOL)convertPDFWithImages:(NSArray<UIImage *>*)images fileName:(NSString *)fileName;


/**
 webView to PDF
 
 */
+ (BOOL)convertPDFWithWebView:(UIWebView *)webView fileName:(NSString *)fileName;


/**
 文件保存地址
 
 @param fileName 文件名
 */
+ (NSString *)saveDirectory:(NSString *)fileName;


@end
