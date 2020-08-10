//
//  OwnerSignCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OwnerSignCell.h"

@implementation OwnerSignCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)awardButtonClick:(UIButton *)sender
{
    _ownerSignCellButtonClick(40);
}

- (IBAction)sellMoneyButtonClick:(UIButton *)sender
{
    _ownerSignCellButtonClick(41);
}

@end
