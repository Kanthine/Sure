//
//  SingleProductDetaileCollectionCell.m
//  SURE
//
//  Created by 王玉龙 on 17/1/11.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "SingleProductDetaileCollectionCell.h"
#import <Masonry.h>
#import <WebKit/WebKit.h>


@interface SingleProductDetaileCollectionCell()
<WKNavigationDelegate>

{
    CGFloat _height;
}

@property (nonatomic ,strong) WKWebView *webView;


@end

@implementation SingleProductDetaileCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self.contentView addSubview:self.webView];
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.height.mas_equalTo(@500);
         }];
        
    }
    
    return self;
}

- (WKWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[WKWebView alloc]init];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
//        [_webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    }
    return _webView;
}

- (void)loadHTMLString:(NSString *)htmlString
{
    // css 适配
    NSString *string = @"<style>p{font-size:45px;text-align:left;padding:0 0;margin:0 0;}img{width:100%;}</style>;</?font[^><]*>";
    NSString *htmlStr = [NSString stringWithFormat:@"%@%@",htmlString,string];
    
    NSLog(@"htmlString =========== %@",htmlString);
    
    // 确保只加载一次
//    if ([_webView.URL.absoluteString containsString:ImageUrl] == NO)
//    {
        [_webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:ImageUrl]];
        
        
        [_webView mas_updateConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.height.mas_equalTo(_webView.scrollView.contentSize.height);
         }];
        
//        NSLog(@"webView.scrollView.contentSize  ------ %@",[NSValue valueWithCGSize:_webView.scrollView.contentSize]);
//    }
    

    if (_height != _webView.scrollView.contentSize.height)
    {
        _height = _webView.scrollView.contentSize.height;
        
        NSLog(@"新的高度 ====== %f",_height);
        self.updateSingleCollectionCellHeight(_height);
    }
    

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"加载完成 ====== %@",[NSValue valueWithCGSize:webView.scrollView.contentSize]);
    
    
    if (_height < webView.scrollView.contentSize.height)
    {
        _height = webView.scrollView.contentSize.height;
        
        NSLog(@"新的高度 ====== %f",_height);
        self.updateSingleCollectionCellHeight(_height);
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
    CGSize newSize = [change[@"new"] CGSizeValue];
    CGSize oldSize = [change[@"old"] CGSizeValue];
    
    CGFloat newHeight = newSize.height;
    NSLog(@"改变 ====== %@",change);
    
}



@end
