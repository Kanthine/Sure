//
//  AccountInfo.m
//
//  Created by   on 16/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "AccountInfo.h"


NSString *const kAccountInfoParentId = @"parent_id";
NSString *const kAccountInfoUToken = @"u_token";
NSString *const kAccountInfoUserId = @"user_id";
NSString *const kAccountInfoSex = @"sex";
NSString *const kAccountInfoProvince = @"province";
NSString *const kAccountInfoPasswdQuestion = @"passwd_question";
NSString *const kAccountInfoVisitCount = @"visit_count";
NSString *const kAccountInfoIsSpecial = @"is_special";
NSString *const kAccountInfoSalt = @"salt";
NSString *const kAccountInfoPassword = @"password";
NSString *const kAccountInfoAddressId = @"address_id";
NSString *const kAccountInfoCreditLine = @"credit_line";
NSString *const kAccountInfoStatus = @"status";
NSString *const kAccountInfoIsSurplusOpen = @"is_surplus_open";
NSString *const kAccountInfoUserMoney = @"user_money";
NSString *const kAccountInfoFlag = @"flag";
NSString *const kAccountInfoAddress = @"address";
NSString *const kAccountInfoBackCard = @"back_card";
NSString *const kAccountInfoAnswer = @"answer";
NSString *const kAccountInfoValidated = @"validated";
NSString *const kAccountInfoFrozenMoney = @"frozen_money";
NSString *const kAccountInfoFroms = @"froms";
NSString *const kAccountInfoQuestion = @"question";
NSString *const kAccountInfoMediaUID = @"mediaUID";
NSString *const kAccountInfoHomePhone = @"home_phone";
NSString *const kAccountInfoSurplusPassword = @"surplus_password";
NSString *const kAccountInfoUserRank = @"user_rank";
NSString *const kAccountInfoRankPoints = @"rank_points";
NSString *const kAccountInfoQq = @"qq";
NSString *const kAccountInfoCountry = @"country";
NSString *const kAccountInfoMsn = @"msn";
NSString *const kAccountInfoEcSalt = @"ec_salt";
NSString *const kAccountInfoEmail = @"email";
NSString *const kAccountInfoIsValidated = @"is_validated";
NSString *const kAccountInfoCard = @"card";
NSString *const kAccountInfoPayPoints = @"pay_points";
NSString *const kAccountInfoDistrict = @"district";
NSString *const kAccountInfoAlias = @"alias";
NSString *const kAccountInfoBirthday = @"birthday";
NSString *const kAccountInfoPasswdAnswer = @"passwd_answer";
NSString *const kAccountInfoLastIp = @"last_ip";
NSString *const kAccountInfoAiteId = @"aite_id";
NSString *const kAccountInfoOfficePhone = @"office_phone";
NSString *const kAccountInfoMediaID = @"mediaID";
NSString *const kAccountInfoNickname = @"nickname";
NSString *const kAccountInfoHeadimg = @"headimg";
NSString *const kAccountInfoLastTime = @"last_time";
NSString *const kAccountInfoIsFenxiao = @"is_fenxiao";
NSString *const kAccountInfoFaceCard = @"face_card";
NSString *const kAccountInfoMobilePhone = @"mobile_phone";
NSString *const kAccountInfoRegTime = @"reg_time";
NSString *const kAccountInfoUserName = @"user_name";
NSString *const kAccountInfoCity = @"city";
NSString *const kAccountInfoRealName = @"real_name";
NSString *const kAccountInfoLastLogin = @"last_login";


@interface AccountInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AccountInfo

