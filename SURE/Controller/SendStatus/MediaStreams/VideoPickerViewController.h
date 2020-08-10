//
//  VideoPickerViewController.h
//  SURE
//
//  Created by 王玉龙 on 17/1/12.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SurePhotoModel;
@class CamearDeviceManager;

@interface VideoPickerViewController : UIViewController


@property (nonatomic ,copy) void(^ cancelVideoStreamsClick)();
@property (nonatomic ,copy) void(^ nextStepVideoStreamsClick)(SurePhotoModel *photoModel);


@end
