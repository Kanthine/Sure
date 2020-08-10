//
//  DatePickerSheetView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "DatePickerSheetView.h"

@interface DatePickerSheetView ()
/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/** 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end


@implementation DatePickerSheetView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    // 设置时区
    [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
    // 设置当前显示时间
    [_datePicker setDate:[NSDate date] animated:YES];
}


/** 取消按钮的点击事件 */
- (void)addTargetCancelBtn:(id)target action:(SEL)action {
    [self.cancelBtn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

/** 确定按钮的点击事件 */
- (void)addTargetSureBtn:(id)target action:(SEL)action {
    [self.sureBtn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

@end
