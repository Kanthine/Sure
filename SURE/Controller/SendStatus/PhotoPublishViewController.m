//
//  PhotoPublishViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define ItemWidth  (ScreenWidth - 5 * 10.0) / 4.0


#import "PhotoPublishViewController.h"
#import "PhotoPreviewViewController.h"
#import "PhotoResourceVC.h"
#import "PostSureTool.h"


@interface PhotoPublishViewController ()
<UITextViewDelegate>

{
    NSString *_jsonString;
}

@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) UILabel *placeholderLable;
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UIView *imageContentView;
@property (nonatomic ,strong) UIView *shareView;


@end

@implementation PhotoPublishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageFinishedDismiss:) name:@"DismissPhotoResourceViewControll" object:nil];
    
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.placeholderLable];
    [self.view addSubview:self.imageContentView];
    [self.view addSubview:self.shareView];
    if (_textView.text.length == 0)
    {
        _placeholderLable.hidden = NO;
    }
    else
    {
        _placeholderLable.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self updateImageContentView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIView *)navBarView
{
    if (_navBarView == nil)
    {
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _navBarView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 60, 44);
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:cancelButton];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_RightButton"]];
        [imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
        imageView.frame = CGRectMake(10, 14, 9, 15);
        [_navBarView addSubview:imageView];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 80)/2.0, 0, 80, 44)];
        titleLable.textColor = [UIColor blackColor];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = @"发布";
        [_navBarView addSubview:titleLable];
        
        UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextStepButton.frame = CGRectMake(ScreenWidth - 70, 0, 60, 44);
        nextStepButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        nextStepButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextStepButton addTarget:self action:@selector(nextStepButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [nextStepButton setTitle:@"确定" forState:UIControlStateNormal];
        [nextStepButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        [_navBarView addSubview:nextStepButton];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
        lineView.backgroundColor = GrayLineColor;
        [_navBarView addSubview:lineView];
    }
    return _navBarView;
}

- (UILabel *)placeholderLable
{
    if (_placeholderLable == nil)
    {
        _placeholderLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, 100, 20)];
        _placeholderLable.text = @"说点什么吧";
        _placeholderLable.font = [UIFont systemFontOfSize:16];
        _placeholderLable.textColor = TextColor149;
    }
    
    return _placeholderLable;
}

- (UITextView *)textView
{
    if (_textView == nil)
    {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 54, ScreenWidth - 20, 100)];
        _textView.delegate = self;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.autocorrectionType = UITextAutocorrectionTypeYes;
    }
    
    return _textView;
}

- (UIView *)imageContentView
{
    if (_imageContentView == nil)
    {
        _imageContentView = [[UIView alloc]initWithFrame:CGRectMake(10, 165, ScreenWidth - 20, ItemWidth)];
        _imageContentView.backgroundColor = [UIColor whiteColor];
    }
    
    return _imageContentView;
}

- (UIView *)shareView
{
    if (_shareView == nil)
    {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _shareView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 1)];
        lineView.backgroundColor = GrayLineColor;
        [_shareView addSubview:lineView];
        
        
        
        
        
        NSArray *imageArray = @[@"camera_Wechat",@"camera_Sina",@"camera_QQZone"];
        NSArray *imageSelectedArray = @[@"camera_Wechat_Selected",@"camera_Sina_Selected",@"camera_QQZone_Selected"];
        
        CGFloat x = ScreenWidth - 50 * 3;
        for (int i = 0; i < imageArray.count; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x + 50 * i, 0, 50, 40);
            [button setImageEdgeInsets:UIEdgeInsetsMake(7, 7 + 5, 7, 7 + 5)];
            [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:imageSelectedArray[i]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_shareView addSubview:button];
        }
    }
    
    return _shareView;
}

- (void)cancelButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)nextStepButtonClick
{
    __weak __typeof__(self) weakSelf = self;
    
    [_textView endEditing:YES];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
   
    [PostSureTool creatJsonWithImageModelArray:_modelArray CompletionBlock:^(NSString *jsonString,NSArray *brandArray)
    {
       if (jsonString && jsonString.length > 1)
       {
           /*
            uid 用户ID
            sure_body 文字
            imglist json数据
            supplier_list 商户列表
            */
           __block NSString *brandsStr = @"";
           [brandArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
           {
               if ([brandsStr isEqualToString:@""])
               {
                   brandsStr = obj;
               }
               else
               {
                   brandsStr = [NSString stringWithFormat:@"%@,%@",brandsStr,obj];
               }
           }];
           
           
           AccountInfo *account = [AccountInfo standardAccountInfo];
           NSDictionary *parDict = @{@"uid":account.userId,@"sure_body":_textView.text,@"imglist":jsonString,@"supplier_list":brandsStr};
           
           NSLog(@"参数======== %@",parDict);
           
           [weakSelf.httpManager postSureWithParameterDict:parDict CompletionBlock:^(NSError *error)
            {
                [hud hide:YES];
                
                [self dismissViewControllerAnimated:YES completion:^
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSureListData" object:nil];
                }];
            }];
       }
       else
       {
           [hud hide:YES];
       }
   }];

    
}

