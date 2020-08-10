//
//  TapSupportView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapSupportView : UIView

@property (nonatomic ,assign) BOOL isSupport;
@property (nonatomic ,assign) NSInteger supportSum;
@property (nonatomic ,strong) NSMutableArray *headerImageArray;

@end
