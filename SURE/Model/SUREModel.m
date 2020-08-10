//
//  SUREModel.m
//
//  Created by   on 16/12/9
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SUREModel.h"
#import "TimeStamp.h"
#import "FilePathManager.h"

NSString *const kSUREModelUid = @"uid";
NSString *const kSUREModelHit = @"hit";
NSString *const kSUREModelId = @"id";
NSString *const kSUREModelInputtime = @"inputtime";
NSString *const kSUREModelImglist = @"imglist";
NSString *const kSUREModelLng = @"lng";
NSString *const kSUREModelLat = @"lat";
NSString *const kSUREModelSureBody = @"sure_body";
NSString *const kSUREModelImglistModelArray = @"imglistDict";
NSString *const kSUREModelIsOption = @"isfollow";
NSString *const kSUREModelOptionArray = @"follor_user";
NSString *const kSUREModelSureName = @"user_name";
NSString *const kSUREModelSureHeader = @"user_head";
NSString *const kSUREModelOptionCount = @"follow_count";


@implementation SURETapModel

- (instancetype)initWithTapCount:(NSString *)tapCount HeaderArray:(NSArray *)imageArray IsTap:(NSString *)isTap
{
    self = [super init];
    
    if (self)
    {
        _tapCount = tapCount;
        _isTap = isTap;
        _tapHeaderArray = [NSMutableArray arrayWithCapacity:imageArray.count];
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            [_tapHeaderArray addObject:obj[@"headimg"]];
        }];
    }
    
    return self;
}

@end





@interface SUREModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SUREModel

