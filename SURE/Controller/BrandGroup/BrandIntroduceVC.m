//
//  BrandIntroduceVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/4.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BrandIntroduceVC.h"

@interface BrandIntroduceVC ()

<UIWebViewDelegate>

{
    __weak IBOutlet UIImageView *_logoImageView;
    __weak IBOutlet UIWebView *_webView;
}

@end

@implementation BrandIntroduceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self customNavBarItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBarItem
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navBar_LeftButton"] style:UIBarButtonItemStyleDone target:self action:@selector(leftItemButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.navigationItem.title = _brandDataModel.brandNameStr;
    
    
    [_webView loadHTMLString:_brandDataModel.brandIntroduceString baseURL:[NSURL URLWithString:ImageUrl]];
    
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_brandDataModel.brandIntroduceLogoUrlString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)leftItemButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"shouldStartLoadWithRequest");
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [_webView stringByEvaluatingJavaScriptFromString:injectionJSString];
    
    
    //标签里的scale 值就是页面的初始化页面大小< initial-scale >和可伸缩放大最大< maximum-scale >和最小< minimum-scale >的的倍数。如果还有别的需求可自行设置,如果都为1表示初始化的时候显示为原来大小,可缩放的大小都为原来的大小<即不可缩放>。
    
    CGFloat scale = (ScreenWidth - 40) / webView.scrollView.contentSize.width;
    NSString *injectionJSString1 = [NSString stringWithFormat:@"var script = document.createElement('meta');"
                                    "script.name = 'viewport';"
                                    "script.content=\"width=device-width, initial-scale=%f,maximum-scale=%f, minimum-scale=%f, user-scalable=no\";"
                                    "document.getElementsByTagName('head')[0].appendChild(script);",scale,scale,scale];
    
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString1];
    
//    CGRect frame = _webView.frame;
//    frame.size.height =  webView.scrollView.contentSize.height;
//    webView.frame = frame;
    NSLog(@"webViewDidFinishLoad ========= %@",[NSValue valueWithCGSize:webView.scrollView.contentSize]);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}



@end
