//
//  BaseViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/12/7.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic ,strong) HttpManager *httpManager;

- (void)requestNetworkGetData;

@end