@synthesize parentId = _parentId;
@synthesize uToken = _uToken;
@synthesize userId = _userId;
@synthesize sex = _sex;
@synthesize province = _province;
@synthesize passwdQuestion = _passwdQuestion;
@synthesize visitCount = _visitCount;
@synthesize isSpecial = _isSpecial;
@synthesize salt = _salt;
@synthesize password = _password;
@synthesize addressId = _addressId;
@synthesize creditLine = _creditLine;
@synthesize status = _status;
@synthesize isSurplusOpen = _isSurplusOpen;
@synthesize userMoney = _userMoney;
@synthesize flag = _flag;
@synthesize address = _address;
@synthesize backCard = _backCard;
@synthesize answer = _answer;
@synthesize validated = _validated;
@synthesize frozenMoney = _frozenMoney;
@synthesize froms = _froms;
@synthesize question = _question;
@synthesize mediaUID = _mediaUID;
@synthesize homePhone = _homePhone;
@synthesize surplusPassword = _surplusPassword;
@synthesize userRank = _userRank;
@synthesize rankPoints = _rankPoints;
@synthesize qq = _qq;
@synthesize country = _country;
@synthesize msn = _msn;
@synthesize ecSalt = _ecSalt;
@synthesize email = _email;
@synthesize isValidated = _isValidated;
@synthesize card = _card;
@synthesize payPoints = _payPoints;
@synthesize district = _district;
@synthesize alias = _alias;
@synthesize birthday = _birthday;
@synthesize passwdAnswer = _passwdAnswer;
@synthesize lastIp = _lastIp;
@synthesize aiteId = _aiteId;
@synthesize officePhone = _officePhone;
@synthesize mediaID = _mediaID;
@synthesize nickname = _nickname;
@synthesize headimg = _headimg;
@synthesize lastTime = _lastTime;
@synthesize isFenxiao = _isFenxiao;
@synthesize faceCard = _faceCard;
@synthesize mobilePhone = _mobilePhone;
@synthesize regTime = _regTime;
@synthesize userName = _userName;
@synthesize city = _city;
@synthesize realName = _realName;
@synthesize lastLogin = _lastLogin;



static  AccountInfo*user = nil;
static dispatch_once_t rootOnceToken;
+ (AccountInfo *)standardAccountInfo
{
    dispatch_once(&rootOnceToken, ^
                  {
                      user = [AccountInfo readAccountInfo];
                      if (user == nil)
                      {
                          user = [[AccountInfo alloc]init];
                      }
                  });
    
    return user;
}

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    AccountInfo *model = [AccountInfo standardAccountInfo];
    [model parserDataWithDictionary:dict];
    
    return [AccountInfo standardAccountInfo];
}

