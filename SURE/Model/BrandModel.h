//
//  BrandModel.h
//  SURE
//
//  Created by 王玉龙 on 16/10/28.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BrandDetaileModel;
@interface BrandListModel : NSObject

+ (NSMutableArray<BrandDetaileModel *> *)parserDataWithResultArray:(NSArray *)resultArray;


/*
 * 根据首字母排序
 *
 * 排序后得到一个数组 包含字典
 * NSDictionary ：
 * key Initials   首字母
 * key brandList  模型数组
 */
+ (NSMutableArray<NSDictionary *> *)bassInitialsSortWithArray:(NSMutableArray<BrandDetaileModel *> * )listArray;
@end



@interface BrandDetaileModel : NSObject

@property (nonatomic ,copy) NSString *listNameStr;
@property (nonatomic ,copy) NSString *listLogoUrlStr;


@property (nonatomic ,copy) NSString *brandNameStr;
@property (nonatomic ,copy) NSString *brandLogoUrlStr;
@property (nonatomic ,copy) NSString *brandIDStr;
@property (nonatomic ,strong) NSMutableArray *flashModelArray;
@property (nonatomic ,copy) NSString *is_show;
@property (nonatomic ,copy) NSString *sort_order;


@property (nonatomic ,assign) BOOL isAttention;

@property (nonatomic ,copy) NSString *brandIntroduceLogoUrlString;
@property (nonatomic ,copy) NSString *brandIntroduceString;

//首字母
@property (nonatomic ,copy) NSString *brandInitials;

+ (BrandDetaileModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary;

@end


@interface BrandDetaileFlashImage : NSObject

@property (nonatomic ,assign) BOOL isCanLink;
@property (nonatomic ,copy) NSString *imageUrlStr;
@property (nonatomic ,copy) NSString *imageLinkStr;


+ (NSMutableArray *)parserDataWithFlashArray:(NSArray *)imageArray;

@end
