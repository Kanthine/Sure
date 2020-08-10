//
//  RefundListVC.h
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,RefundState)
{
    RefundStateAll = 0,
    RefundStateWaitHandle,
    RefundStateFinished,

};



@interface RefundListVC : UIViewController

@property (nonatomic ,assign) RefundState refundType;


@end
