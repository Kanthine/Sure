//
//  SacnBigImageView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/18.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SacnBigImageView : UIView

/*
 *imageArray 图片数组
 */
- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray<NSString *> *)imageArray CurrentIndex:(NSInteger)currentIndex;


- (void)displayPagingViewAtIndex:(NSInteger)index;

@end
