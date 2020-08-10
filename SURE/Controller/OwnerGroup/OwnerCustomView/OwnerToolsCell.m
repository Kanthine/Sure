//
//  OwnerToolsCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OwnerToolsCell.h"
#import "OwnerCustomButton.h"

@interface OwnerToolsCell()
<OwnerCustomButtonDelegate>

@end


@implementation OwnerToolsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat buttonWidth = ScreenWidth / 4.0f;
        NSMutableArray *toolBoxTitleArray = [NSMutableArray arrayWithObjects:@"收藏品牌",@"收藏单品",@"SURE币",@"优惠券",nil];
        NSMutableArray *toolBoxImageTitleArray = [NSMutableArray arrayWithObjects:@"owner_CollectBrand", @"owner_CollectSingle", @"owner_SureBi",@"owner_CollectCoupon",@"owner_CollectIntegral", nil];
        for (int i = 0 ; i < toolBoxTitleArray.count; i ++)
        {
            OwnerCustomButton *button = [[OwnerCustomButton alloc]initWithFrame:CGRectMake( buttonWidth * i, 10, buttonWidth, 50) Title:toolBoxTitleArray[i] ImageTitle:toolBoxImageTitleArray[i]];
            if (i == 2)
            {
                button.titleLable.textColor = RGBA(230, 99, 220, 1);
            }
            button.delegate = self;
            button.index = 10 + i;
            [self addSubview:button];
        }

    }
    
    return self;
}

- (void)ownerCustomButtonClick:(NSInteger)index
{
    _ownerToolsCellButtonClick(index);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
