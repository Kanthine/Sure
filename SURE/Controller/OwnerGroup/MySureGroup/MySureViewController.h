//
//  MySureViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BaseViewController.h"



typedef NS_ENUM(NSUInteger ,SureUserType)
{
    SureUserTypeMy = 0,//
    SureUserTypeOtherNoAttention,
    SureUserTypeOtherAttentioned,
};

typedef NS_ENUM(NSUInteger ,SureListType)
{
    SureListTypeSURE = 0,
    SureListTypeTapedSure,
    SureListTypeTagBrand,
};


@interface MySureViewController : BaseViewController

@property (nonatomic ,assign) SureUserType userType;
@property (nonatomic ,assign) SureListType listType;

- (instancetype)initWithParentID:(NSString *)parentID UserID:(NSString *)userID UserType:(SureUserType)userType SureListType:(SureListType )listType;


@end
