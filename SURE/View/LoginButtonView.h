//
//  LoginButtonView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishBlock)();

@interface LoginButtonView : UIView

@property (nonatomic,copy) finishBlock translateBlock;


@end
