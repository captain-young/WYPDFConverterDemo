//
//  WYWebViewController.m
//  WYPDFConverterOC
//
//  Created by Apple on 2017/6/20.
//  Copyright © 2017年 White-Young. All rights reserved.
//

#import "WYWebViewController.h"
#import "WYPDFConverter.h"
@interface WYWebViewController ()<UIDocumentInteractionControllerDelegate,UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIDocumentInteractionController *docVC;

@end

@implementation WYWebViewController

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
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
    
    self.navigationItem.title = _fileName;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"PDF转换" style:UIBarButtonItemStylePlain target:self action:@selector(convertPDFAction)];

    
    NSURL *fileUrl = [NSURL fileURLWithPath:_filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [self.webView loadRequest:request];

    
}

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
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText='fail load'"];
}




@end
