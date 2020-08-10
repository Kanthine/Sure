//
//  VideoStreamsViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SurePhotoModel;
@class CamearDeviceManager;

@interface VideoStreamsViewController : UIViewController

- (instancetype)initWithCamearManager:(CamearDeviceManager *)camear;

@property (nonatomic ,copy) void(^ cancelVideoStreamsClick)();
@property (nonatomic ,copy) void(^ nextStepVideoStreamsClick)(SurePhotoModel *photoModel);


@end
