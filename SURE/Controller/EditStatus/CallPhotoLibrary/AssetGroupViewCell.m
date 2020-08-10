//
//  AssetGroupViewCell.m
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define kPopoverContentSize CGSizeMake(ScreenWidth, ScreenHeight - 44 - 49)
#define RowHeight    ScreenWidth / 5.0 + 12  //78.0f

#import "AssetGroupViewCell.h"

@interface AssetGroupViewCell ()

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) UILabel *grayLable;
@end

@implementation AssetGroupViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup
{
    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / RowHeight;
    
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if (_grayLable == nil)
    {
        _grayLable = [[UILabel alloc]initWithFrame:CGRectMake(17, self.imageView.frame.size.height, ScreenWidth - 17, 1)];
        _grayLable.backgroundColor = RGBA(220, 220, 220,1);
        [self addSubview:_grayLable];
    }

}

- (NSString *)accessibilityLabel
{
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    return [label stringByAppendingFormat:NSLocalizedString(@"%ld 张照片", nil), (long)[self.assetsGroup numberOfAssets]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    self.imageView.frame = CGRectMake(10, 6, RowHeight - 12,  RowHeight - 12);
    self.textLabel.frame = CGRectMake(RowHeight + 20, self.textLabel.frame.origin.y, CGRectGetWidth(self.textLabel.frame), CGRectGetHeight(self.textLabel.frame));
    self.detailTextLabel.frame = CGRectMake(RowHeight + 20, self.detailTextLabel.frame.origin.y, CGRectGetWidth(self.detailTextLabel.frame), CGRectGetHeight(self.detailTextLabel.frame));
    _grayLable.frame = CGRectMake(10, RowHeight - 1, ScreenWidth - 10, 1);
}


@end
