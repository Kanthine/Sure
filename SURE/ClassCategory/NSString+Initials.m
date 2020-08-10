//
//  NSString+Initials.m
//  SURE
//
//  Created by 王玉龙 on 17/1/19.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "NSString+Initials.h"


@implementation NSString (Initials)

- (NSString *)acquireInitials
{
    NSMutableString *ms = [[NSMutableString alloc]initWithString:self];
    

    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics, NO))
    {
        
        NSString *bigStr = [ms uppercaseString]; // bigStr 是转换成功后的拼音
        NSString *cha = [bigStr substringToIndex:1];
        
        return cha;
    }
    
    return @"";
}

@end
