//
//  EditImageModel.h
//  SURE
//
//  Created by 王玉龙 on 16/11/2.
//  Copyright © 2016年 longlong. All rights reserved.
//

//标签数组 字典的键
#define WidthRateKey @"widthRate"
#define HeightRateKey @"heightRate"
#define TagTitle      @"tagTitle"




#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EditImageModelType)
{
    EditImageModelTypeVideo = 0,
    EditImageModelTypePhoto,
};

@interface EditImageModel : NSObject

@property (nonatomic,assign) EditImageModelType modelType;


@property (nonatomic ,strong) UIImage *originalImage;//原图
@property (nonatomic ,strong) UIImage *thumbnailImage;//缩略图

@property (nonatomic ,strong) NSURL *resourceURL;
@property (nonatomic ,strong) NSURL *filerVideoURL;

//@property (nonatomic ,copy) NSString *filePathString;//地址
//@property (nonatomic ,copy) NSString *filerVideoPathString;//滤镜后的视频地址

@property (nonatomic ,assign) BOOL isFiler;
@property (nonatomic ,assign) NSInteger filerIndex;
@property (nonatomic ,copy)   NSString *filerName;
@property (nonatomic ,strong) UIImage  *filerImage;//滤镜图片


@property (nonatomic ,assign) BOOL isAddTag;
@property (nonatomic ,strong) NSMutableArray *tagArray;//标签数组 存放字典




@end
