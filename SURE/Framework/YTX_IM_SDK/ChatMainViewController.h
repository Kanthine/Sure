//
//  ChatMainViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/11/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideSwitchSubviewDelegate <NSObject>
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
-(void)showToast:(NSString *)message;
@end



@interface ChatMainViewController : UIViewController

@end
