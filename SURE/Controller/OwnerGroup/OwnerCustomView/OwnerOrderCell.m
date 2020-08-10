//
//  OwnerOrderCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OwnerOrderCell.h"
#import "OwnerCustomButton.h"

@interface OwnerOrderCell()
<OwnerCustomButtonDelegate>

@end

@implementation OwnerOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        CGFloat buttonWidth = ScreenWidth / 5.0f;
        NSMutableArray *orderTitleArray = [NSMutableArray arrayWithObjects:@"待付款",@"待发货",@"待收货",@"待SURE",@"退款/售后", nil];
        NSMutableArray *orderImageTitleArray = [NSMutableArray arrayWithObjects:@"owner_WaitPay", @"owner_WaitSendGoods", @"owner_WaitReceiveGoods",@"owner_WaitSure",@"owner_WaitRefund", nil];
        for (int i = 0 ; i < orderTitleArray.count; i ++)
        {
            OwnerCustomButton *button = [[OwnerCustomButton alloc]initWithFrame:CGRectMake( buttonWidth * i, 10 ,buttonWidth, 50) Title:orderTitleArray[i] ImageTitle:orderImageTitleArray[i]];
            button.index = 20 + i;
            button.delegate = self;
            [self addSubview:button];
        }
    }
    
    return self;
}

- (void)ownerCustomButtonClick:(NSInteger)index
{
    _ownerOrderCellButtonClick(index);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
