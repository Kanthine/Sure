//
//  BrandTagKindView.h
//  SURE
//
//  Created by 王玉龙 on 17/1/10.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandTagKindView : UIView

- (instancetype)initWithKindList:(NSMutableArray<KindModel *> *)kindArray;

- (void)showToSuperView:(UIView *)superView;


@property (nonatomic ,copy) void(^ didSelectBrandKind)(KindModel *kindModel);

@end
