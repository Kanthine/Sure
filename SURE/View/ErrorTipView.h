//
//  ErrorTipView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorTipView : UIView

- (instancetype)initWithTipString:(NSString *)string frame:(CGRect)frame;

- (void)showInView:(UIView *)superView ShowDuration:(CGFloat)interval;

@end
