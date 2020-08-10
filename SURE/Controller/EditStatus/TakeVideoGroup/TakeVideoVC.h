//
//  TakeVideoVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>



#import <AVFoundation/AVFoundation.h>
#import "SBCaptureDefine.h"
#import "SBVideoRecorder.h"



@protocol TakeVideoVCDelegate <NSObject>

@required

- (void)takeVideoFinishedWithPath:(NSString *)videoPathString ThumbImage:(UIImage *)image;

@end


@interface TakeVideoVC : UIViewController

<SBVideoRecorderDelegate, UIAlertViewDelegate>

@property (nonatomic ,assign) id <TakeVideoVCDelegate> delegate;

- (void)startTakeVideo;
- (void)stopTakeVideo;




@end
//EasyVideoRecorde
