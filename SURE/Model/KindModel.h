//
//  KindModel.h
//
//  Created by   on 17/1/16
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface KindModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *pathName;
@property (nonatomic, strong) NSString *showInNav;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *typeImg;
@property (nonatomic, strong) NSString *measureUnit;
@property (nonatomic, strong) NSString *categoryIndex;
@property (nonatomic, strong) NSString *catIndexRightad;
@property (nonatomic, strong) NSString *templateFile;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *isShow;
@property (nonatomic, strong) NSString *catId;
@property (nonatomic, strong) NSString *filterAttr;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *sortOrder;
@property (nonatomic, strong) NSString *categoryIndexDwt;
@property (nonatomic, strong) NSString *brandQq;
@property (nonatomic, strong) NSString *catName;
@property (nonatomic, strong) NSString *catDesc;
@property (nonatomic, strong) NSString *indexDwtFile;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *catAdurl1;
@property (nonatomic, strong) NSString *catAdurl2;
@property (nonatomic, strong) NSString *showInIndex;
@property (nonatomic, strong) NSString *catNameimg;
@property (nonatomic, strong) NSString *showGoodsNum;
@property (nonatomic, strong) NSString *attrWwwecshop68com;
@property (nonatomic, strong) NSString *catAdimg2;
@property (nonatomic, strong) NSString *catAdimg1;
@property (nonatomic, strong) NSString *isVirtual;


@property (nonatomic, strong) NSMutableArray *nextLevelListArray;

/*
 * 添加标签时 section展开
 */
@property (nonatomic ,assign) BOOL isFolded;


+ (NSMutableArray *)modelListWithArray:(NSArray *)array;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
