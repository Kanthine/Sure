//
//  DatePickerSheetView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerSheetView : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
/** 取消按钮的点击事件 */
- (void)addTargetCancelBtn:(id)target action:(SEL)action;
/** 确定按钮的点击事件 */
- (void)addTargetSureBtn:(id)target action:(SEL)action;

@end
