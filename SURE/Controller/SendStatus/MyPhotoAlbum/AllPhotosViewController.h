//
//  AllPhotosViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/12/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurePhotoModel.h"

@interface AllPhotosViewController : UIViewController

@property (nonatomic ,copy) void(^ cancelAllPhotosButtonClick)();
@property (nonatomic ,copy) void(^ nextStepAllPhotosButtonClick)(SurePhotoModel *photoModel);


@end
