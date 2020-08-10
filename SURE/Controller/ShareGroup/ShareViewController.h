//
//  ShareViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/10/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController

- (void)showPlatView;

- (instancetype)initWithLinkUrl:(NSString *)linkString imageUrlStr:(NSString *)imageString Descr:(NSString *)detaileStr;

@end
