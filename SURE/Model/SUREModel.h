//
//  SUREModel.h
//
//  Created by   on 16/12/9
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SURETapModel : NSObject

@property (nonatomic, copy) NSString *isTap;
@property (nonatomic, copy) NSString *tapCount;
@property (nonatomic, strong) NSMutableArray  *tapHeaderArray;

- (instancetype)initWithTapCount:(NSString *)tapCount HeaderArray:(NSArray *)imageArray IsTap:(NSString *)isTap;

@end








@class SUREFileModel;
@interface SUREModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *hit;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *inputtime;
@property (nonatomic, strong) NSString *imglist;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *sureBody;//文字部分
@property (nonatomic, strong) NSMutableArray<SUREFileModel *> *imglistModelArray;

@property (nonatomic ,strong) NSString *sureName;
@property (nonatomic ,strong) NSString *sureHeader;


// 点赞
@property (nonatomic ,strong) NSString *isOption;
@property (nonatomic ,strong) NSString *optionCount;
@property (nonatomic ,strong) NSArray *follerArray;
@property (nonatomic ,strong) SURETapModel *tapModel;




//isfollow : 0
//follor_user : [Array]
//user_name : 我的昵称是r s
//user_head : http://fruitsimage.qiniudn.com/1479553652.png






+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end


@interface SUREFileModel : NSObject

@property (nonatomic ,assign) BOOL isImage;
@property (nonatomic ,copy) NSString *urlString;
@property (nonatomic ,copy) NSString *videoLocalityPathString;
@property (nonatomic ,strong) NSArray<NSDictionary *> *tagArray;



+ (NSMutableArray *)parserDataWithDictionary:(NSDictionary *)jsonDict;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

@end
