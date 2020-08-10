//
//  OwnerOriginalCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OwnerOriginalCell.h"
#import <Masonry.h>

@implementation OwnerOriginalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.leftLable];
        [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.mas_equalTo(@0);
             make.left.mas_equalTo(@10);
             make.bottom.mas_equalTo(@0);
             make.top.mas_equalTo(@0);
         }];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)leftLable
{
    if (_leftLable == nil)
    {
        _leftLable = [[UILabel alloc]init];
        _leftLable.textColor = TextColorBlack;
        _leftLable.font = [UIFont systemFontOfSize:14];
    }
    
    return _leftLable;
}


@end
