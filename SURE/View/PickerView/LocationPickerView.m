//
//  LocationPickerView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "LocationPickerView.h"


#import "LocationPickerSheetView.h"
#import "LocationPickerCenterView.h"

#import "AdressListLocalization.h"

#define ComponentTotal 3
#define ColumnWidth (ScreenWidth / (ComponentTotal * 1.000) )

#define LocationPickerSheetViewHeight ScreenHeight * 0.42
#define LocationPickerCenterViewHeight ScreenHeight * 0.45


@interface LocationPickerView ()
<UIPickerViewDelegate, UIPickerViewDataSource>
/** LocationPickerSheetView对象 */
@property (nonatomic, strong) LocationPickerSheetView *locationPickerSheetView;
/** LocationPickerCenterView对象 */
@property (nonatomic, strong) LocationPickerCenterView *locationPickerCenterView;

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverView;
// data
//@property (strong, nonatomic) NSDictionary *pickerDic;
/** 省份 */
@property (strong, nonatomic) NSArray *province_Arr;
/** 城市 */
@property (strong, nonatomic) NSArray *city_Arr;
/** 区，县 */
@property (strong, nonatomic) NSArray *area_Arr;
/** 选择的数据 */
@property (strong, nonatomic) NSArray *selected_Arr;

@end

@implementation LocationPickerView
/** SGLocationPickerCenterView距离X轴的距离 */
static CGFloat const margin_column_X = 15;
/** 动画时间 */
static CGFloat const AnimationDuration = 0.2;

- (instancetype)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight); // 设置self的frame， 若没有设置button的点击事件不响应（想要响应button的点击事件， 其父视图必须有frame且大于button）
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        self.pickerViewType = LocationPickerViewTypeBottom;
        
        // 遮盖
        self.coverView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.0;
        [_coverView addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        _coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self addSubview:self.coverView];
        
        // 获取数据
        [self getLocationDateSourse];
        
    }
    return self;
}

#pragma mark - - - 按钮的点击事件
- (void)sureBtnClick
{
    if (self.pickerViewType == LocationPickerViewTypeCenter)
    {

        
        NSDictionary *provinceDict = [self.province_Arr objectAtIndex:[self.locationPickerCenterView.pickerView selectedRowInComponent:0]];
        NSDictionary *cityDict = [self.city_Arr objectAtIndex:[self.locationPickerCenterView.pickerView selectedRowInComponent:1]];
        
        //有些城市 三级列表为空
        NSDictionary *areaDict ;
        if (self.area_Arr && self.area_Arr.count > 0)
        {
           areaDict = [self.area_Arr objectAtIndex:[self.locationPickerCenterView.pickerView selectedRowInComponent:2]];
        }
        
        
        
        self.locationMessage(provinceDict,cityDict,areaDict);
    }
    else
    {
        
        NSDictionary *provinceDict = [self.province_Arr objectAtIndex:[self.locationPickerSheetView.pickerView selectedRowInComponent:0]];
        NSDictionary *cityDict = [self.city_Arr objectAtIndex:[self.locationPickerSheetView.pickerView selectedRowInComponent:1]];
        
        NSDictionary *areaDict ;
        if (self.area_Arr && self.area_Arr.count > 0)
        {
            areaDict = [self.area_Arr objectAtIndex:[self.locationPickerSheetView.pickerView selectedRowInComponent:2]];
        }
        
        self.locationMessage(provinceDict,cityDict,areaDict);
        
    }
    
    [self dismissPickerView];
}

// 消失
- (void)dismissPickerView {
    if (self.pickerViewType == LocationPickerViewTypeCenter) {
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    } else {
        [UIView animateWithDuration:AnimationDuration animations:^
         {
             self.locationPickerSheetView.transform = CGAffineTransformMakeTranslation(0, LocationPickerSheetViewHeight);
             self.coverView.alpha = 0.0;
         } completion:^(BOOL finished) {
             [self.locationPickerSheetView removeFromSuperview];
             [self.coverView removeFromSuperview];
             [self removeFromSuperview];
         }];
    }
}

