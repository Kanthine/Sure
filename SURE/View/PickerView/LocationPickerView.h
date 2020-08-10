//
//  LocationPickerView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LocationPickerViewTypeBottom,
    LocationPickerViewTypeCenter,
} LocationPickerViewType;

typedef void(^MyBlock)(NSDictionary *ProvenceDict,NSDictionary *cityDict,NSDictionary *areaDict);

@interface LocationPickerView : UIView
/** LocationPickerViewType */
@property (nonatomic, assign) LocationPickerViewType pickerViewType;
/** 用于传值 */
@property (copy, nonatomic) MyBlock locationMessage;

//滚动指定位置
- (void)scroToCurrentLocationWithProvence:(NSString *)provenceIDStr City:(NSString *)cityIDStr Area:(NSString *)areaIDStr;

- (void)show;

@end

/*
 {
 "parent_id" : "104",
 "agency_id" : "0",
 "region_id" : "922",
 "region_name" : "巴马",
 "region_type" : "3"
 },
 */

