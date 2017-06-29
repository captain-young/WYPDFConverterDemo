//
//  ViewController.m
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import "ViewController.h"
#import "WYImageViewController.h"
#import <QuickLook/QuickLook.h>
#import "WYPDFConverter.h"
@interface ViewController ()<QLPreviewControllerDataSource>

@property (nonatomic, strong) QLPreviewController *qlVc;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *kinds;

@property (strong, nonatomic) NSMutableArray *filesArr; 

@end

static NSString *const cellID = @"cellID";

@implementation ViewController

- (NSMutableArray *)filesArr{
    if (!_filesArr) {
        _filesArr = [NSMutableArray array];
    }return _filesArr;
}

- (QLPreviewController *)qlVc{
    if (!_qlVc) {
        _qlVc = [[QLPreviewController alloc] init];
        _qlVc.dataSource = self;
    }return _qlVc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getData];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)getData{
    
    [self.filesArr removeAllObjects];
   
    _kinds = @[@"图片转PDF",@"各种格式文档转PDF(webView2PDF、image)",@"格式转换后的文件"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *file ; // 文件名

    NSDirectoryEnumerator *enumer = [fm enumeratorAtPath:[WYPDFConverter pdfSaveFolder]];
    
    while (file = [enumer nextObject]) {
        // 添加PDF和图片文件
        if ([file.pathExtension isEqualToString:@"pdf"] || [file.pathExtension isEqualToString:@"png"]) {
            [self.filesArr addObject:file];
        }
    }
    
}

#pragma mark -- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _kinds.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_kinds[indexPath.section]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 三种不同页面跳转的方法
    if (indexPath.section == 0){
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        WYImageViewController *imageVc = [sb instantiateViewControllerWithIdentifier:@"imageVC"];
        [self.navigationController pushViewController:imageVc animated:YES];
        
    }else if(indexPath.section == 1){
       
        [self performSegueWithIdentifier:@"FileVCSegue" sender:self];
        
    }else if (indexPath.section == 2){
        // 更新数据
        [self getData];
        [self.qlVc reloadData];
        [self.navigationController pushViewController:self.qlVc animated:YES];
    }
}

#pragma mark QLPreviewControllerDataSource
//返回文件的个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return self.filesArr.count;
}

//加载需要显示的文件
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    NSString *filePath = [WYPDFConverter saveDirectory:self.filesArr[index]];
    
    return [NSURL fileURLWithPath:filePath];
}

@end
