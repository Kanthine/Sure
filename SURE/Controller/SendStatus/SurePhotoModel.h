//
//  SurePhotoModel.h
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

//标签数组 字典的键
#define ImageWidthRateKey @"widthRate"
#define ImageHeightRateKey @"heightRate"
#define ImageBrandTitle    @"tagTitle"
#define ImageBrandCount    @"tagIndex"
#define ImageGoodID    @"goodsId"
#define ImageBrandID    @"brandId"


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger ,SureModelType)
{
    SureModelTypePhoto = 0,
    SureModelTypeVideo
};


@interface SurePhotoModel : NSObject

@property (nonatomic ,assign) SureModelType modelType;

@property (nonatomic ,strong) UIImage *originalImage;

@property (nonatomic ,strong) UIImage *filerImage;

@property (nonatomic ,strong) NSURL *albumURL;//图片相册地址或者视频本地地址
@property (nonatomic ,copy) NSString *pathString;//图片本地地址


@property (nonatomic ,strong) NSMutableArray <NSDictionary *> *brandTagArray;


/*
 * 压缩文件大小
 */
- (void)compressOriginalImageLength;
/*
 *资源存储至本地
 */
- (void)surePhotoModellocalization;

@end
