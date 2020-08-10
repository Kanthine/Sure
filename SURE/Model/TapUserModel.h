//
//  TapUserModel.h
//  SURE
//
//  Created by 王玉龙 on 17/1/2.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TapUserModel : NSObject

@property (nonatomic ,copy) NSString *userName;
@property (nonatomic ,copy) NSString *userHeader;
@property (nonatomic ,copy) NSString *userID;
@property (nonatomic ,copy) NSString *isOptioned;

+ (TapUserModel *)parserTapUserModelWithDict:(NSDictionary *)dict;

+ (NSMutableArray *)parserTapUserListWithArray:(NSArray *)array;

@end