- (void)parserDataWithDictionary:(NSDictionary *)dict
{
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
            self.parentId = [self objectOrNilForKey:kAccountInfoParentId fromDictionary:dict];
            self.uToken = [self objectOrNilForKey:kAccountInfoUToken fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kAccountInfoUserId fromDictionary:dict];
            self.sex = [self objectOrNilForKey:kAccountInfoSex fromDictionary:dict];
            self.province = [self objectOrNilForKey:kAccountInfoProvince fromDictionary:dict];
            self.passwdQuestion = [self objectOrNilForKey:kAccountInfoPasswdQuestion fromDictionary:dict];
            self.visitCount = [self objectOrNilForKey:kAccountInfoVisitCount fromDictionary:dict];
            self.isSpecial = [self objectOrNilForKey:kAccountInfoIsSpecial fromDictionary:dict];
            self.salt = [self objectOrNilForKey:kAccountInfoSalt fromDictionary:dict];
            self.password = [self objectOrNilForKey:kAccountInfoPassword fromDictionary:dict];
            self.addressId = [self objectOrNilForKey:kAccountInfoAddressId fromDictionary:dict];
            self.creditLine = [self objectOrNilForKey:kAccountInfoCreditLine fromDictionary:dict];
            self.status = [self objectOrNilForKey:kAccountInfoStatus fromDictionary:dict];
            self.isSurplusOpen = [self objectOrNilForKey:kAccountInfoIsSurplusOpen fromDictionary:dict];
            self.userMoney = [self objectOrNilForKey:kAccountInfoUserMoney fromDictionary:dict];
            self.flag = [self objectOrNilForKey:kAccountInfoFlag fromDictionary:dict];
            self.address = [self objectOrNilForKey:kAccountInfoAddress fromDictionary:dict];
            self.backCard = [self objectOrNilForKey:kAccountInfoBackCard fromDictionary:dict];
            self.answer = [self objectOrNilForKey:kAccountInfoAnswer fromDictionary:dict];
            self.validated = [self objectOrNilForKey:kAccountInfoValidated fromDictionary:dict];
            self.frozenMoney = [self objectOrNilForKey:kAccountInfoFrozenMoney fromDictionary:dict];
            self.froms = [self objectOrNilForKey:kAccountInfoFroms fromDictionary:dict];
            self.question = [self objectOrNilForKey:kAccountInfoQuestion fromDictionary:dict];
            self.mediaUID = [self objectOrNilForKey:kAccountInfoMediaUID fromDictionary:dict];
            self.homePhone = [self objectOrNilForKey:kAccountInfoHomePhone fromDictionary:dict];
            self.surplusPassword = [self objectOrNilForKey:kAccountInfoSurplusPassword fromDictionary:dict];
            self.userRank = [self objectOrNilForKey:kAccountInfoUserRank fromDictionary:dict];
            self.rankPoints = [self objectOrNilForKey:kAccountInfoRankPoints fromDictionary:dict];
            self.qq = [self objectOrNilForKey:kAccountInfoQq fromDictionary:dict];
            self.country = [self objectOrNilForKey:kAccountInfoCountry fromDictionary:dict];
            self.msn = [self objectOrNilForKey:kAccountInfoMsn fromDictionary:dict];
            self.ecSalt = [self objectOrNilForKey:kAccountInfoEcSalt fromDictionary:dict];
            self.email = [self objectOrNilForKey:kAccountInfoEmail fromDictionary:dict];
            self.isValidated = [self objectOrNilForKey:kAccountInfoIsValidated fromDictionary:dict];
            self.card = [self objectOrNilForKey:kAccountInfoCard fromDictionary:dict];
            self.payPoints = [self objectOrNilForKey:kAccountInfoPayPoints fromDictionary:dict];
            self.district = [self objectOrNilForKey:kAccountInfoDistrict fromDictionary:dict];
            self.alias = [self objectOrNilForKey:kAccountInfoAlias fromDictionary:dict];
            self.birthday = [self objectOrNilForKey:kAccountInfoBirthday fromDictionary:dict];
            self.passwdAnswer = [self objectOrNilForKey:kAccountInfoPasswdAnswer fromDictionary:dict];
            self.lastIp = [self objectOrNilForKey:kAccountInfoLastIp fromDictionary:dict];
            self.aiteId = [self objectOrNilForKey:kAccountInfoAiteId fromDictionary:dict];
            self.officePhone = [self objectOrNilForKey:kAccountInfoOfficePhone fromDictionary:dict];
            self.mediaID = [self objectOrNilForKey:kAccountInfoMediaID fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kAccountInfoNickname fromDictionary:dict];
            self.headimg = [self objectOrNilForKey:kAccountInfoHeadimg fromDictionary:dict];
            self.lastTime = [self objectOrNilForKey:kAccountInfoLastTime fromDictionary:dict];
            self.isFenxiao = [self objectOrNilForKey:kAccountInfoIsFenxiao fromDictionary:dict];
            self.faceCard = [self objectOrNilForKey:kAccountInfoFaceCard fromDictionary:dict];
            self.mobilePhone = [self objectOrNilForKey:kAccountInfoMobilePhone fromDictionary:dict];
            self.regTime = [self objectOrNilForKey:kAccountInfoRegTime fromDictionary:dict];
            self.userName = [self objectOrNilForKey:kAccountInfoUserName fromDictionary:dict];
            self.city = [self objectOrNilForKey:kAccountInfoCity fromDictionary:dict];
            self.realName = [self objectOrNilForKey:kAccountInfoRealName fromDictionary:dict];
            self.lastLogin = [self objectOrNilForKey:kAccountInfoLastLogin fromDictionary:dict];

    }
}

