//
//  HandleResultView.h
//  SURE
//
//  Created by 王玉龙 on 17/1/9.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandleResultView : UIView

- (instancetype)initWithIsFinish:(BOOL)isFinish Title:(NSString *)title;

- (void)showToSuperView:(UIView *)superView;

@end
