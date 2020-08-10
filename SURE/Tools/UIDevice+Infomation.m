//
//  UIDevice+Infomation.m
//  SURE
//
//  Created by 王玉龙 on 16/10/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "UIDevice+Infomation.h"

@implementation UIDevice (Infomation)

+ ( NSInteger ) currentMainScreen
{
    if (ScreenWidth < 330 && ScreenWidth > 300)
    {
        return 1;
    }
    else if (ScreenWidth < 400 && ScreenWidth > 350)
    {
        return 2;
    }
    else if (ScreenWidth < 420 && ScreenWidth > 400)
    {
        return 3;
    }
    
    return 0;
}

@end
