//
//  TakePhotoVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/11.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditImageModel;

@protocol TakePhotoVCDelegate <NSObject>

@optional

- (void)takePhotoFinshEditImageModel:(EditImageModel *)acquImage;

@end

@interface TakePhotoVC : UIViewController

@property (nonatomic ,assign) BOOL isPresentVC;
@property(nonatomic,weak) id <TakePhotoVCDelegate> delegate;
@property(nonatomic ,strong)AVCaptureSession *session;


@end

//拍摄正常照片
