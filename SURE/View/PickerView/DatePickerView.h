//
//  DatePickerView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
    DatePickerLocationTypeBottom,
    DatePickerLocationTypeCenter,
}   DatePickerLocationType;

typedef void (^DataTimeSelect)(NSDate *selectDataTime);

@interface DatePickerView : UIView


/** DatePickerLocationType */
@property (nonatomic, assign) DatePickerLocationType datePickerType;
/** 当前选中的Date */
@property (nonatomic, strong) NSDate *selectDate;
/** 是否可选择当前时间之前的时间, 默认为NO */
@property (nonatomic, strong) NSDate *currentDate;
/** DatePickerMode, 默认是DateAndTime */
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime;
- (void)show;

@property (nonatomic, strong) NSDate *maxSelectDate;
/** 优先级低于isBeforeTime */
@property (nonatomic, strong) NSDate *minSelectDate;

@end
