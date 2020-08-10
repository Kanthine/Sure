//
//  ScanLifeCoverView.h
//  SURE
//
//  Created by 王玉龙 on 17/2/20.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanLifeCoverView : UIView

- (instancetype)initWithFrame:(CGRect)frame CropRect:(CGRect)cropRect;

- (void)startScanLifeAnimation;

- (void)stopScanLifeAnimation;

@end