@synthesize uid = _uid;
@synthesize hit = _hit;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize inputtime = _inputtime;
@synthesize imglist = _imglist;
@synthesize lng = _lng;
@synthesize lat = _lat;
@synthesize sureBody = _sureBody;
@synthesize imglistModelArray = _imglistModelArray;
//@synthesize isOption = _isOption;
//@synthesize follerArray = _follerArray;
@synthesize sureName = _sureName;
@synthesize sureHeader = _sureHeader;
//@synthesize optionCount = _optionCount;
@synthesize tapModel = _tapModel;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        
        // dict 有两种数据形式
        
        if ([dict.allKeys containsObject:@"brand_info"])
        {
            // 品牌 商品 的 SURE
            
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kSUREModelId fromDictionary:dict];
            self.sureBody = [self objectOrNilForKey:kSUREModelSureBody fromDictionary:dict];
            
            self.imglist = [self objectOrNilForKey:kSUREModelImglist fromDictionary:dict];

            self.imglistModelArray = [SUREFileModel parserDataWithDictionary:[self stringSwitchJson:self.imglist]];
            
            
           NSArray *array = dict[@"brand_info"];
            
            
            if (array && array.count)
            {
                NSDictionary *brandInfo = array.firstObject;
                
                
                self.uid = [self objectOrNilForKey:@"user_id" fromDictionary:brandInfo];
                
                self.lng = [self objectOrNilForKey:kSUREModelLng fromDictionary:brandInfo];
                self.lat = [self objectOrNilForKey:kSUREModelLat fromDictionary:brandInfo];
                
                
                self.inputtime = [self objectOrNilForKey:kSUREModelInputtime fromDictionary:brandInfo];
                self.inputtime = [TimeStamp timeStampSwitchTime:self.inputtime];
                
                
                
                
                NSString *isTap = [self objectOrNilForKey:kSUREModelIsOption fromDictionary:brandInfo];
                NSString *tapCount = [self objectOrNilForKey:kSUREModelOptionCount fromDictionary:brandInfo];
                NSArray *tapHeaderArray = [self objectOrNilForKey:kSUREModelOptionArray fromDictionary:brandInfo];
                self.tapModel = [[SURETapModel alloc]initWithTapCount:tapCount HeaderArray:tapHeaderArray IsTap:isTap];
                
                
                self.sureName = [self objectOrNilForKey:kSUREModelSureName fromDictionary:brandInfo];
                self.sureHeader = [self objectOrNilForKey:kSUREModelSureHeader fromDictionary:brandInfo];
                
                
                self.isOption = [self objectOrNilForKey:kSUREModelIsOption fromDictionary:brandInfo];
                self.follerArray = [self objectOrNilForKey:kSUREModelOptionArray fromDictionary:brandInfo];
                self.optionCount = [self objectOrNilForKey:kSUREModelOptionCount fromDictionary:brandInfo];

            }
            
            

        }
        else
        {
            
            
            
            
            
            
            self.uid = [self objectOrNilForKey:kSUREModelUid fromDictionary:dict];
            self.hit = [self objectOrNilForKey:kSUREModelHit fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kSUREModelId fromDictionary:dict];
            self.inputtime = [self objectOrNilForKey:kSUREModelInputtime fromDictionary:dict];
            self.inputtime = [TimeStamp timeStampSwitchTime:self.inputtime];
            
            self.imglist = [self objectOrNilForKey:kSUREModelImglist fromDictionary:dict];
            self.lng = [self objectOrNilForKey:kSUREModelLng fromDictionary:dict];
            self.lat = [self objectOrNilForKey:kSUREModelLat fromDictionary:dict];
            self.sureBody = [self objectOrNilForKey:kSUREModelSureBody fromDictionary:dict];
            
            
            
            
            
            NSString *isTap = [self objectOrNilForKey:kSUREModelIsOption fromDictionary:dict];
            NSString *tapCount = [self objectOrNilForKey:kSUREModelOptionCount fromDictionary:dict];
            NSArray *tapHeaderArray = [self objectOrNilForKey:kSUREModelOptionArray fromDictionary:dict];
            
            
            self.tapModel = [[SURETapModel alloc]initWithTapCount:tapCount HeaderArray:tapHeaderArray IsTap:isTap];
            
            
            
            self.isOption = [self objectOrNilForKey:kSUREModelIsOption fromDictionary:dict];
            self.follerArray = [self objectOrNilForKey:kSUREModelOptionArray fromDictionary:dict];
            self.optionCount = [self objectOrNilForKey:kSUREModelOptionCount fromDictionary:dict];
            
            self.sureName = [self objectOrNilForKey:kSUREModelSureName fromDictionary:dict];
            self.sureHeader = [self objectOrNilForKey:kSUREModelSureHeader fromDictionary:dict];
            
            
            self.imglistModelArray = [SUREFileModel parserDataWithDictionary:[self stringSwitchJson:self.imglist]];
            
            
        }
        
        
        
        
        
        
        
        
        



    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.uid forKey:kSUREModelUid];
    [mutableDict setValue:self.hit forKey:kSUREModelHit];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kSUREModelId];
    [mutableDict setValue:self.inputtime forKey:kSUREModelInputtime];
    [mutableDict setValue:self.imglist forKey:kSUREModelImglist];
    [mutableDict setValue:self.lng forKey:kSUREModelLng];
    [mutableDict setValue:self.lat forKey:kSUREModelLat];
    [mutableDict setValue:self.sureBody forKey:kSUREModelSureBody];
    [mutableDict setValue:self.isOption forKey:kSUREModelIsOption];
    [mutableDict setValue:self.follerArray forKey:kSUREModelOptionArray];
    [mutableDict setValue:self.sureName forKey:kSUREModelSureName];
    [mutableDict setValue:self.sureHeader forKey:kSUREModelSureHeader];
    [mutableDict setValue:self.optionCount forKey:kSUREModelOptionCount];

    
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

    self.uid = [aDecoder decodeObjectForKey:kSUREModelUid];
    self.hit = [aDecoder decodeObjectForKey:kSUREModelHit];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kSUREModelId];
    self.inputtime = [aDecoder decodeObjectForKey:kSUREModelInputtime];
    self.imglist = [aDecoder decodeObjectForKey:kSUREModelImglist];
    self.lng = [aDecoder decodeObjectForKey:kSUREModelLng];
    self.lat = [aDecoder decodeObjectForKey:kSUREModelLat];
    self.sureBody = [aDecoder decodeObjectForKey:kSUREModelSureBody];

    self.isOption = [aDecoder decodeObjectForKey:kSUREModelIsOption];
    self.follerArray = [aDecoder decodeObjectForKey:kSUREModelOptionArray];
    self.sureName = [aDecoder decodeObjectForKey:kSUREModelSureName];
    self.sureHeader = [aDecoder decodeObjectForKey:kSUREModelSureHeader];
    
    self.optionCount = [aDecoder decodeObjectForKey:kSUREModelOptionCount];

    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_uid forKey:kSUREModelUid];
    [aCoder encodeObject:_hit forKey:kSUREModelHit];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kSUREModelId];
    [aCoder encodeObject:_inputtime forKey:kSUREModelInputtime];
    [aCoder encodeObject:_imglist forKey:kSUREModelImglist];
    [aCoder encodeObject:_lng forKey:kSUREModelLng];
    [aCoder encodeObject:_lat forKey:kSUREModelLat];
    [aCoder encodeObject:_sureBody forKey:kSUREModelSureBody];

    [aCoder encodeObject:_isOption forKey:kSUREModelIsOption];
    [aCoder encodeObject:_follerArray forKey:kSUREModelOptionArray];
    [aCoder encodeObject:_sureName forKey:kSUREModelSureName];
    [aCoder encodeObject:_sureHeader forKey:kSUREModelSureHeader];

    [aCoder encodeObject:_optionCount forKey:kSUREModelOptionCount];

}

