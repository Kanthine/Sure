//
//  ShareView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

@property (nonatomic ,weak) UIViewController *currentViewController;


- (instancetype)initWithLinkUrl:(NSString *)linkString imageUrlStr:(NSString *)imageString Descr:(NSString *)detaileStr;

- (void)showPlatView;


@end
