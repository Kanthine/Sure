//
//  ScanBigPhotoScrollView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/18.
//  Copyright © 2016年 longlong. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol ScanBigPhotoScrollViewDelegate;


@interface ScanBigPhotoScrollView : UIScrollView


- (void)prepareForReuse;
- (void)displayImage:(UIImage *)image;

- (void)updateZoomScale:(CGFloat)newScale;
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;

@end
