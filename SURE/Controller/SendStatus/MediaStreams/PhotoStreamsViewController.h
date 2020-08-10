//
//  PhotoStreamsViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SurePhotoModel;
@class CamearDeviceManager;
@interface PhotoStreamsViewController : UIViewController

- (instancetype)initWithCamearManager:(CamearDeviceManager *)camear;

@property (nonatomic ,copy) void(^ cancelPhotoStreamsClick)();
@property (nonatomic ,copy) void(^ nextStepPhotoStreamsClick)(SurePhotoModel *photoModel);


@end
