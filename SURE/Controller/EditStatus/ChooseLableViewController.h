//
//  ChooseLableViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/10/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseLableViewControllerDelegate <NSObject>

@required

- (void)selectedSignWithSign:(NSString *)signString;

@end

@interface ChooseLableViewController : UIViewController

@property (nonatomic ,weak) id <ChooseLableViewControllerDelegate> delegate;

@end
