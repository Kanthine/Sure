//
//  OperationPhotoVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/12.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define imageHeight 34.0
#define Space 8

#import "OperationPhotoVC.h"

#import "AcquirePhotoVC.h"
#import "FWApplyFilter.h"
#import "ChooseLableViewController.h"
#import "CustomTagView.h"

#import "EditImageView.h"
#import "FilerView.h"

#import "PostStatusViewController.h"



typedef NS_ENUM(NSInteger, OperationPhotoState)
{
    OperationPhotoStateNormal = 0,
    OperationPhotoStateFiler,
    OperationPhotoStateCrop,
};


@interface OperationPhotoVC ()

<AcquirePhotoVCDelegate,UIAlertViewDelegate,ChooseLableViewControllerDelegate,CustomTagViewDelegate,EditImageViewDelegate>

{
    BOOL _isCutPhotoStatus;
    BOOL _isFilerStatus;
    
    
    __weak IBOutlet UIButton *_goBackButton;
    __weak IBOutlet UIButton *_nextStepButton;
    __weak IBOutlet UIScrollView *_photoContentScrollView;
    
    UIButton *_addPhotoButton;
}

@property (nonatomic ,strong) FilerView *filerPreviewView;
@property (nonatomic ,strong) EditImageView *editImageView;

@end

@implementation OperationPhotoVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = YES;
    
    _isFilerStatus = NO;
    _isCutPhotoStatus = NO;
    
    
    [self customTopViewClick];
    [self.view addSubview:self.editImageView];
    [self setFilerScrollView];
    
    
    
    
    EditImageModel *image = _imageArray[0];
    _editImageView.imageModel = image;
    _editImageView.currentIndexImage = 0;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Top View

- (void)customTopViewClick
{
    for (int i = 0; i < _imageArray.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * (imageHeight + Space ), 0, imageHeight, imageHeight);
        button.tag = i + 10;
        [button addTarget:self action:@selector(switchPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        EditImageModel *imageModel = _imageArray[i];
        
        
        NSLog(@"modelType === %ld",(long)imageModel.modelType);
        
        [button setBackgroundImage:imageModel.thumbnailImage forState:UIControlStateNormal];
        [_photoContentScrollView addSubview:button];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureDeletePhotoClick:)];
        [button addGestureRecognizer:longPressGesture];
    }

    
    
    
    _addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addPhotoButton setTitle:@"+" forState:UIControlStateNormal];
    _addPhotoButton.frame = CGRectMake((imageHeight + Space ) * _imageArray.count, 0, imageHeight, imageHeight);
    [_addPhotoButton addTarget:self action:@selector(addPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_addPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_photoContentScrollView addSubview:_addPhotoButton];
    
    _photoContentScrollView.contentSize = CGSizeMake((imageHeight + Space ) * (_imageArray.count + 1), 34);
    _photoContentScrollView.pagingEnabled = YES;
}

- (void)reloadTopPhotoContentScrollView
{
    for (UIView *subView in _photoContentScrollView.subviews)
    {
        if (subView.tag > 9)
        {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < _imageArray.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * (imageHeight + Space ), 0, imageHeight, imageHeight);
        button.tag = i + 10;
        [button addTarget:self action:@selector(switchPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        EditImageModel *imageModel = _imageArray[i];
        if (imageModel.isFiler)
        {
            [button setBackgroundImage:imageModel.filerImage forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:imageModel.thumbnailImage forState:UIControlStateNormal];
        }
        
        [_photoContentScrollView addSubview:button];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureDeletePhotoClick:)];
        [button addGestureRecognizer:longPressGesture];
    }
    
    _addPhotoButton.frame = CGRectMake((imageHeight + Space ) * _imageArray.count, 0, imageHeight, imageHeight);
    _photoContentScrollView.contentSize = CGSizeMake((imageHeight + Space ) * (_imageArray.count + 2), 34);
    
    
    
    
    EditImageModel *image = _imageArray[0];
    _editImageView.currentIndexImage = 0;
    _editImageView.imageModel = image;
    _filerPreviewView.imageModel = image;
}


- (IBAction)goBackButtonclick:(UIButton *)sender
{
    //返回相机界面，则重启相机
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopBackAcquirePhoto" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextStepButtonClick:(UIButton *)sender
{
    PostStatusViewController *postVC = [[PostStatusViewController alloc]init];
    postVC.imageArray = _imageArray;
    [self.navigationController pushViewController:postVC animated:YES];
}

//切换中间视图 图片
- (void)switchPhotoButtonClick:(UIButton *)button
{
    NSInteger index = button.tag - 10;
    EditImageModel *image = _imageArray[index];
    
    [self resumeEditStateNormal];
    
    
    _editImageView.currentIndexImage = index;
    _editImageView.imageModel = image;
    _filerPreviewView.imageModel = image;
}

// 添加   图片
- (void)addPhotoButtonClick
{
    [self resumeEditStateNormal];
    
    AcquirePhotoVC *acVC = [[AcquirePhotoVC alloc]init];
    acVC.selectedImageArray = _imageArray;
    [acVC setPhotoLibraryChildViewController];
    acVC.status = AcquirePhotoStateLibrary;
    acVC.delegate = self;
    [self presentViewController:acVC animated:YES completion:nil];
    
    NSLog(@"_imageArray ======== %@",_imageArray);
}

//  AcquirePhotoVCDelegate

- (void)addPhotoSucceesWithImageArray:(NSMutableArray *)newImageArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       for (EditImageModel *newImage in newImageArray)
                       {
                           BOOL isExit = NO;
                           for (EditImageModel *oldImage in self.imageArray)
                           {
                               
                               if ([newImage.resourceURL isEqual:oldImage.resourceURL])
                               {
                                   isExit = YES;
                                   break;
                               }
                               else
                               {
                                   isExit = NO;

                               }
                           }
                           
                           if (isExit == NO)
                           {
                               [self.imageArray addObject:newImage];
                           }
                           
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self reloadTopPhotoContentScrollView];
                                      });
                   });
}

