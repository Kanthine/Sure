//
//  VideoPregressBar.h
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VideoPregressBarStyleNormal,//正藏
    VideoPregressBarStyleDelete,//删除时 红色
} VideoPregressBarStyle;

@interface VideoPregressBar : UIView


+ (VideoPregressBar *)getInstance;

- (void)setLastProgressToStyle:(VideoPregressBarStyle)style;
- (void)setLastProgressToWidth:(CGFloat)width;

- (void)deleteLastProgress;
- (void)addProgressView;

- (void)stopShining;
- (void)startShining;

@end
