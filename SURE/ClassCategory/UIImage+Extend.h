//
//  UIImage+Extend.h
//  SURE
//
//  Created by 王玉龙 on 16/10/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

#pragma mark - 导航栏

+ (UIImage *)loadNavBarBackgroundImage;

- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage*)createImageWithColor:(UIColor*)color;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

- (UIImage *)scaleToSize916;


#pragma mark - 切 三角

- (UIImage * )cropImageWithRect:(CGSize)size HeightScale:(CGFloat)scale;


#pragma mark - 拍照
- (UIImage *)cropCameraImage;

- (UIImage *)fixOrientation;

/*
 *压缩照片至指定字节
 */
- (UIImage *)compressToMaxDataSizeKBytes:(CGFloat)size;

@end