// 长按删除
- (void)longPressGestureDeletePhotoClick:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        if (_imageArray.count > 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您是否要删除这张照片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alertView.tag = longPressGesture.view.tag;
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSInteger index = alertView.tag - 10;
        [self.imageArray removeObjectAtIndex:index];
        [self reloadTopPhotoContentScrollView];
    }
}

#pragma mark - Middle View

- (EditImageView *)editImageView
{
    if (_editImageView == nil)
    {
        _editImageView = [[EditImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 4 / 3.0)];
        _editImageView.delegate = self;
        _editImageView.state = EditImageViewStateNormal;
        _editImageView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0);
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAddTagClick)];
        [_editImageView addGestureRecognizer:tapGesture];
    }
    
    return _editImageView;
}

//点击 添加标签
- (void)tapGestureAddTagClick
{
    [self resumeEditStateNormal];

    
    ChooseLableViewController *chooseSignVC = [[ChooseLableViewController alloc]init];
    chooseSignVC.delegate = self;
    [self presentViewController:chooseSignVC animated:YES completion:nil];
}


#pragma mark - Bottom View

- (void)setFilerScrollView
{
    EditImageModel *image = _imageArray[0];
    _filerPreviewView = [[FilerView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 45, ScreenWidth, 90)];
    _filerPreviewView.imageModel = image;
}

//取消编辑状态    点击添加图片按钮 下一步按钮 标签 滤镜 裁剪等
- (void)resumeEditStateNormal
{
    if (self.editImageView.state == EditImageViewStateCropImage)
    {
        [self cancelCutPhotoButtonClick];
    }
    else if (self.editImageView.state == EditImageViewStateFilerImage)
    {
        [self filerImageButtonClick:nil];
    }
}

- (IBAction)cutPhotoButtonClick:(UIButton *)sender//裁图
{
    
    if (_editImageView.imageModel.modelType == EditImageModelTypeVideo)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"视频不可裁剪" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    
    _isCutPhotoStatus = !_isCutPhotoStatus;
    
    if (_isFilerStatus)
    {
        _isFilerStatus = NO;
        [UIView animateWithDuration:.2f animations:^
         {

             _editImageView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0);
             _filerPreviewView.frame =CGRectMake(0, ScreenHeight - 45, ScreenWidth, 80);
         }
        completion:^(BOOL finished)
         {

                 [_filerPreviewView removeFromSuperview];
         }];
    }
    
    
    UIView *cutView = [self.view viewWithTag:345];
    if (cutView == nil)
    {
        cutView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 45, ScreenWidth, 45)];
        cutView.tag = 345;
        cutView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:cutView];
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        grayView.backgroundColor = GrayColor;
        [cutView addSubview:grayView];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, ScreenWidth / 2.0, 45);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelCutPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cutView addSubview:cancelButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(ScreenWidth / 2.0, 0, ScreenWidth / 2.0, 45);
        [confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(saveCutPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cutView addSubview:confirmButton];
    }
    [self.view bringSubviewToFront:cutView];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2f];
    if (_isCutPhotoStatus)
    {
        cutView.frame = CGRectMake(0, ScreenHeight - 45, ScreenWidth, 45);

    }
    else
    {
        cutView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 45);
    }
    [UIView commitAnimations];
    

    
    if (_isCutPhotoStatus)
    {
        _editImageView.state = EditImageViewStateCropImage;
    }
    else
    {
        _editImageView.state = EditImageViewStateNormal;
    }
    
    
}

- (void)cancelCutPhotoButtonClick
{
    if (_isCutPhotoStatus)
    {
        UIView *cutView = [self.view viewWithTag:345];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2f];
        cutView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 45);
        [UIView commitAnimations];
        _isCutPhotoStatus = NO;
        _editImageView.state = EditImageViewStateNormal;
    }
}

- (void)saveCutPhotoButtonClick
{
    _editImageView.isCropSucceed = YES;
     [self cancelCutPhotoButtonClick];
}

