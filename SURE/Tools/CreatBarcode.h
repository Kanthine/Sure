//
//  CreatBarcode.h
//  SURE
//
//  Created by 王玉龙 on 17/2/20.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatBarcode : NSObject

/**
 *  生成一张普通的二维码
 *
 *  @param dataString    传入你要生成二维码的数据
 */
+ (UIImage *)creatNormalScanLifeWithDataString:(NSString *)dataString;




/**
 *  生成一张带有logo的二维码
 *
 *  @param dataString    传入你要生成二维码的数据
 *  @param logoImage    logo的image名
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)creatLogoScanLifeWithDataString:(NSString *)dataString LogoImage:(UIImage *)logoImage LogoScaleToSuperView:(CGFloat)logoScaleToSuperView;



/**
 *  生成一张彩色的二维码
 *
 *  @param dataString    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)creatColoursScanLifeWithDataString:(NSString *)dataString BackgroundColor:(CIColor *)backgroundColor MainColor:(CIColor *)mainColor;


@end
