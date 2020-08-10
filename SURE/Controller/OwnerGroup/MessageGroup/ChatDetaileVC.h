//
//  ChatDetaileVC.h
//  SURE
//
//  Created by 王玉龙 on 17/1/4.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ChatDetaileVC : UIViewController

@property (nonatomic, copy) NSString* sessionId;
-(instancetype)initWithSessionId:(NSString*)sessionId;


@end
