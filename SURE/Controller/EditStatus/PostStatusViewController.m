//
//  PostStatusViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/11/1.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "PostStatusViewController.h"

#import "EditImageModel.h"

#import "CreateSureJson.h"

@interface PostStatusViewController ()

{
    NSString *_jsonString;
    UIView *_postView;
}

@end

@implementation PostStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    EditImageModel *acImage = _imageArray[0];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, ScreenWidth - 20, ScreenWidth - 20)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image =acImage.originalImage;
    [self.view addSubview:imageView];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30 + ScreenWidth + 10, ScreenWidth - 20, 45)];
    textView.text = @"说点什么";
    [self.view addSubview:textView];
    
    UILabel *grayLineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, textView.frame.origin.y + CGRectGetHeight(textView.frame) + 3, ScreenWidth, 1)];
    grayLineLable.backgroundColor = RGBA(220, 220, 220,1);
    [self.view addSubview:grayLineLable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    
    
    if (imageArray && imageArray.count)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            NSString *jsonString = [CreateSureJson creatJsonWithImageModelArray:imageArray];
            
            dispatch_async(dispatch_get_main_queue(), ^
            {
                _jsonString = jsonString;
            });
        });
    }
}

- (IBAction)postStatusButtonClick:(UIButton *)sender
{
    if (_jsonString)
    {
        /*
         uid 用户ID
         sure_body 文字
         imglist json数据
         */
        
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        NSDictionary *parDict = @{@"uid":account.userId,@"sure_body":@"说点什么",@"imglist":_jsonString};
        
        
        [self.httpManager postSureWithParameterDict:parDict CompletionBlock:^(NSError *error)
        {
            
        }];
    }
    
    
    
}


- (IBAction)goBackButtonclick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
