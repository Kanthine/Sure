//
//  LogisticsHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/29.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "LogisticsHeaderView.h"

@interface LogisticsHeaderView()
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@end

@implementation LogisticsHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _imageBackView.layer.borderColor = GrayColor.CGColor;
    _imageBackView.layer.borderWidth = 1;
    
    _phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _phoneButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [_phoneButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
}

@end
