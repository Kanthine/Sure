//
//  TakeFilerPhotoVC.h
//  SURE
//
//  Created by 王玉龙 on 16/11/3.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FilerCamearManager.h"
@class EditImageModel;

@protocol TakeFilerPhotoVCDelegate <NSObject>

@optional

- (void)takePhotoFinshEditImageModel:(EditImageModel *)acquImage;

@end



@interface TakeFilerPhotoVC : UIViewController


@property (nonatomic ,assign) BOOL isPresentVC;
//@property (nonatomic, assign) id<SlideSwitchSubviewDelegate> mainView;
@property(nonatomic,weak) id <TakeFilerPhotoVCDelegate> delegate;

- (void)startCameraCapture;
- (void)suspendCameraCapture;

@end

//实时滤镜
