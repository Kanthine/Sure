//
//  AccountInfo.h
//
//  Created by   on 16/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AccountInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *uToken;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, assign) id passwdQuestion;
@property (nonatomic, strong) NSString *visitCount;
@property (nonatomic, strong) NSString *isSpecial;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *creditLine;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *isSurplusOpen;
@property (nonatomic, strong) NSString *userMoney;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *backCard;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *validated;
@property (nonatomic, strong) NSString *frozenMoney;
@property (nonatomic, strong) NSString *froms;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *mediaUID;
@property (nonatomic, strong) NSString *homePhone;
@property (nonatomic, strong) NSString *surplusPassword;
@property (nonatomic, strong) NSString *userRank;
@property (nonatomic, strong) NSString *rankPoints;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *msn;
@property (nonatomic, strong) NSString *ecSalt;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *isValidated;
@property (nonatomic, strong) NSString *card;
@property (nonatomic, strong) NSString *payPoints;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, assign) id passwdAnswer;
@property (nonatomic, strong) NSString *lastIp;
@property (nonatomic, strong) NSString *aiteId;
@property (nonatomic, strong) NSString *officePhone;
@property (nonatomic, strong) NSString *mediaID;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *headimg;//头像
@property (nonatomic, strong) NSString *lastTime;
@property (nonatomic, strong) NSString *isFenxiao;//是否是签约用户
@property (nonatomic, strong) NSString *faceCard;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *regTime;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *realName;//个性签名
@property (nonatomic, strong) NSString *lastLogin;

+ (AccountInfo *)standardAccountInfo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (void)parserDataWithDictionary:(NSDictionary *)dict;


- (NSDictionary *)dictionaryRepresentation;

- (void)storeAccountInfo;

- (BOOL)logoutAccount;//销毁

@end
