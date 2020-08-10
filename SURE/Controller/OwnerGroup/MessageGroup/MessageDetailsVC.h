//
//  MessageDetailsVC.h
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailsVC : UIViewController


- (instancetype)initWithInfo:(NSDictionary *)userInfo;

/*
 推送消息 ========= 
 {
 "" = "";
 aps =     
 {
     alert = ewags;
     badge = 34;
     sound = default;
 };
 }
 
 */




@end
