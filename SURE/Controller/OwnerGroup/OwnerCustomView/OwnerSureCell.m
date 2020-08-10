//
//  OwnerSureCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OwnerSureCell.h"
#import "OwnerCustomButton.h"

@interface OwnerSureCell()
<OwnerCustomButtonDelegate>

@end

@implementation OwnerSureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat buttonWidth = ScreenWidth / 3.0f;
        NSMutableArray *sureTitleArray = [NSMutableArray arrayWithObjects:@"我的SURE",@"我赞过的SURE",@"我Tag过的品牌",nil];
        NSMutableArray *toolBoxImageTitleArray = [NSMutableArray arrayWithObjects:@"tabBar_Owner", @"TapSupportNo", @"owner_Tag", nil];
        for (int i = 0 ; i < sureTitleArray.count; i ++)
        {
            OwnerCustomButton *button = [[OwnerCustomButton alloc]initWithFrame:CGRectMake( buttonWidth * i, 10, buttonWidth, 50) Title:sureTitleArray[i] ImageTitle:toolBoxImageTitleArray[i]];
            button.index = 30 + i;
            button.delegate = self;
            [self addSubview:button];
        }
    }
    
    return self;
}

- (void)ownerCustomButtonClick:(NSInteger)index
{
    _ownerSuresCellButtonClick(index);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