- (id)copyWithZone:(NSZone *)zone
{
    SUREModel *copy = [[SUREModel alloc] init];
    
    if (copy) {

        copy.uid = [self.uid copyWithZone:zone];
        copy.hit = [self.hit copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.inputtime = [self.inputtime copyWithZone:zone];
        copy.imglist = [self.imglist copyWithZone:zone];
        copy.lng = [self.lng copyWithZone:zone];
        copy.lat = [self.lat copyWithZone:zone];
        copy.sureBody = [self.sureBody copyWithZone:zone];
        
        copy.isOption = [self.isOption copyWithZone:zone];
        copy.follerArray = [self.follerArray copyWithZone:zone];
        copy.sureName = [self.sureName copyWithZone:zone];
        copy.sureHeader = [self.sureHeader copyWithZone:zone];
        
        copy.optionCount = [self.optionCount copyWithZone:zone];

    }
    
    return copy;
}


- (NSDictionary *)stringSwitchJson:(NSString *)string
{
    NSData *resData = [[NSData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];  //解析
    
    
    return resultDic;
}


@end

@implementation SUREFileModel

+ (NSMutableArray *)parserDataWithDictionary:(NSDictionary *)jsonDict
{
    NSArray *imageArray = jsonDict[@"imglist"];
    NSMutableArray *parserArray = [NSMutableArray array];
    
    if (imageArray && imageArray.count)
    {
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            SUREFileModel *model = [SUREFileModel modelObjectWithDictionary:obj];
            [parserArray addObject:model];
        }];
    }
    
    
    return parserArray;
    
}

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.urlString = [self objectOrNilForKey:@"images" fromDictionary:dict];
        
        if ([self.urlString containsString:@"FileVideo.mp4"])
        {
            self.isImage = NO;
            //异步缓存视频
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
            {
                NSString *path = [FilePathManager getSureListVideoPathWithURLString:self.urlString];
                NSData *data = [NSData dataWithContentsOfFile:self.urlString];
                
                BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
                if (isOk)
                {
                    self.videoLocalityPathString = path;
                    NSLog(@"缓存视频成功 %@\n", path);
                }
                else
                {
                    NSLog(@"缓存视频失败 %@\n", path);
                }
            });
            
        }
        else
        {
            self.isImage = YES;
        }
        
        self.tagArray = [self objectOrNilForKey:@"tagArray" fromDictionary:dict];        
        
    }
    
    return self;
    
}



#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end




