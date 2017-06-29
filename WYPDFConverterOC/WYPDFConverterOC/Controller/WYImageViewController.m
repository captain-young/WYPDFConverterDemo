//
//  WYImageViewController.m
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import "WYImageViewController.h"
#import "WYImageCollectionViewCell.h"
#import "WYPDFConverter.h"
#import "UIViewController+ImagePicker.h"
@interface WYImageViewController ()<UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *selectImages;
@property (strong, nonatomic) UIDocumentInteractionController *docVC;

@end

@implementation WYImageViewController
#pragma mark -- lazy loading UI
- (NSMutableArray *)selectImages{
    if (!_selectImages) {
        _selectImages = [NSMutableArray array];
    }return _selectImages;
}

- (UIDocumentInteractionController *)docVC{
    if (!_docVC) {
        _docVC = [[UIDocumentInteractionController alloc] init];
        _docVC.delegate = self;
    }return _docVC;
}

#pragma mark --

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    // 默认添加九张不同大小的图片
    for (NSInteger i = 0; i < 9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%zd.jpg",i]];
        [self.selectImages addObject:image];
    }
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectImages.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    cell.imageView.image = (indexPath.row == self.selectImages.count) ? [UIImage imageNamed:@"contract_add"] : self.selectImages[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.selectImages.count) {
        // 从相册选择图片
        [self showCanEdit:NO image:^(UIImage *image) {
            [self.selectImages addObject:image];
            [collectionView reloadData];
        }];
        
    }else{
        // 点击删除图片
        [self.selectImages removeObjectAtIndex:indexPath.row];
        [collectionView reloadData];
    }
}



- (IBAction)image2PDF:(UIButton *)sender {
    
    if (self.selectImages.count == 0) return;
    
    // 将当前时间戳作为文件名
    NSString *fileName = [NSString stringWithFormat:@"IMG_%.0f.pdf",[[NSDate date] timeIntervalSince1970]];
    BOOL result = [WYPDFConverter convertPDFWithImages:self.selectImages fileName:fileName];
    
    if (result) {
        NSLog(@"convert success");
        
        self.docVC.URL = [NSURL fileURLWithPath:[WYPDFConverter saveDirectory:fileName]];
        [self.docVC presentPreviewAnimated:YES];
    }

}

#pragma mark - UIDocumentInteractionControllerDelegate Methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

@end
