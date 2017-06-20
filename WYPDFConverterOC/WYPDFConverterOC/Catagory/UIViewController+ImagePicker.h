//
//  UIViewController+ImagePicker.h
//  JunYouLawer
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 White-Young. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^imageBlock)(UIImage *image);

@interface UIViewController (ImagePicker)

/**
 *  照片选择
 *
 *  @param edit  照片是否需要编辑
 *  @param block 照片回调
 */
- (void)showCanEdit:(BOOL)edit image:(imageBlock)block;

@end
