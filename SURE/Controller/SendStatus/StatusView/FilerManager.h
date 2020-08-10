//
//  FilerManager.h
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define FilerCount 20

#define FilerNameKey  @"FilerNameKey"
#define FilerImageKey @"FilerImageKey"

#import <Foundation/Foundation.h>

#import "FWApplyFilter.h"

@interface FilerManager : NSObject

+ (void)loadFilerWithOriginalImage:(UIImage *)originalImage CompletionBlock:(void (^) ( NSMutableArray<NSDictionary *> *filerListArray))block;


@end
