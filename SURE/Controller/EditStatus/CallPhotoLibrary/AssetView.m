//
//  AssetView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define kThumbnailLength    (ScreenWidth - 5 * 2 )/ 4.0   //78.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)


#import "AssetView.h"

#import "TapAssetView.h"
#import "VideoTitleView.h"
#import "NSDate+TimeInterval.h"

@interface AssetView()

<TapAssetViewDelegate>

@property (nonatomic, strong) ALAsset *asset;


@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) VideoTitleView *videoTitle;
@property (nonatomic, strong) TapAssetView *tapAssetView;



@end

@implementation AssetView

static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIColor *titleColor;

+ (void)initialize
{
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    titleColor      = [UIColor whiteColor];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailSize.width, kThumbnailSize.height)];
        [self addSubview:_imageView];
        
        _videoTitle=[[VideoTitleView alloc] initWithFrame:CGRectMake(0, kThumbnailSize.height-20, kThumbnailSize.width, titleHeight)];
        _videoTitle.hidden=YES;
        _videoTitle.font=titleFont;
        _videoTitle.textColor=titleColor;
        _videoTitle.textAlignment=NSTextAlignmentRight;
        _videoTitle.backgroundColor=[UIColor clearColor];
        [self addSubview:_videoTitle];
        
        _tapAssetView=[[TapAssetView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tapAssetView.delegate=self;
        [self addSubview:_tapAssetView];
    }
    
    return self;
}

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced
{
    self.asset=asset;
    
    [_imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        _videoTitle.hidden=NO;
        _videoTitle.text= [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    }
    else
    {
        _videoTitle.hidden=YES;
    }
    
    _tapAssetView.disabled=! [selectionFilter evaluateWithObject:asset];
    
    _tapAssetView.selected = isSeleced;
}

#pragma mark - ZYQTapAssetView Delegate

-(BOOL)shouldTap
{
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldSelectAsset:)])
    {
        return [_delegate shouldSelectAsset:_asset];
    }
    return YES;
}

// 选中 、
-(void)touchSelect:(BOOL)select
{
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(tapSelectHandle:asset:)])
    {
        [_delegate tapSelectHandle:select asset:_asset];
    }
}



@end