- (IBAction)filerImageButtonClick:(UIButton *)sender
{
    if (_editImageView.state == EditImageViewStateCropImage)
    {
        _isCutPhotoStatus = NO;
    }

    
    
    _isFilerStatus = !_isFilerStatus;
    
    if (_filerPreviewView == nil)
    {
        return;
    }
    
    
    
    if (_isFilerStatus)
    {
        [self.view addSubview:_filerPreviewView];
        [self.view bringSubviewToFront:sender.superview];
    }

    
    [UIView animateWithDuration:.2f animations:^
    {
        if (_isFilerStatus)
        {
            _editImageView.frame = CGRectMake(0, 50, ScreenWidth, ScreenWidth * 4 / 3.0);
            _filerPreviewView.frame =CGRectMake(0, ScreenHeight - 125, ScreenWidth, 80);
        }
        else
        {
            _editImageView.center = CGPointMake(ScreenWidth / 2.0, ScreenHeight / 2.0);
            _filerPreviewView.frame =CGRectMake(0, ScreenHeight - 45, ScreenWidth, 80);
        }
    }
                     completion:^(BOOL finished)
     {
         if (_isFilerStatus == NO)
         {
             [_filerPreviewView removeFromSuperview];
         }
    }];
    
    
    if (_isFilerStatus)
    {
        _editImageView.state = EditImageViewStateFilerImage;
    }
    else
    {
        _editImageView.state = EditImageViewStateNormal;
    }

}

- (IBAction)addSignButtonClick:(UIButton *)sender
{
    [self resumeEditStateNormal];
    [self tapGestureAddTagClick];
}

#pragma mark - EditImageViewDelegate

// 更换滤镜 头部视图更换 代理方法
- (void)reloadScrollViewWithIndex:(NSInteger)index
{
    for (UIView *subView in _photoContentScrollView.subviews)
    {
        if (subView.tag ==  index + 10)
        {
            UIButton *button = (UIButton *)subView;
            EditImageModel *acImage = _imageArray[index];
            if (acImage.isFiler)
            {
                [button setBackgroundImage:acImage.filerImage forState:UIControlStateNormal];
            }
            else
            {
                [button setBackgroundImage:acImage.thumbnailImage forState:UIControlStateNormal];
            }
        }
    }
}




#pragma mark - ChooseLableViewControllerDelegate

- (void)selectedSignWithSign:(NSString *)signString
{
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(addSign:) userInfo:[NSDictionary dictionaryWithObject:signString forKey:@"sign"] repeats:NO];
}

- (void)addSign:(NSTimer *)timer
{
    CGPoint allowPoint = CGPointMake(_editImageView.allowAddRect.origin.x + _editImageView.allowAddRect.size.width / 2.0, _editImageView.allowAddRect.origin.y + _editImageView.allowAddRect.size.height / 2.0);
    
    CustomTagView * tagView = [[CustomTagView alloc]initWithFrame:CGRectMake(100, 100, 100, HEIGHT) Title:[timer.userInfo objectForKey:@"sign"]];
    tagView.center = allowPoint;
    tagView.delegate = self;
    tagView.allowPanRect = _editImageView.allowAddRect;
    tagView.backgroundColor = [UIColor clearColor];
    [_editImageView addSubview:tagView];
    
    
    EditImageModel *acImage = _imageArray[_editImageView.currentIndexImage];
    acImage.isAddTag = YES;
    
    if (acImage.tagArray == nil)
    {
        acImage.tagArray = [NSMutableArray array];
    }
    
    
    CGFloat widthRate = (tagView.frame.origin.x - _editImageView.allowAddRect.origin.x )/ _editImageView.allowAddRect.size.width;
    CGFloat heightRate =(tagView.frame.origin.y - _editImageView.allowAddRect.origin.y )/ _editImageView.allowAddRect.size.height;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(widthRate) forKey:WidthRateKey];
    [dict setObject:@(heightRate) forKey:HeightRateKey];
    [dict setObject:[timer.userInfo objectForKey:@"sign"] forKey:TagTitle];
    [acImage.tagArray addObject:dict];
}

- (void)updateTagViewFrame:(CGRect)frame Title:(NSString *)titleString
{
    CGRect allowRect = _editImageView.allowAddRect;
    
    EditImageModel *acImage = _imageArray[_editImageView.currentIndexImage];
    acImage.isAddTag = YES;
    
    

    CGFloat widthRate = (frame.origin.x - allowRect.origin.x )/ allowRect.size.width;
    CGFloat heightRate =(frame.origin.y - allowRect.origin.y )/ allowRect.size.height;

    
    
    for (int i = 0;  i < acImage.tagArray.count; i ++)
    {
        NSMutableDictionary *dict = acImage.tagArray[i];
        NSString *title = [dict objectForKey:TagTitle];
        if ([titleString isEqualToString:title])
        {
            [dict setObject:@(widthRate) forKey:WidthRateKey];
            [dict setObject:@(heightRate) forKey:HeightRateKey];
            [acImage.tagArray replaceObjectAtIndex:i withObject:dict];
            break;
        }
    }
}

- (void)deleteTagClick:(CustomTagView *)tagView
{
    [tagView removeFromSuperview];
    tagView = nil;
}

@end
