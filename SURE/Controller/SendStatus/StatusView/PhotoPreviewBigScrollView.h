//
//  PhotoPreviewBigScrollView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPreviewBigScrollView : UIScrollView


- (void)updateBrandTag:(NSMutableArray<NSDictionary *> *)brandTagArray;

- (void)prepareForReuse;
- (void)displayImage:(UIImage *)image;

- (void)updateZoomScale:(CGFloat)newScale;
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;

@end
