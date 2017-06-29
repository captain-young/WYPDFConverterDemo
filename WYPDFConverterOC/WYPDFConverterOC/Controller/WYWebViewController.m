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
@property (strong, nonatomic) UIActivityIndicatorView *indictorView;
@property (strong, nonatomic) UIButton *imageConverterBtn;

@end

@implementation WYWebViewController

#pragma mark -- lazy loading UI
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WY_SCREEN_WIDTH, WY_SCREEN_HEIGHT - 50)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
    }return _webView;
}

- (UIActivityIndicatorView *)indictorView{
    if (!_indictorView) {
        _indictorView = [[UIActivityIndicatorView alloc] init];
        _indictorView.center = self.view.center;
        _indictorView.bounds = CGRectMake(0, 0, 50, 50);
        _indictorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_indictorView];
    }return _indictorView;
}

- (UIButton *)imageConverterBtn{
    if (!_imageConverterBtn) {
        _imageConverterBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, CGRectGetMaxY(self.webView.frame) + 10, WY_SCREEN_WIDTH - 40 , 30);
            [button setTitle:@"Image转换" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:button];
            button;
        });
    }return _imageConverterBtn;
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
    
    [self.indictorView startAnimating];

    
    [self.imageConverterBtn addTarget:self action:@selector(convert2Image) forControlEvents:UIControlEventTouchUpInside];

    
    
}


/**
 转换成图片
 */
- (void)convert2Image{
    self.indictorView.hidden = NO;
    [self.indictorView startAnimating];
    
    UIImage *image = [self.webView convert2Image];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imagePath = [WYPDFConverter saveDirectory:[NSString stringWithFormat:@"%@_IMG.png",self.fileName]];
    BOOL result = [imageData writeToFile:imagePath atomically:YES];
   
    if (result) {
        self.docVC.URL = [NSURL fileURLWithPath:imagePath];
        [self.docVC presentPreviewAnimated:YES];
        
        [self.indictorView stopAnimating];
    }
}

/**
 转换成PDF格式文件
 */
- (void)convertPDFAction{
    
    self.indictorView.hidden = NO;
    [self.indictorView startAnimating];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",_fileName];
    BOOL result = [WYPDFConverter convertPDFWithWebView:self.webView fileName:fileName];
    
    if (result) {
        
        NSLog(@"convert success");
        
        self.docVC.URL = [NSURL fileURLWithPath:[WYPDFConverter saveDirectory:fileName]];
        [self.docVC presentPreviewAnimated:YES];
        [self.indictorView stopAnimating];

    }
}

#pragma mark - UIDocumentInteractionControllerDelegate Methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.indictorView stopAnimating];
}

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText='fail load'"];
//}




@end
