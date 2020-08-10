//
//  ConsoleOutPutChinese.m
//  SURE
//
//  Created by 王玉龙 on 16/11/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ConsoleOutPutChinese.h"

@implementation ConsoleOutPutChinese

+ (NSString *)outPutChineseWithObj:(id)obj
{
    
    if (obj)
    {
        NSString *des = [obj description];
        des = [NSString stringWithCString:[des cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
        
        
        return des;

    }
    
    return @"";
    
}

+ (NSString *)outPutJsonWithObj:(id)obj
{
    
    if (obj)
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        
        return jsonStr;

    }
    return obj;

}


@end