- (void)addImageButtonclick
{
    if (self.modelArray && self.modelArray.count < 5)
    {
        [self addImageResource];
    }
    else if (self.modelArray && self.modelArray.count > 4 )
    {
        [self tipLimitImageCount];
    }
    
}

- (void)addImageResource
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [weakSelf presentPhotoResourceViewControllerWithIndex:0];
                                        
                                    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [weakSelf presentPhotoResourceViewControllerWithIndex:1];
                                      
                                      
                                  }];
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"录像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [weakSelf presentPhotoResourceViewControllerWithIndex:2];
                                  }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:libraryAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:videoAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)tipLimitImageCount
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您选取的图片最大数量为5张" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (void)presentPhotoResourceViewControllerWithIndex:(NSInteger)index
{
    PhotoResourceVC *resourceVC = [[PhotoResourceVC alloc]initWithContentType:index];
    resourceVC.joinType = PhotoResourceJoinTypePresent;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resourceVC];
    nav.navigationBarHidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)addImageFinishedDismiss:(NSNotification *)notification
{
    SurePhotoModel *model = (SurePhotoModel *) [notification.userInfo objectForKey:@"model"];
    
    [_modelArray addObject:model];
    [self updateImageContentView];
    
}

- (void)updateImageContentView
{
    if (self.modelArray && self.modelArray.count)
    {
        [self.imageContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [obj removeFromSuperview];
         }];
        
        __weak __typeof__(self) weakSelf = self;
        [self.modelArray enumerateObjectsUsingBlock:^(SurePhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             [button addTarget:self action:@selector(lookBigImageClick:) forControlEvents:UIControlEventTouchUpInside];
             button.adjustsImageWhenHighlighted = NO;
             button.adjustsImageWhenDisabled = NO;
             [button setImage:obj.originalImage forState:UIControlStateNormal];
             button.tag = 10 + idx;
             if (idx < 4)
             {
                 
                 button.frame = CGRectMake((ItemWidth + 10) * idx, 0, ItemWidth, ItemWidth);
             }
             else
             {
                 button.frame = CGRectMake(0, ItemWidth + 10, ItemWidth, ItemWidth);
                 
             }
             [weakSelf.imageContentView addSubview:button];
             
             
             
         }];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.adjustsImageWhenDisabled = NO;
        addButton.adjustsImageWhenHighlighted = NO;
        
        [addButton setImage:[UIImage imageNamed:@"photoAdd"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addImageButtonclick) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.modelArray.count < 5)
        {
            [self.imageContentView addSubview:addButton];
        }
        
        
        
        
        int row = self.modelArray.count % 4;
        if (self.modelArray.count > 3)
        {
            addButton.frame = CGRectMake((ItemWidth + 10) * row, ItemWidth + 10, ItemWidth, ItemWidth);
            self.imageContentView.frame = CGRectMake(10, 165, ScreenWidth - 20, ItemWidth* 2 + 10);
        }
        else
        {
            addButton.frame = CGRectMake((ItemWidth + 10) * row,0, ItemWidth, ItemWidth);
            self.imageContentView.frame = CGRectMake(10, 165, ScreenWidth - 20, ItemWidth);
        }
        self.shareView.frame = CGRectMake(0, 165 + CGRectGetHeight(self.imageContentView.frame) + 10, ScreenWidth, 40);

    }
}

- (void)lookBigImageClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    
    PhotoPreviewViewController *previewVC = [[PhotoPreviewViewController alloc]initWithModelArray:_modelArray IndexPath:index];
    [self.navigationController pushViewController:previewVC animated:YES];
}



#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (_textView.text.length == 0)
    {
        _placeholderLable.hidden = NO;
    }
    else
    {
        _placeholderLable.hidden = YES;
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_textView.text.length == 0)
    {
        _placeholderLable.hidden = NO;
    }
    else
    {
        _placeholderLable.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView endEditing:YES];
}

@end
