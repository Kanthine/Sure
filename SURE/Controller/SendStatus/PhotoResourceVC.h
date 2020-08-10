//
//  PhotoResourceVC.h
//  SURE
//
//  Created by 王玉龙 on 16/12/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,PhotoResourceContentTpye)
{
    PhotoResourceContentTpyePhoto = 0,
    PhotoResourceContentTpyeLibrary,
    PhotoResourceContentTpyeVideo
};

typedef NS_ENUM(NSUInteger ,PhotoResourceJoinType)
{
    PhotoResourceJoinTypePush = 0,
    PhotoResourceJoinTypePresent
};

@interface PhotoResourceVC : UIViewController

@property (nonatomic ,assign) PhotoResourceJoinType joinType;


- (instancetype)initWithContentType:(PhotoResourceContentTpye)contentType;



@end
