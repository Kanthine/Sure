//
//  IMPreviewViewController.h
//  SURE
//
//  Created by 王玉龙 on 17/1/21.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMPreviewViewControllerDelegate <NSObject>

- (void)tapImageClick;

@end

@interface IMPreviewViewController : UIViewController

- (instancetype)initWithImage:(id)image;

@property (nonatomic ,weak) id <IMPreviewViewControllerDelegate> delegate;

@end