+ (AccountInfo *)readAccountInfo
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[AccountInfo getFilePath]];
    
    // 2,创建一个反序列化器,把要读的数据 传给它,让它读数据
    NSKeyedUnarchiver *unrachiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    // 3,从反序列化器中解码出数组
    AccountInfo *account = (AccountInfo *) [unrachiver decodeObject];
    // 4 结束解码
    [unrachiver finishDecoding];
    
    return account;

}

- (void)storeAccountInfo
{
    //    把原本不能够直接写入到文件中的对象(_array)--->>编码成NSData--->writeToFile
    
    // 1,创建一个空的data(类似于一个袋子),用来让序列化器把 编码之后的data存放起来
    NSMutableData *data = [[NSMutableData alloc] init];
    
    // 2,创建一个序列化器,并且给它一个空的data,用来存放编码之后的数据
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // 3,把数组进行编码
    [archive encodeObject:[AccountInfo standardAccountInfo]];//encode 编码
    
    // 4,结束编码
    [archive finishEncoding];
    
//    NSLog(@"data  %@",data);
    
    // 5,把data写入文件
    [data writeToFile:[AccountInfo getFilePath] atomically:YES];
}

- (BOOL)logoutAccount
{
    NSFileManager *fmanager=[NSFileManager defaultManager];
    BOOL isSucceed = [fmanager removeItemAtPath:[AccountInfo getFilePath] error:nil];
    
    if (isSucceed)
    {
        //释放单利
        user = nil;
        rootOnceToken = 0l;
        //清除本地 收货地址
        [ShippingAddressModel deletaAllShippingAdress];
    }
    return isSucceed;
}

