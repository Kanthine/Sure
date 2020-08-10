//
//  AllPhotosCollectionCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AllPhotosCollectionCell.h"

@interface AllPhotosCollectionCell ()

@property (nonatomic, strong) UIImageView *assetImageView;

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation AllPhotosCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor whiteColor];
        UIImageView *assetimageView = [[UIImageView alloc] init];
        assetimageView.frame = self.bounds;
        self.assetImageView = assetimageView;
        [self.contentView addSubview:assetimageView];
        
        //def_picker  sel_picker
        UIButton *selectBtn = [[UIButton alloc] init];
        self.selectBtn = selectBtn;
        selectBtn.selected = NO;
        selectBtn.frame = CGRectMake(self.bounds.size.width-27, 0, 27, 27);
        [selectBtn setImage:[UIImage imageNamed:@"def_picker"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"sel_picker"] forState:UIControlStateSelected];
        [self.contentView addSubview:selectBtn];
    }
    return self;
}


- (void)setAssetImage:(UIImage *)assetImage
{
    _assetImage = assetImage;
    self.assetImageView.image = assetImage;
    self.assetImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.assetImageView.clipsToBounds = YES;
    
    self.selectBtn.tag = self.indexpath.item;
    //解决选中btn的复用
    self.selectBtn.selected = NO;
    for (int i = 0; i < self.selectArray.count; i++)
    {
        if ([@(self.selectBtn.tag) isEqualToNumber:self.selectArray[i]])
        {
            self.selectBtn.selected = YES;
        }
    }
    
}


@end
