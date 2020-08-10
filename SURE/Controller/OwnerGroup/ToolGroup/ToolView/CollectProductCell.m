//
//  CollectProductCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CollectProductCell.h"

#import "ShareViewController.h"
#import "CollectProductVC.h"

@interface CollectProductCell ()


{
    CollectProductModel *_product;
}

@end

@implementation CollectProductCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    
//    self.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellInfoWithProductModel:(CollectProductModel *)product
{
    _product = product;
    self.nameLable.text = product.productName;
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",product.productPrice];
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:product.imageStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    
    NSLog(@"imageStr ======= %@",product.imageStr);
}

- (IBAction)moreShareButtonClick:(UIButton *)button
{
    
    NSString *linkStr = @"http://www.cocoachina.com/ios/20170216/18693.html";
    NSString *imageStr = _product.imageStr;
    NSString *descr = _product.productName;
    
    
    ShareViewController *shareVC = [[ShareViewController alloc]initWithLinkUrl:linkStr imageUrlStr:imageStr Descr:descr];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [_currentVC presentViewController:shareVC animated:NO completion:^
     {
         [shareVC showPlatView];
     }];
}

@end