+ (NSString *)getFilePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/accountInfo.plist"];//Appending 添加 Component 成分 Directory目录;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.parentId forKey:kAccountInfoParentId];
    [mutableDict setValue:self.uToken forKey:kAccountInfoUToken];
    [mutableDict setValue:self.userId forKey:kAccountInfoUserId];
    [mutableDict setValue:self.sex forKey:kAccountInfoSex];
    [mutableDict setValue:self.province forKey:kAccountInfoProvince];
    [mutableDict setValue:self.passwdQuestion forKey:kAccountInfoPasswdQuestion];
    [mutableDict setValue:self.visitCount forKey:kAccountInfoVisitCount];
    [mutableDict setValue:self.isSpecial forKey:kAccountInfoIsSpecial];
    [mutableDict setValue:self.salt forKey:kAccountInfoSalt];
    [mutableDict setValue:self.password forKey:kAccountInfoPassword];
    [mutableDict setValue:self.addressId forKey:kAccountInfoAddressId];
    [mutableDict setValue:self.creditLine forKey:kAccountInfoCreditLine];
    [mutableDict setValue:self.status forKey:kAccountInfoStatus];
    [mutableDict setValue:self.isSurplusOpen forKey:kAccountInfoIsSurplusOpen];
    [mutableDict setValue:self.userMoney forKey:kAccountInfoUserMoney];
    [mutableDict setValue:self.flag forKey:kAccountInfoFlag];
    [mutableDict setValue:self.address forKey:kAccountInfoAddress];
    [mutableDict setValue:self.backCard forKey:kAccountInfoBackCard];
    [mutableDict setValue:self.answer forKey:kAccountInfoAnswer];
    [mutableDict setValue:self.validated forKey:kAccountInfoValidated];
    [mutableDict setValue:self.frozenMoney forKey:kAccountInfoFrozenMoney];
    [mutableDict setValue:self.froms forKey:kAccountInfoFroms];
    [mutableDict setValue:self.question forKey:kAccountInfoQuestion];
    [mutableDict setValue:self.mediaUID forKey:kAccountInfoMediaUID];
    [mutableDict setValue:self.homePhone forKey:kAccountInfoHomePhone];
    [mutableDict setValue:self.surplusPassword forKey:kAccountInfoSurplusPassword];
    [mutableDict setValue:self.userRank forKey:kAccountInfoUserRank];
    [mutableDict setValue:self.rankPoints forKey:kAccountInfoRankPoints];
    [mutableDict setValue:self.qq forKey:kAccountInfoQq];
    [mutableDict setValue:self.country forKey:kAccountInfoCountry];
    [mutableDict setValue:self.msn forKey:kAccountInfoMsn];
    [mutableDict setValue:self.ecSalt forKey:kAccountInfoEcSalt];
    [mutableDict setValue:self.email forKey:kAccountInfoEmail];
    [mutableDict setValue:self.isValidated forKey:kAccountInfoIsValidated];
    [mutableDict setValue:self.card forKey:kAccountInfoCard];
    [mutableDict setValue:self.payPoints forKey:kAccountInfoPayPoints];
    [mutableDict setValue:self.district forKey:kAccountInfoDistrict];
    [mutableDict setValue:self.alias forKey:kAccountInfoAlias];
    [mutableDict setValue:self.birthday forKey:kAccountInfoBirthday];
    [mutableDict setValue:self.passwdAnswer forKey:kAccountInfoPasswdAnswer];
    [mutableDict setValue:self.lastIp forKey:kAccountInfoLastIp];
    [mutableDict setValue:self.aiteId forKey:kAccountInfoAiteId];
    [mutableDict setValue:self.officePhone forKey:kAccountInfoOfficePhone];
    [mutableDict setValue:self.mediaID forKey:kAccountInfoMediaID];
    [mutableDict setValue:self.nickname forKey:kAccountInfoNickname];
    [mutableDict setValue:self.headimg forKey:kAccountInfoHeadimg];
    [mutableDict setValue:self.lastTime forKey:kAccountInfoLastTime];
    [mutableDict setValue:self.isFenxiao forKey:kAccountInfoIsFenxiao];
    [mutableDict setValue:self.faceCard forKey:kAccountInfoFaceCard];
    [mutableDict setValue:self.mobilePhone forKey:kAccountInfoMobilePhone];
    [mutableDict setValue:self.regTime forKey:kAccountInfoRegTime];
    [mutableDict setValue:self.userName forKey:kAccountInfoUserName];
    [mutableDict setValue:self.city forKey:kAccountInfoCity];
    [mutableDict setValue:self.realName forKey:kAccountInfoRealName];
    [mutableDict setValue:self.lastLogin forKey:kAccountInfoLastLogin];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.parentId = [aDecoder decodeObjectForKey:kAccountInfoParentId];
    self.uToken = [aDecoder decodeObjectForKey:kAccountInfoUToken];
    self.userId = [aDecoder decodeObjectForKey:kAccountInfoUserId];
    self.sex = [aDecoder decodeObjectForKey:kAccountInfoSex];
    self.province = [aDecoder decodeObjectForKey:kAccountInfoProvince];
    self.passwdQuestion = [aDecoder decodeObjectForKey:kAccountInfoPasswdQuestion];
    self.visitCount = [aDecoder decodeObjectForKey:kAccountInfoVisitCount];
    self.isSpecial = [aDecoder decodeObjectForKey:kAccountInfoIsSpecial];
    self.salt = [aDecoder decodeObjectForKey:kAccountInfoSalt];
    self.password = [aDecoder decodeObjectForKey:kAccountInfoPassword];
    self.addressId = [aDecoder decodeObjectForKey:kAccountInfoAddressId];
    self.creditLine = [aDecoder decodeObjectForKey:kAccountInfoCreditLine];
    self.status = [aDecoder decodeObjectForKey:kAccountInfoStatus];
    self.isSurplusOpen = [aDecoder decodeObjectForKey:kAccountInfoIsSurplusOpen];
    self.userMoney = [aDecoder decodeObjectForKey:kAccountInfoUserMoney];
    self.flag = [aDecoder decodeObjectForKey:kAccountInfoFlag];
    self.address = [aDecoder decodeObjectForKey:kAccountInfoAddress];
    self.backCard = [aDecoder decodeObjectForKey:kAccountInfoBackCard];
    self.answer = [aDecoder decodeObjectForKey:kAccountInfoAnswer];
    self.validated = [aDecoder decodeObjectForKey:kAccountInfoValidated];
    self.frozenMoney = [aDecoder decodeObjectForKey:kAccountInfoFrozenMoney];
    self.froms = [aDecoder decodeObjectForKey:kAccountInfoFroms];
    self.question = [aDecoder decodeObjectForKey:kAccountInfoQuestion];
    self.mediaUID = [aDecoder decodeObjectForKey:kAccountInfoMediaUID];
    self.homePhone = [aDecoder decodeObjectForKey:kAccountInfoHomePhone];
    self.surplusPassword = [aDecoder decodeObjectForKey:kAccountInfoSurplusPassword];
    self.userRank = [aDecoder decodeObjectForKey:kAccountInfoUserRank];
    self.rankPoints = [aDecoder decodeObjectForKey:kAccountInfoRankPoints];
    self.qq = [aDecoder decodeObjectForKey:kAccountInfoQq];
    self.country = [aDecoder decodeObjectForKey:kAccountInfoCountry];
    self.msn = [aDecoder decodeObjectForKey:kAccountInfoMsn];
    self.ecSalt = [aDecoder decodeObjectForKey:kAccountInfoEcSalt];
    self.email = [aDecoder decodeObjectForKey:kAccountInfoEmail];
    self.isValidated = [aDecoder decodeObjectForKey:kAccountInfoIsValidated];
    self.card = [aDecoder decodeObjectForKey:kAccountInfoCard];
    self.payPoints = [aDecoder decodeObjectForKey:kAccountInfoPayPoints];
    self.district = [aDecoder decodeObjectForKey:kAccountInfoDistrict];
    self.alias = [aDecoder decodeObjectForKey:kAccountInfoAlias];
    self.birthday = [aDecoder decodeObjectForKey:kAccountInfoBirthday];
    self.passwdAnswer = [aDecoder decodeObjectForKey:kAccountInfoPasswdAnswer];
    self.lastIp = [aDecoder decodeObjectForKey:kAccountInfoLastIp];
    self.aiteId = [aDecoder decodeObjectForKey:kAccountInfoAiteId];
    self.officePhone = [aDecoder decodeObjectForKey:kAccountInfoOfficePhone];
    self.mediaID = [aDecoder decodeObjectForKey:kAccountInfoMediaID];
    self.nickname = [aDecoder decodeObjectForKey:kAccountInfoNickname];
    self.headimg = [aDecoder decodeObjectForKey:kAccountInfoHeadimg];
    self.lastTime = [aDecoder decodeObjectForKey:kAccountInfoLastTime];
    self.isFenxiao = [aDecoder decodeObjectForKey:kAccountInfoIsFenxiao];
    self.faceCard = [aDecoder decodeObjectForKey:kAccountInfoFaceCard];
    self.mobilePhone = [aDecoder decodeObjectForKey:kAccountInfoMobilePhone];
    self.regTime = [aDecoder decodeObjectForKey:kAccountInfoRegTime];
    self.userName = [aDecoder decodeObjectForKey:kAccountInfoUserName];
    self.city = [aDecoder decodeObjectForKey:kAccountInfoCity];
    self.realName = [aDecoder decodeObjectForKey:kAccountInfoRealName];
    self.lastLogin = [aDecoder decodeObjectForKey:kAccountInfoLastLogin];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_parentId forKey:kAccountInfoParentId];
    [aCoder encodeObject:_uToken forKey:kAccountInfoUToken];
    [aCoder encodeObject:_userId forKey:kAccountInfoUserId];
    [aCoder encodeObject:_sex forKey:kAccountInfoSex];
    [aCoder encodeObject:_province forKey:kAccountInfoProvince];
    [aCoder encodeObject:_passwdQuestion forKey:kAccountInfoPasswdQuestion];
    [aCoder encodeObject:_visitCount forKey:kAccountInfoVisitCount];
    [aCoder encodeObject:_isSpecial forKey:kAccountInfoIsSpecial];
    [aCoder encodeObject:_salt forKey:kAccountInfoSalt];
    [aCoder encodeObject:_password forKey:kAccountInfoPassword];
    [aCoder encodeObject:_addressId forKey:kAccountInfoAddressId];
    [aCoder encodeObject:_creditLine forKey:kAccountInfoCreditLine];
    [aCoder encodeObject:_status forKey:kAccountInfoStatus];
    [aCoder encodeObject:_isSurplusOpen forKey:kAccountInfoIsSurplusOpen];
    [aCoder encodeObject:_userMoney forKey:kAccountInfoUserMoney];
    [aCoder encodeObject:_flag forKey:kAccountInfoFlag];
    [aCoder encodeObject:_address forKey:kAccountInfoAddress];
    [aCoder encodeObject:_backCard forKey:kAccountInfoBackCard];
    [aCoder encodeObject:_answer forKey:kAccountInfoAnswer];
    [aCoder encodeObject:_validated forKey:kAccountInfoValidated];
    [aCoder encodeObject:_frozenMoney forKey:kAccountInfoFrozenMoney];
    [aCoder encodeObject:_froms forKey:kAccountInfoFroms];
    [aCoder encodeObject:_question forKey:kAccountInfoQuestion];
    [aCoder encodeObject:_mediaUID forKey:kAccountInfoMediaUID];
    [aCoder encodeObject:_homePhone forKey:kAccountInfoHomePhone];
    [aCoder encodeObject:_surplusPassword forKey:kAccountInfoSurplusPassword];
    [aCoder encodeObject:_userRank forKey:kAccountInfoUserRank];
    [aCoder encodeObject:_rankPoints forKey:kAccountInfoRankPoints];
    [aCoder encodeObject:_qq forKey:kAccountInfoQq];
    [aCoder encodeObject:_country forKey:kAccountInfoCountry];
    [aCoder encodeObject:_msn forKey:kAccountInfoMsn];
    [aCoder encodeObject:_ecSalt forKey:kAccountInfoEcSalt];
    [aCoder encodeObject:_email forKey:kAccountInfoEmail];
    [aCoder encodeObject:_isValidated forKey:kAccountInfoIsValidated];
    [aCoder encodeObject:_card forKey:kAccountInfoCard];
    [aCoder encodeObject:_payPoints forKey:kAccountInfoPayPoints];
    [aCoder encodeObject:_district forKey:kAccountInfoDistrict];
    [aCoder encodeObject:_alias forKey:kAccountInfoAlias];
    [aCoder encodeObject:_birthday forKey:kAccountInfoBirthday];
    [aCoder encodeObject:_passwdAnswer forKey:kAccountInfoPasswdAnswer];
    [aCoder encodeObject:_lastIp forKey:kAccountInfoLastIp];
    [aCoder encodeObject:_aiteId forKey:kAccountInfoAiteId];
    [aCoder encodeObject:_officePhone forKey:kAccountInfoOfficePhone];
    [aCoder encodeObject:_mediaID forKey:kAccountInfoMediaID];
    [aCoder encodeObject:_nickname forKey:kAccountInfoNickname];
    [aCoder encodeObject:_headimg forKey:kAccountInfoHeadimg];
    [aCoder encodeObject:_lastTime forKey:kAccountInfoLastTime];
    [aCoder encodeObject:_isFenxiao forKey:kAccountInfoIsFenxiao];
    [aCoder encodeObject:_faceCard forKey:kAccountInfoFaceCard];
    [aCoder encodeObject:_mobilePhone forKey:kAccountInfoMobilePhone];
    [aCoder encodeObject:_regTime forKey:kAccountInfoRegTime];
    [aCoder encodeObject:_userName forKey:kAccountInfoUserName];
    [aCoder encodeObject:_city forKey:kAccountInfoCity];
    [aCoder encodeObject:_realName forKey:kAccountInfoRealName];
    [aCoder encodeObject:_lastLogin forKey:kAccountInfoLastLogin];
}

