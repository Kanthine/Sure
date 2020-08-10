//
//  PostSureTool.h
//  SURE
//
//  Created by 王玉龙 on 16/12/26.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SurePhotoModel;

@interface PostSureTool : NSObject

+ (void)creatJsonWithImageModelArray:(NSArray<SurePhotoModel *> *)imageModelArray CompletionBlock:(void (^) (NSString *jsonString,NSArray *brandArray))block;


@end
