//
//  ShutTableView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ShutTableView.h"

@implementation ShutTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    id view = [super hitTest:point withEvent:event];
    
    
    if ([view isKindOfClass:[UITextField class]] == NO)
    {
        [self endEditing:YES];
        
        return self;
    }
    else
    {
        return view;
    }
}
@end