// 出现
- (void)show
{
    if (self.pickerViewType == LocationPickerViewTypeCenter)
    {
        [self setupSGLocationPickerCenterView];
        [self animationWithView:self.locationPickerCenterView duration:0.3];
        [UIView animateWithDuration:AnimationDuration animations:^{
            self.coverView.alpha = 0.3;
        }];
    }
    else
    {
        // LocationPickerSheetView
        [self setupSGLocationPickerSheetView];
        
        [UIView animateWithDuration:AnimationDuration animations:^
         {
             self.locationPickerSheetView.transform = CGAffineTransformMakeTranslation(0, - LocationPickerSheetViewHeight);
             self.coverView.alpha = 0.3;
         }];
    }
}

- (void)setupSGLocationPickerSheetView
{
    self.locationPickerSheetView = [[[NSBundle mainBundle] loadNibNamed:@"LocationPickerSheetView" owner:nil options:nil] firstObject];
    _locationPickerSheetView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, LocationPickerSheetViewHeight);
    _locationPickerSheetView.pickerView.delegate = self;
    _locationPickerSheetView.pickerView.dataSource = self;
    [_locationPickerSheetView addTargetCancelBtn:self action:@selector(dismissPickerView)];
    [_locationPickerSheetView addTargetSureBtn:self action:@selector(sureBtnClick)];
    [self addSubview:_locationPickerSheetView];
}

- (void)setupSGLocationPickerCenterView {
    [self.locationPickerCenterView removeFromSuperview];
    
    CGFloat pickerCenterView_X = margin_column_X;
    CGFloat pickerCenterView_Y = (ScreenHeight - LocationPickerCenterViewHeight) * 0.5;
    CGFloat pickerCenterView_W = ScreenWidth - 2 * pickerCenterView_X;
    self.locationPickerCenterView = [[[NSBundle mainBundle] loadNibNamed:@"LocationPickerCenterView" owner:nil options:nil] firstObject];
    _locationPickerCenterView.frame = CGRectMake(pickerCenterView_X, pickerCenterView_Y, pickerCenterView_W, LocationPickerCenterViewHeight);
    _locationPickerCenterView.layer.cornerRadius = 7;
    _locationPickerCenterView.layer.masksToBounds = YES;
    _locationPickerCenterView.pickerView.delegate = self;
    _locationPickerCenterView.pickerView.dataSource = self;
    [_locationPickerCenterView addTargetCancelBtn:self action:@selector(dismissPickerView)];
    [_locationPickerCenterView addTargetSureBtn:self action:@selector(sureBtnClick)];
    [self addSubview:_locationPickerCenterView];
}

/** LocationPickerCenterView弹出样式 */
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

- (void)scroToCurrentLocationWithProvence:(NSString *)provenceIDStr City:(NSString *)cityIDStr Area:(NSString *)areaIDStr
{
    __block NSInteger first;
    __block NSInteger second;
    __block NSInteger three;
    
    

    
    
    [self.province_Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         if ([provenceIDStr isEqualToString:[obj objectForKey:@"region_id"]])
         {
             first = idx;
             self.selected_Arr = [self.province_Arr[idx] objectForKey:@"childArray"];//城市列表
             
             if (self.selected_Arr.count > 0)
             {
                 
                 self.city_Arr = self.selected_Arr ;
             }
             
             
             
             NSArray *cityArray = [obj objectForKey:@"childArray"];
             [cityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 
                 if ([cityIDStr isEqualToString:[obj objectForKey:@"region_id"]])
                 {
                     second = idx;
                     
                     
                     if (self.city_Arr.count > 0)
                     {
                         
                         NSDictionary *cityDict = [self.selected_Arr objectAtIndex:idx] ;
                         self.area_Arr = [cityDict objectForKey:@"childArray"];
                     }

                     
                     NSArray *areaArray = [obj objectForKey:@"childArray"];
                     [areaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                      {
                          if ([areaIDStr isEqualToString:[obj objectForKey:@"region_id"]])
                          {
                              three = idx;
                              
                              * stop = YES;
                          }
                      }];
                     
                     
                     
                     * stop = YES;
                 }
                 
             }];
             
             
             
             * stop = YES;
         }
         
         
    }];
    
    
    
    
    
    
    [self.locationPickerSheetView.pickerView selectRow:first inComponent:0 animated:YES];
    [self.locationPickerSheetView.pickerView selectRow:second inComponent:1 animated:YES];
    [self.locationPickerSheetView.pickerView selectRow:three inComponent:2 animated:YES];


    
}

