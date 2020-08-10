//
//  PayOrderCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/23.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "PayOrderCell.h"

@implementation PayOrderCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
    }
    
    return self;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageWidth = 30.0;
    
    self.imageView.bounds =CGRectMake(0,0,imageWidth,imageWidth);
    self.imageView.frame =CGRectMake(10,10,imageWidth,imageWidth);
    self.imageView.contentMode =UIViewContentModeScaleAspectFit;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = imageWidth + 20;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = imageWidth + 20;
    self.detailTextLabel.frame = tmpFrame;
}
@end
