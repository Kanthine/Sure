//
//  OtherDetaileModel.h
//  SURE
//
//  Created by 王玉龙 on 17/1/3.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherDetaileModel : NSObject

@property (nonatomic ,copy) NSString *userName;
@property (nonatomic ,copy) NSString *userID;
@property (nonatomic ,copy) NSString *userHeader;
@property (nonatomic ,copy) NSString *userSignature;//个性签名
@property (nonatomic ,copy) NSString *isOption;//是否关注
@property (nonatomic ,copy) NSString *tapedCount;//被赞数
@property (nonatomic ,copy) NSString *fansCount;//粉丝数
@property (nonatomic ,copy) NSString *optionCount;//关注数
@property (nonatomic ,strong) NSMutableArray<SUREModel *> *sureListArray;//SURE
@property (nonatomic ,strong) NSMutableArray<SUREModel *> *tapSureListArray;//赞过的SURE
@property (nonatomic ,strong) NSMutableArray *tagBrandListArray;//Tag过的品牌

+ (OtherDetaileModel *)parserOtherDetaileModelWithDict:(NSDictionary *)dict;

@end
