//
//  LocationPickerSheetView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "LocationPickerSheetView.h"

@interface LocationPickerSheetView ()
/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/** 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation LocationPickerSheetView

/** 取消按钮的点击事件 */
- (void)addTargetCancelBtn:(id)target action:(SEL)action {
    [self.cancelBtn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

/** 确定按钮的点击事件 */
- (void)addTargetSureBtn:(id)target action:(SEL)action {
    [self.sureBtn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

@end

