//
//  ViewController.m
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import "ViewController.h"
#import "WYWebViewController.h"
#import "WYImageViewController.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) NSArray *type;

@end

static NSString *const cellID = @"cellID";

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getData];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)getData{
    
    _files = @[@"多张图片转PDF",@"抵押贷款",@"大话Swift 3.0（上）",@"华为推荐书目",@"Xcode快捷键",@"Page",@"iOS",@"H5,JS资源",@"excel操作大全"];
    _type = @[@"image",@"numbers",@"key",@"xls",@"rtf",@"pages",@"ppt",@"txt",@"doc"];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@.%@",_files[indexPath.row],_type[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        WYImageViewController *imageVc = [sb instantiateViewControllerWithIdentifier:@"imageVC"];
        [self.navigationController pushViewController:imageVc animated:YES];
        
    }else{
        WYWebViewController *webVc = [[WYWebViewController alloc] init];
        webVc.filePath = [[NSBundle mainBundle] pathForResource:_files[indexPath.row] ofType:_type[indexPath.row]];
        webVc.fileName = _files[indexPath.row];
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

@end
