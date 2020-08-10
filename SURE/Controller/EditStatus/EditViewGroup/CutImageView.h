//
//  CutImageView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
// https://github.com/3tinkers/TKImageView

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TKCropAreaCornerStyle)
{
    TKCropAreaCornerStyleRightAngle,
    TKCropAreaCornerStyleCircle
};


@interface CutImageView : UIView

@property (strong, nonatomic) UIImage *toCropImage;//要裁剪的图片
@property (assign, nonatomic) BOOL needScaleCrop;//决定是否需要缩放裁剪 滑动手势
@property (assign, nonatomic) BOOL showMidLines;//把中间的线扔掉的边界,从而得到平移手势时调整农作物种植面积比例为零。
@property (assign, nonatomic) BOOL showCrossLines;//显示作物领域的交叉线。
@property (assign, nonatomic) CGFloat cropAspectRatio;//方面retio你想作物图像,等于宽度/高度。
@property (strong, nonatomic) UIColor *cropAreaBorderLineColor;//边框线的颜色。
@property (assign, nonatomic) CGFloat cropAreaBorderLineWidth;//边框线的宽度。
@property (strong, nonatomic) UIColor *cropAreaCornerLineColor;//边角线的颜色。
@property (assign, nonatomic) CGFloat cropAreaCornerLineWidth;//角落区域的宽度,而不是在墙角线宽。
@property (assign, nonatomic) CGFloat cropAreaCornerWidth;//角落里的线宽。
@property (assign, nonatomic) CGFloat cropAreaCornerHeight;//角落里的高度。
@property (assign, nonatomic) CGFloat minSpace;//一个边境的角落之间的最小距离。
@property (assign, nonatomic) CGFloat cropAreaCrossLineWidth;//交叉线的宽度。
@property (strong, nonatomic) UIColor *cropAreaCrossLineColor;//交叉线的颜色。
@property (assign, nonatomic) CGFloat cropAreaMidLineWidth;//中间线的宽度。
@property (assign, nonatomic) CGFloat cropAreaMidLineHeight;//中间线的高度。
@property (strong, nonatomic) UIColor *cropAreaMidLineColor;//中间线的颜色。
@property (strong, nonatomic) UIColor *maskColor;//面具的观点总是透明的颜色黑色。
@property (assign, nonatomic) BOOL cornerBorderInImage;//是否图像内的角落边境。
@property (assign, nonatomic) CGFloat scaleFactor;
- (UIImage *)currentCroppedImage;//获取裁剪后的图片

@end
