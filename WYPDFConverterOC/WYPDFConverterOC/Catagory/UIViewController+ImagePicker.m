//
//  UIViewController+ImagePicker.m
//  JunYouLawer
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 White-Young. All rights reserved.
//

#import "UIViewController+ImagePicker.h"
#import "objc/runtime.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

static  BOOL canEdit = NO;
static  char blockKey;

@interface UIViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,copy)imageBlock imageBlock;

@end

@implementation UIViewController (ImagePicker)



#pragma mark-set
- (void)setImageBlock:(imageBlock)imageBlock
{
    objc_setAssociatedObject(self, &blockKey, imageBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark-get
- (imageBlock )imageBlock
{
    return objc_getAssociatedObject(self, &blockKey);
}

- (void)showCanEdit:(BOOL)edit image:(imageBlock)block
{
    if (edit) {
        canEdit = edit;
    }
    
    //跳转到相册页面
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = canEdit;
    
    self.imageBlock = [block copy];
        //相册
    imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image;
    //是否要裁剪
    if ([picker allowsEditing]){
        
        //编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
    } else {
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(self.imageBlock)
    {
        self.imageBlock(image);
    }
}

@end
