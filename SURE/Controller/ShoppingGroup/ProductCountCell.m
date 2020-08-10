//
//  ProductCountCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ProductCountCell.h"

@implementation ProductCountCell

- (void)dealloc
{
    [self.countLable removeObserver:self forKeyPath:@"text"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
            [self.countLable addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:NULL];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)updateNumberButtonClick:(UIButton *)sender
{
    NSInteger number = [_countLable.text integerValue];
    if (sender.tag == 10)
    {
        //减
        
        if (number > 1)
        {
            number --;
        }
        
        
    }
    else if (sender.tag == 11)
    {
        //加
        number ++;
    }
    
    _countLable.text = [NSString stringWithFormat:@"%ld",number];
}

// 更新 商品数量
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    /*
     {
     kind = 1;
     new = 14;
     old = 13;
     }
     
     */
    NSString *newString =  [change objectForKey:@"new"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(observeCountLableValueChangeWithNewString:)])
    {
        [self.delegate observeCountLableValueChangeWithNewString:newString];
    }
    
}


@end
