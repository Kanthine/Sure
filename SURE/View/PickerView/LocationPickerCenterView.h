//
//  LocationPickerCenterView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationPickerCenterView : UIView

/** pickerView */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

/** 取消按钮的点击事件 */
- (void)addTargetCancelBtn:(id)target action:(SEL)action;
/** 确定按钮的点击事件 */
- (void)addTargetSureBtn:(id)target action:(SEL)action;

@end