#pragma mark - 获取地区数据

- (void)getLocationDateSourse
{
    NSString *filePath = [AdressListLocalization getCityListPath];
    
    self.province_Arr = [[NSArray alloc]initWithContentsOfFile:filePath];//省份列表
    self.selected_Arr = [self.province_Arr[0] objectForKey:@"childArray"];//城市列表
    
    if (self.selected_Arr.count > 0)
    {
        
        self.city_Arr = self.selected_Arr ;
    }
    
    if (self.city_Arr.count > 0)
    {
        
        NSDictionary *cityDict = [self.selected_Arr objectAtIndex:0] ;
        self.area_Arr = [cityDict objectForKey:@"childArray"];
    }
}

#pragma mark - - - UIPickerViewDataSource - UIPickerViewDelegate
// 返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return ComponentTotal;
}
// 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.province_Arr.count;
    }
    else if (component == 1)
    {
        return self.city_Arr.count;
    }
    else
    {
        return self.area_Arr.count;
    }
}

// 返回当前行的内容, 此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSDictionary *provinceDict = self.province_Arr[row];
        return [provinceDict objectForKey:@"region_name"];
    }
    else if (component == 1)
    {
        NSDictionary *cityDict = self.city_Arr[row];
        return [cityDict objectForKey:@"region_name"];
    }
    else
    {
        NSDictionary *areaDict = self.area_Arr[row];
        return [areaDict objectForKey:@"region_name"];
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return ColumnWidth - margin_column_X;
    }
    else if (component == 1)
    {
        return ColumnWidth;
    }
    else
    {
        return ColumnWidth - margin_column_X;
    }
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSDictionary *provinceDict = self.province_Arr[row];
        
        self.selected_Arr = [provinceDict objectForKey:@"childArray"];
        
        if (self.selected_Arr.count > 0)
        {
            
            self.city_Arr = self.selected_Arr;
        }
        else
        {
            self.city_Arr = nil;
        }
        
        if (self.city_Arr.count > 0)
        {
            NSDictionary *areaDict = self.selected_Arr[0];

            self.area_Arr = [areaDict objectForKey:@"childArray"];
            
        }
        else
        {
            self.area_Arr = nil;
        }
    }
    
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1]; // 刷新列数
    [pickerView selectedRowInComponent:2];
    
    if (component == 1)
    {
        if (self.selected_Arr.count > 0 && self.city_Arr.count > 0)
        {
            NSDictionary *areaDict = [self.city_Arr objectAtIndex:row];

            self.area_Arr = [areaDict objectForKey:@"childArray"];
        }
        else
        {
            self.area_Arr = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

/** 自定义component内容 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = nil;
    
    if (component == 0)
    {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ColumnWidth - margin_column_X, 30)];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *provinceDict = self.province_Arr[row];
         label.text =  [provinceDict objectForKey:@"region_name"];

        
        label.font = [UIFont systemFontOfSize:16];         //用label来设置字体大小
        
        label.backgroundColor = [UIColor clearColor];
        
    }else if (component == 1)
    {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ColumnWidth - margin_column_X, 30)];
        
        
        NSDictionary *cityDict = self.city_Arr[row];
        label.text = [cityDict objectForKey:@"region_name"];
        
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:16];
        
        label.backgroundColor = [UIColor clearColor];
    }
    else
    {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ColumnWidth - margin_column_X, 30)];
        
        
        NSDictionary *areaDict = self.area_Arr[row];
        label.text =  [areaDict objectForKey:@"region_name"];
        
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:16];
        
        label.backgroundColor = [UIColor clearColor];
        
    }
    return label;
}


@end


