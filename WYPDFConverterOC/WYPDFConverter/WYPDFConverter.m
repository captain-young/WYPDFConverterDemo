//
//  WYPDFConverter.m
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import "WYPDFConverter.h"
#import "UIWebView+WYFile.h"

@implementation WYPDFConverter
+ (BOOL)convertPDFWithImages:(NSArray<UIImage *>*)images fileName:(NSString *)fileName{
    
    if (!images || images.count == 0) return NO;
    
    // pdf文件存储路径
    NSString *pdfPath = [self saveDirectory:fileName];
    NSLog(@"/****************文件路径*******************/\n\n%@\n\n",pdfPath);
    NSLog(@"/*****************************************/");
    //    CGFloat pdfFileWidth = [UIScreen mainScreen].bounds.size.width;
    //    __block CGFloat pdfFileHeight = 0;
    //
    //    // 计算图片拼接的长度
    //    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        // 获取每张图片的长宽
    //        CGFloat imageW = CGImageGetWidth(obj.CGImage);
    //        CGFloat imageH = CGImageGetHeight(obj.CGImage);
    //
    //        // 计算每张图片按屏宽比得到实际高度
    //        CGFloat h = imageH * pdfFileWidth / imageW;
    //
    //        pdfFileHeight += h;
    //
    //    }];
    
    BOOL result = UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, NULL);
    
    __block CGRect pdfBounds = UIGraphicsGetPDFContextBounds();
    NSLog(@"%@",NSStringFromCGRect(pdfBounds));
    //    __block CGFloat imageHeight = 0;
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIGraphicsBeginPDFPage();
        
        // 获取每张图片的实际长宽
        CGFloat imageW = obj.size.width;
        CGFloat imageH = obj.size.height;
        
        if (imageW <= pdfBounds.size.width && imageH <= pdfBounds.size.height) {
            
            [obj drawInRect:CGRectMake((pdfBounds.size.width - imageW) * 0.5, (pdfBounds.size.height - imageH) * 0.5, imageW, imageH)];
        }
        
        else if (imageW > pdfBounds.size.width && imageH < pdfBounds.size.height) {
            
            CGFloat w = pdfBounds.size.width - 20;
            CGFloat h = w * imageH / imageW;
            
            [obj drawInRect:CGRectMake((pdfBounds.size.width - w) * 0.5, (pdfBounds.size.height - h) * 0.5, w, h)];
            
        }
        
        else if (imageH > pdfBounds.size.height && imageW < pdfBounds.size.width ) {
            
            CGFloat h = pdfBounds.size.height - 20;
            CGFloat w = h * imageW / imageH;
            
            [obj drawInRect:CGRectMake((pdfBounds.size.width - w) * 0.5, (pdfBounds.size.height - h) * 0.5, w, h)];
            
        }
        
        else if (imageW > pdfBounds.size.width && imageH > pdfBounds.size.height) {
            
            if (imageW/imageH > pdfBounds.size.width / pdfBounds.size.height) {
                CGFloat w = pdfBounds.size.width - 20;
                CGFloat h = w * imageH / imageW;
                
                [obj drawInRect:CGRectMake((pdfBounds.size.width - w) * 0.5, (pdfBounds.size.height - h) * 0.5, w, h)];
            }else
            {
                CGFloat h = pdfBounds.size.height - 20;
                CGFloat w = h * imageW / imageH;
                
                [obj drawInRect:CGRectMake((pdfBounds.size.width - w) * 0.5, (pdfBounds.size.height - h) * 0.5, w, h)];
                
                
            }
            
        }
        
    }];
    
    UIGraphicsEndPDFContext();
    
    return result;
}

+ (BOOL)convertPDFWithWebView:(UIWebView *)webView fileName:(NSString *)fileName{
    
    NSString *pdfPath = [self saveDirectory:fileName];
    NSLog(@"/****************文件路径*******************/\n\n%@\n\n",pdfPath);
    NSLog(@"/*****************************************/");

    NSData *pdfData = [webView convert2PDFData];
    BOOL result = [pdfData writeToFile:pdfPath atomically:YES];
    
    return result;
}


/**
 文件保存路径
 */
+ (NSString *)saveDirectory:(NSString *)fileName{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
}

@end
