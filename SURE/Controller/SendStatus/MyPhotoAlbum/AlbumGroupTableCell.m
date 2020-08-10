//
//  AlbumGroupTableCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//



#import "AlbumGroupTableCell.h"
#import <Masonry.h>
#import "NSArray+MASShorthandAdditions.h"


@interface AlbumGroupTableCell()

@property (nonatomic ,strong) UIImageView *homeImageView;
@property (nonatomic ,strong) UILabel *groupNameLable;
@property (nonatomic ,strong) UILabel *photoCountLable;

@property (nonatomic, strong) UILabel *grayLable;

@end

@implementation AlbumGroupTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:self.homeImageView];
        [self addSubview:self.groupNameLable];
        [self addSubview:self.photoCountLable];
        [self addSubview:self.grayLable];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];

        
    }
    
    return self;
}

- (void)updateConstraints
{
    
    __weak __typeof__(self) weakSelf = self;


//    self.homeImageView make
    
    [self.homeImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@10);
         make.left.mas_equalTo(@10);
         make.bottom.mas_equalTo(@-10);
         make.width.mas_equalTo(weakSelf.homeImageView.mas_height).multipliedBy(1);
     }];
    
    [self.groupNameLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(-10);
         make.left.equalTo(_homeImageView.mas_right).with.offset(10);
         make.height.mas_equalTo(@20);
         make.right.mas_equalTo(@-60);
     }];
    
    
    [self.photoCountLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_groupNameLable.mas_bottom).with.offset(5);
         make.left.equalTo(_homeImageView.mas_right).with.offset(10);
         make.height.mas_equalTo(@20);
         make.right.mas_equalTo(@-60);
     }];
    
    [self.grayLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.mas_equalTo(@10);
         make.bottom.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
         make.height.mas_equalTo(@0.5);
     }];
    
    
    
    
    
    [super updateConstraints];
}

- (UIImageView *)homeImageView
{
    if (_homeImageView == nil)
    {
        _homeImageView = [[UIImageView alloc]init];
        _homeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _homeImageView.clipsToBounds = YES;
    }
    
    return _homeImageView;
}

- (UILabel *)groupNameLable
{
    if (_groupNameLable == nil)
    {
        _groupNameLable = [[UILabel alloc]init];
        _groupNameLable.font = [UIFont systemFontOfSize:14];
        _groupNameLable.textColor = [UIColor blackColor];
        _groupNameLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _groupNameLable;
}

- (UILabel *)photoCountLable
{
    if (_photoCountLable == nil)
    {
        _photoCountLable = [[UILabel alloc]init];
        _photoCountLable.font = [UIFont systemFontOfSize:14];
        _photoCountLable.textColor = [UIColor blackColor];
        _photoCountLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _photoCountLable;
}

- (UILabel *)grayLable
{
    if (_grayLable == nil)
    {
        _grayLable = [[UILabel alloc]init];
        _grayLable.backgroundColor = RGBA(235, 235, 241,1);
    }
    
    return _grayLable;
}

- (void)updateCellWithAssetCollection:(PHAssetCollection *)assetCollection
{
    //只加载图片
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *albumResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    //文件夹的名称
    NSString *title = [self getchineseAlbum:assetCollection.localizedTitle];
    
    //文件夹中的图片有多少张
    NSUInteger albumCount = albumResult.count;
    self.groupNameLable.text = [NSString stringWithFormat:@"%@",title];
    self.photoCountLable.text   = [NSString stringWithFormat:@"%ld 张照片", (long)albumCount];

    //取出文件夹中的第一张图片作为文件夹的显示图片
    PHAsset *firstAsset = [albumResult firstObject];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    [imageManager requestImageForAsset:firstAsset targetSize:CGSizeMake(160, 160) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
     {
         self.homeImageView.image = result;
     }];
    

}

/**
 把英文的文件夹名称转换为中文
 */
- (NSString *)getchineseAlbum:(NSString *)name
{
    NSString *newName;
    
    if ([name rangeOfString:@"Roll"].location != NSNotFound)         newName = @"相机胶卷";
    else if ([name rangeOfString:@"Stream"].location != NSNotFound)  newName = @"我的照片流";
    else if ([name rangeOfString:@"Added"].location != NSNotFound)   newName = @"最近添加";
    else if ([name rangeOfString:@"Selfies"].location != NSNotFound) newName = @"自拍";
    else if ([name rangeOfString:@"shots"].location != NSNotFound)   newName = @"截屏";
    else if ([name rangeOfString:@"Videos"].location != NSNotFound)  newName = @"视频";
    else if ([name rangeOfString:@"Panoramas"].location != NSNotFound)  newName = @"全景照片";
    else if ([name rangeOfString:@"Favorites"].location != NSNotFound)  newName = @"个人收藏";
    else if ([name rangeOfString:@"All Photos"].location != NSNotFound)  newName = @"所有照片";
    else newName = name;
    return newName;
}


@end