- (id)copyWithZone:(NSZone *)zone
{
    AccountInfo *copy = [[AccountInfo alloc] init];
    
    if (copy) {

        copy.parentId = [self.parentId copyWithZone:zone];
        copy.uToken = [self.uToken copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.sex = [self.sex copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
        copy.passwdQuestion = [self.passwdQuestion copyWithZone:zone];
        copy.visitCount = [self.visitCount copyWithZone:zone];
        copy.isSpecial = [self.isSpecial copyWithZone:zone];
        copy.salt = [self.salt copyWithZone:zone];
        copy.password = [self.password copyWithZone:zone];
        copy.addressId = [self.addressId copyWithZone:zone];
        copy.creditLine = [self.creditLine copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        copy.isSurplusOpen = [self.isSurplusOpen copyWithZone:zone];
        copy.userMoney = [self.userMoney copyWithZone:zone];
        copy.flag = [self.flag copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.backCard = [self.backCard copyWithZone:zone];
        copy.answer = [self.answer copyWithZone:zone];
        copy.validated = [self.validated copyWithZone:zone];
        copy.frozenMoney = [self.frozenMoney copyWithZone:zone];
        copy.froms = [self.froms copyWithZone:zone];
        copy.question = [self.question copyWithZone:zone];
        copy.mediaUID = [self.mediaUID copyWithZone:zone];
        copy.homePhone = [self.homePhone copyWithZone:zone];
        copy.surplusPassword = [self.surplusPassword copyWithZone:zone];
        copy.userRank = [self.userRank copyWithZone:zone];
        copy.rankPoints = [self.rankPoints copyWithZone:zone];
        copy.qq = [self.qq copyWithZone:zone];
        copy.country = [self.country copyWithZone:zone];
        copy.msn = [self.msn copyWithZone:zone];
        copy.ecSalt = [self.ecSalt copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.isValidated = [self.isValidated copyWithZone:zone];
        copy.card = [self.card copyWithZone:zone];
        copy.payPoints = [self.payPoints copyWithZone:zone];
        copy.district = [self.district copyWithZone:zone];
        copy.alias = [self.alias copyWithZone:zone];
        copy.birthday = [self.birthday copyWithZone:zone];
        copy.passwdAnswer = [self.passwdAnswer copyWithZone:zone];
        copy.lastIp = [self.lastIp copyWithZone:zone];
        copy.aiteId = [self.aiteId copyWithZone:zone];
        copy.officePhone = [self.officePhone copyWithZone:zone];
        copy.mediaID = [self.mediaID copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.headimg = [self.headimg copyWithZone:zone];
        copy.lastTime = [self.lastTime copyWithZone:zone];
        copy.isFenxiao = [self.isFenxiao copyWithZone:zone];
        copy.faceCard = [self.faceCard copyWithZone:zone];
        copy.mobilePhone = [self.mobilePhone copyWithZone:zone];
        copy.regTime = [self.regTime copyWithZone:zone];
        copy.userName = [self.userName copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.realName = [self.realName copyWithZone:zone];
        copy.lastLogin = [self.lastLogin copyWithZone:zone];
    }
    
    return copy;
}


@end
