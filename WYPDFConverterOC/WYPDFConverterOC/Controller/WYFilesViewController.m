//
//  WYFilesViewController.m
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/29.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import "WYFilesViewController.h"
#import "WYWebViewController.h"

@interface WYFilesViewController ()

@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) NSArray *type;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WYFilesViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self getData];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

}

- (void)getData{
    _files = @[@"抵押贷款",@"大话Swift 3.0（上）",@"华为推荐书目",@"Xcode快捷键",@"Page",@"iOS",@"H5,JS资源",@"excel操作大全",@"虎扑篮球"];
    _type = @[@"numbers",@"key",@"xls",@"rtf",@"pages",@"ppt",@"txt",@"doc",@"webarchive"];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@.%@",_files[indexPath.row],_type[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYWebViewController *webVc = [[WYWebViewController alloc] init];
    webVc.filePath = [[NSBundle mainBundle] pathForResource:_files[indexPath.row] ofType:_type[indexPath.row]];
    webVc.fileName = _files[indexPath.row];
    [self.navigationController pushViewController:webVc animated:YES];
}




@end
