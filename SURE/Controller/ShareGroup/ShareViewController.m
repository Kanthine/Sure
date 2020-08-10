//
//  ShareViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define ItemSpace 15.0f
#define ItemWidth (ScreenWidth - 6 * ItemSpace ) / 5.0
#define ItemHeight (ItemWidth + 25.0)

#define PlatformViewHeight (30.0 + (ItemHeight + 20) * 2 + 45.0)

#import "ShareViewController.h"

#import "ShareButtonView.h"

@interface ShareViewController ()

<ShareButtonViewDelegate>


{
    NSString *_linkString;
    NSString *_imageString;
    NSString *_detaileStr;
}

@property (nonatomic ,strong) UIView *platformView;
/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@end

@implementation ShareViewController

/** 动画时间 */
static CGFloat const AnimationDuration = 0.2;

- (instancetype)initWithLinkUrl:(NSString *)linkString imageUrlStr:(NSString *)imageString Descr:(NSString *)detaileStr
{
    self = [super init];
    
    if (self)
    {
        _linkString = linkString;
        _imageString = imageString;
        _detaileStr = detaileStr;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.coverButton];
    [self.view addSubview:self.platformView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)platformView
{
    if (_platformView == nil)
    {
        _platformView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth,PlatformViewHeight)];
        _platformView.backgroundColor = [UIColor whiteColor];
        
        
        CGFloat yCoordinate = 30.0f;

        
        NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"Instagram",@"QQ",@"QQ空间",@"复制链接", nil];
        NSMutableArray *imageArray = [NSMutableArray arrayWithObjects:@"share_WeChat",@"share_WeChatCircle",@"share_Instagram",@"share_QQ",@"share_QQZone",@"share_CopyLink", nil];
        NSArray *platArray = @[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Instagram),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@""];
        for (int i = 0; i < titleArray.count; i ++)
        {
            NSInteger row = i % 5;
            NSInteger lie = i / 5;
            
            ShareButtonView *buttonView = [[ShareButtonView alloc]initWithFrame:CGRectMake(ItemSpace + (ItemWidth + ItemSpace) * row, yCoordinate + lie * (ItemHeight + 20), ItemWidth, ItemHeight) Title:titleArray[i] ImageTitle:imageArray[i]];
            NSNumber *shareNum = platArray[i];
            buttonView.platformType = [shareNum integerValue];
            buttonView.delegate = self;
            [_platformView addSubview:buttonView];
        }
        
        yCoordinate = yCoordinate + (ItemHeight + 20) * 2;
        
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0,yCoordinate, ScreenWidth, .5f)];
        grayLable.backgroundColor = GrayLineColor;
        [_platformView addSubview:grayLable];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelButton.frame = CGRectMake(0, yCoordinate + 1, ScreenWidth, 45);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:TextColor149 forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_platformView addSubview:cancelButton];
    }
    
    return _platformView;
}

- (UIButton *)coverButton
{
    if (_coverButton == nil)
    {
        _coverButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverButton.backgroundColor = [UIColor blackColor];
        _coverButton.alpha = 0.0;
        [_coverButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        _coverButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        

    }
    return _coverButton;
}


- (void)showPlatView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.platformView.transform = CGAffineTransformMakeTranslation(0,  -PlatformViewHeight);
         self.coverButton.alpha = 0.3;
     }];
}

- (void)dismissPickerView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.platformView.transform = CGAffineTransformMakeTranslation(0, PlatformViewHeight);
         self.coverButton.alpha = 0.0;
     }
     completion:^(BOOL finished)
    {
         [self.platformView removeFromSuperview];
         [self.coverButton removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:^
        {
//            [self removeFromParentViewController];
        }];
     }];
    
    
}

- (void)cancelButtonClick
{
    [self dismissPickerView];
}

#pragma mark - 

- (void)ownerCustomButtonClick:(UMSocialPlatformType)platformType
{
    _linkString = @"https://www.pgyer.com/sureIOS";
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = _detaileStr;

    UMShareWebpageObject *shareURLObject = [UMShareWebpageObject shareObjectWithTitle:@"SURE秀啊" descr:_detaileStr thumImage:_imageString];
    shareURLObject.webpageUrl = _linkString;
    messageObject.shareObject = shareURLObject;
    
    
    if ([[UMSocialManager defaultManager] isInstall:platformType] == NO)
    {
        NSString *platName = @"";
        
        switch (platformType)
        {
            case UMSocialPlatformType_WechatSession:
            case UMSocialPlatformType_WechatTimeLine:
                platName = @"微信";
                break;
            case UMSocialPlatformType_Instagram:
                platName = @"Instagram";
                break;
            case UMSocialPlatformType_QQ:
            case UMSocialPlatformType_Qzone:
                platName = @"QQ";
                break;
            default:
                break;
        }
        
        NSString *string = [NSString stringWithFormat:@"您的手机没有安装%@",platName];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享失败" message:string preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error)
    {
        if (error)
        {
            NSLog(@"************Share fail with error %@*********",error);
        }
        else
        {
            NSLog(@"response data is %@",data);
        }
    }];
}


@end
