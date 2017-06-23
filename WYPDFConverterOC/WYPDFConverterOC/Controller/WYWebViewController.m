//
//  WYWebViewController.m
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import "WYWebViewController.h"
#import "WYPDFConverter.h"

#define WY_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define WY_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height


@interface WYWebViewController ()<UIDocumentInteractionControllerDelegate,UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIDocumentInteractionController *docVC;

@end

@implementation WYWebViewController

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WY_SCREEN_WIDTH, WY_SCREEN_HEIGHT - 50)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
    }return _webView;
}

- (UIDocumentInteractionController *)docVC{
    if (!_docVC) {
        _docVC = [[UIDocumentInteractionController alloc] init];
        _docVC.delegate = self;
    }return _docVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    self.navigationItem.title = _fileName;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"PDF转换" style:UIBarButtonItemStylePlain target:self action:@selector(convertPDFAction)];

    NSURL *fileUrl = [NSURL fileURLWithPath:_filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [self.webView loadRequest:request];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, CGRectGetMaxY(self.webView.frame) + 10, WY_SCREEN_WIDTH - 40 , 30);
    [button setTitle:@"Image转换" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(convert2Image) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

- (void)convert2Image{
    
    UIImage *image = [self.webView convert2Image];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:@"temp.png"];
    BOOL result = [imageData writeToFile:imagePath atomically:YES];
    if (result) {
        self.docVC.URL = [NSURL fileURLWithPath:imagePath];
        [self.docVC presentPreviewAnimated:YES];
    }

//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
//- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
//    if (error || !image) {
//        NSLog(@"保存失败");
//    }else{
//        NSLog(@"保存成功");
//    }
//}


- (void)convertPDFAction{
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",_fileName];
    BOOL result = [WYPDFConverter convertPDFWithWebView:self.webView fileName:fileName];
    
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


#pragma mark - UIWebViewDelegate

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText='fail load'"];
//}




@end
