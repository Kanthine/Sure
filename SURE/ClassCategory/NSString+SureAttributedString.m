//
//  NSString+SureAttributedString.m
//  SURE
//
//  Created by 王玉龙 on 17/1/16.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "NSString+SureAttributedString.h"

@implementation NSString (SureAttributedString)

- (NSAttributedString *)getAttriString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //行间距
    [paragraphStyle setLineSpacing:3.0];
    //段落间距
    [paragraphStyle setParagraphSpacing:10.0];
    //第一行头缩进
    [paragraphStyle setFirstLineHeadIndent:0.0];
    //头部缩进
    //[paragraphStyle setHeadIndent:15.0];
    //尾部缩进
    //[paragraphStyle setTailIndent:250.0];
    //最小行高
    //[paragraphStyle setMinimumLineHeight:20.0];
    //最大行高
    //[paragraphStyle setMaximumLineHeight:20.0];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    return attributedString;
}


@end
