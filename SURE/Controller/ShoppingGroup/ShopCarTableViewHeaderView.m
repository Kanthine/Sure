//
//  ShopCarTableViewHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/25.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ShopCarTableViewHeaderView.h"

@implementation ShopCarTableViewHeaderView

- (IBAction)brandSelectedButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(brandSelected:)])
    {
        [self.delegate brandSelected:self];
    }
}

- (IBAction)brandEditButtonClick:(UIButton *)sender
{
    sender.selected = ! sender.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(brandEditingSelected:)])
    {
        [self.delegate brandEditingSelected:self];
    }
}

@end
