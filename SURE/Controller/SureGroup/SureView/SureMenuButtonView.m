//
//  SureMenuButtonView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SureMenuButtonView.h"


@interface SureMenuButton : UIButton
- (void)addBackImageWithImageTitle:(NSString *)imageTitle;
@end


@implementation SureMenuButton

- (void)addBackImageWithImageTitle:(NSString *)imageTitle
{
    
    CGFloat width = self.frame.size.width;
    
    CGFloat imageWidth = 25.0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageTitle]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake((width - imageWidth) / 2.0, (width - imageWidth) / 2.0, imageWidth, imageWidth);
    [self addSubview:imageView];
}

@end














@interface SureMenuButtonView ()

@property (nonatomic, strong) SureMenuButton *takePhotoButton;

@property (nonatomic, strong) SureMenuButton *libraryPhotoButton;

@property (nonatomic, strong) SureMenuButton *takeVideoButton;

@end

static SureMenuButtonView *instanceMenuView;

@implementation SureMenuButtonView

- (instancetype)init
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49);
        UILabel *grayLable = [[UILabel alloc]initWithFrame:self.bounds];
        [self addSubview:grayLable];
        grayLable.tag = 78;
        grayLable.backgroundColor = [UIColor blackColor];
        grayLable.alpha = .4f;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGrstureClick)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    UILabel *grayLable = [self viewWithTag:78];
    grayLable.frame = self.bounds;
    
}



- (void)showItems
{
    CGPoint center = self.centerPoint;
    CGFloat r = 130;
    
//    CGPoint point1 = CGPointMake(center.x - r * cos( - M_PI / 18), center.y + r * sin( - M_PI / 18));
    CGPoint point1 = CGPointMake(center.x - r * cos( - M_PI / 80), center.y + r * sin( - M_PI / 80));
    CGPoint point2 = CGPointMake(center.x - r * cos( - M_PI / 4), center.y + r * sin(- M_PI / 4));
    CGPoint point3 = CGPointMake(center.x - r * cos( - M_PI  * 39 / 80), center.y + r * sin(- M_PI * 39 / 80));
    
    SureMenuButton *menuButton1 = [SureMenuButton buttonWithType:UIButtonTypeCustom];//相机
    menuButton1.tag = 2;
    menuButton1.backgroundColor = [UIColor whiteColor];
    menuButton1.frame = CGRectMake(0, 0, _buttonWidth, _buttonWidth);
    menuButton1.center = CGPointMake(center.x, center.y);
    [menuButton1 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    menuButton1.layer.cornerRadius = _buttonWidth / 2.0;
    menuButton1.clipsToBounds = YES;
    [menuButton1 addBackImageWithImageTitle:@"tabBar_Sure_Select"];

    SureMenuButton *menuButton2 = [SureMenuButton buttonWithType:UIButtonTypeCustom];
    menuButton2.backgroundColor = [UIColor whiteColor];//相册
    menuButton2.tag = 1;
    menuButton2.frame = CGRectMake(0, 0, _buttonWidth, _buttonWidth);
    menuButton2.center = CGPointMake(center.x, center.y);
    [menuButton2 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    menuButton2.layer.cornerRadius = _buttonWidth / 2.0;
    menuButton2.clipsToBounds = YES;
   [menuButton2 addBackImageWithImageTitle:@"photoLibraryLogo"];
    
    
    SureMenuButton *menuButton3 = [SureMenuButton buttonWithType:UIButtonTypeCustom];
    menuButton3.backgroundColor = [UIColor whiteColor];//视频
    menuButton3.tag = 3;
    menuButton3.frame = CGRectMake(0, 0, _buttonWidth, _buttonWidth);
    menuButton3.center = CGPointMake(center.x, center.y);
    [menuButton3 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    menuButton3.layer.cornerRadius = _buttonWidth / 2.0;
    menuButton3.clipsToBounds = YES;
    [menuButton3 addBackImageWithImageTitle:@"takeVideo"];
    
    
    
    
    _takePhotoButton = menuButton1;
    _libraryPhotoButton = menuButton2;
    _takeVideoButton = menuButton3;
    
    
    _takePhotoButton.alpha = 0;
    _libraryPhotoButton.alpha = 0;
    _takeVideoButton.alpha = 0;
    
    [self addSubview:menuButton1];
    [self addSubview:menuButton2];
    [self addSubview:menuButton3];
    
    [UIView animateWithDuration:0.2 animations:^
    {
        _takePhotoButton.alpha = 1;
        _libraryPhotoButton.alpha = 1;
        _takeVideoButton.alpha = 1;
        
        _takePhotoButton.center = point1;
        _libraryPhotoButton.center = point3;
        _takeVideoButton.center = point2;
    }];
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.2 animations:^
    {
        _takePhotoButton.center = self.centerPoint;
        _libraryPhotoButton.center = self.centerPoint;
        _takeVideoButton.center = self.centerPoint;
        
        _takePhotoButton.alpha = 0;
        _libraryPhotoButton.alpha = 0;
        _takeVideoButton.alpha = 0;

    } completion:^(BOOL finished)
    {
        [_takePhotoButton removeFromSuperview];
        [_libraryPhotoButton removeFromSuperview];
        [_takeVideoButton removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)dismissAtNow
{
    [_takePhotoButton removeFromSuperview];
    [_libraryPhotoButton removeFromSuperview];
    [_takeVideoButton removeFromSuperview];
    [self removeFromSuperview];
}

- (void)_addExamApprovel:(UIButton *)sender
{
    if (self.clickAddButton)
    {
        self.clickAddButton(sender.tag);
    }
}

+ (instancetype)standardMenuView
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
    {
        instanceMenuView = [[self alloc] init];
    });
    return instanceMenuView;
}

- (void)tapGrstureClick
{
    if (self.clickAddButton)
    {
        self.clickAddButton(-1);
    }
}

@end
