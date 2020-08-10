//
//  DatePickerView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "DatePickerView.h"

#import "DatePickerSheetView.h"
#import "DatePickerCenterView.h"

#define PickerSheetViewHeight 250   
//ScreenHeight * 0.42
#define PickerCenterViewHeight ScreenHeight * 0.45

@interface DatePickerView ()
/** DatePickerCenterView对象 */
@property (nonatomic, strong) DatePickerCenterView *datePickerCenterView;
/** DatePickerSheetView对象 */
@property (nonatomic, strong) DatePickerSheetView *datePickerSheetView;
/** 遮盖 */
@property (nonatomic, strong) UIButton *coverView;
@property (nonatomic, copy) DataTimeSelect selectBlock;

@end

@implementation DatePickerView


/** DatePickerCenterView距离X轴的距离 */
static CGFloat const margin_column_X = 15;
/** 动画时间 */
static CGFloat const AnimationDuration = 0.2;

- (instancetype)init
{
    
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight); // 设置self的frame， 若没有设置button的点击事件不响应（想要响应button的点击事件， 其父视图必须有frame且大于button）
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        //默认底部显示
        self.datePickerType = DatePickerLocationTypeBottom;
        
        // 遮盖
        self.coverView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.0;
        [_coverView addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        _coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self addSubview:self.coverView];
        
        // DatePickerSheetView
        [self setupDatePickerSheetView];
        
    }
    return self;
}

#pragma mark - - - 按钮的点击事件
- (void)sureBtnClick
{
    if (_selectBlock)
    {
        _selectBlock(_selectDate);
    }
    [self dismissPickerView];
}

//DatePicker值改变
- (void)datePickerValueChange:(id)sender
{
    _selectDate = [sender date];
}


// 消失
- (void)dismissPickerView
{
    if (self.datePickerType == DatePickerLocationTypeCenter)
    {
        [self.datePickerCenterView removeFromSuperview];
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    } else
    {
        [UIView animateWithDuration:AnimationDuration animations:^
        {
            self.datePickerSheetView.transform = CGAffineTransformMakeTranslation(0, PickerSheetViewHeight);
            self.coverView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.datePickerSheetView removeFromSuperview];
            [self.coverView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

// 出现
- (void)show
{
    if (self.datePickerType == DatePickerLocationTypeCenter)
    {
        self.coverView.alpha = 0.3;
        
    }
    else
    {
        
        [UIView animateWithDuration:AnimationDuration animations:^
        {
            self.datePickerSheetView.transform = CGAffineTransformMakeTranslation(0,  -PickerSheetViewHeight);
            self.coverView.alpha = 0.3;
        }];
    }
}

- (void)setupDatePickerSheetView
{
    self.datePickerSheetView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerSheetView" owner:nil options:nil] firstObject];
    
    _datePickerSheetView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PickerSheetViewHeight);
    
    [_datePickerSheetView addTargetCancelBtn:self action:@selector(dismissPickerView)];
    [_datePickerSheetView addTargetSureBtn:self action:@selector(sureBtnClick)];
    
    [_datePickerSheetView.datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    
    //DatePicker属性设置
    _selectDate = [[NSDate alloc] init];
    _datePickerSheetView.datePicker.date = _selectDate;
//    _datePickerSheetView.datePicker.minimumDate = _selectDate;
    
    _datePickerSheetView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self addSubview:_datePickerSheetView];
}

- (void)setupDatePickerCenterView
{
    [self.datePickerSheetView removeFromSuperview];
    
    self.datePickerCenterView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerCenterView" owner:nil options:nil] firstObject];
    
    CGFloat pickerCenterViewX = margin_column_X;
    CGFloat pickerCenterViewY = (ScreenHeight - PickerCenterViewHeight) * 0.5;
    
    _datePickerCenterView.frame = CGRectMake(pickerCenterViewX, pickerCenterViewY, ScreenWidth - 2 * pickerCenterViewX, PickerCenterViewHeight);
    _datePickerCenterView.layer.cornerRadius = 7;
    _datePickerCenterView.layer.masksToBounds = YES;
    [_datePickerCenterView addTargetCancelBtn:self action:@selector(dismissPickerView)];
    [_datePickerCenterView addTargetSureBtn:self action:@selector(sureBtnClick)];
    [_datePickerCenterView.datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    //DatePicker属性设置
    _selectDate = [[NSDate alloc] init];
    _datePickerCenterView.datePicker.date = _selectDate;
//    _datePickerCenterView.datePicker.minimumDate = _selectDate;
    _datePickerCenterView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self addSubview:_datePickerCenterView];
    
    [self animationWithView:self.datePickerCenterView duration:0.3];
    
}




/** DatePickerCenterView弹出样式 */
- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values_Arr = [NSMutableArray array];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values_Arr addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values_Arr;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [view.layer addAnimation:animation forKey:nil];
}



#pragma mark - - - setter
- (void)setSelectDate:(NSDate *)selectDate
{
    _selectDate = selectDate;
    if (self.datePickerType == DatePickerLocationTypeCenter)
    {
        if (selectDate)
        {
            _datePickerCenterView.datePicker.date = selectDate;
        }
    } else {
        if (selectDate) {
            _datePickerSheetView.datePicker.date = selectDate;
        }
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    if (self.datePickerType == DatePickerLocationTypeCenter) {
        _datePickerCenterView.datePicker.datePickerMode = datePickerMode;
    } else {
        _datePickerSheetView.datePicker.datePickerMode = datePickerMode;
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    
    if (self.datePickerType == DatePickerLocationTypeCenter)
    {
        if (currentDate)
        {
            _datePickerCenterView.datePicker.date = currentDate;
        }
        else
        {
            [_datePickerCenterView.datePicker setMinimumDate:[NSDate date]];
        }
        
    } else
    {
        if (currentDate)
        {
            _datePickerSheetView.datePicker.date = currentDate;
        }
        else
        {
            [_datePickerSheetView.datePicker setMinimumDate:[NSDate date]];
        }
    }
}


- (void)setMinSelectDate:(NSDate *)minSelectDate {
    if (self.datePickerType == DatePickerLocationTypeCenter) {
        if (minSelectDate) {
            [_datePickerCenterView.datePicker setMinimumDate:minSelectDate];
        }
    } else {
        if (minSelectDate) {
            [_datePickerSheetView.datePicker setMinimumDate:minSelectDate];
        }
    }
}

- (void)setMaxSelectDate:(NSDate *)maxSelectDate
{
    if (self.datePickerType == DatePickerLocationTypeCenter)
    {
        if (maxSelectDate)
        {
            [_datePickerCenterView.datePicker setMaximumDate:maxSelectDate];
        }
    }
    else
    {
        if (maxSelectDate)
        {
            [_datePickerSheetView.datePicker setMaximumDate:maxSelectDate];
        }
    }
}

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime
{
    _selectBlock = selectDataTime;
}

- (void)setDatePickerType:(DatePickerLocationType)datePickerType
{
    if (self.datePickerType == DatePickerLocationTypeCenter)
    {
        [self setupDatePickerCenterView];
    }
}



@end
