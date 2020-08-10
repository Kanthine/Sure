//
//  RefundReasonView.h
//  SURE
//
//  Created by 王玉龙 on 17/2/17.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundReasonView : UIView

@property (nonatomic ,copy) void(^ refundReasonViewConfirmButtonClick)(NSString *reasonString);
@property (nonatomic ,strong) NSString *currentReasonStr;

- (instancetype)initWithReasonStr:(NSString *)reasonStr;

- (void)show;

@end
