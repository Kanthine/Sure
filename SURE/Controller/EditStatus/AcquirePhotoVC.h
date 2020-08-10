//
//  AcquirePhotoVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, AcquirePhotoState)
{
    AcquirePhotoStateLibrary = 0,
    AcquirePhotoStateTakePhoto,
    AcquirePhotoStateTakeVideo,
};




@protocol AcquirePhotoVCDelegate <NSObject>

@optional

- (void)addPhotoSucceesWithImageArray:(NSMutableArray *)newImageArray;

@end

@interface AcquirePhotoVC : UIViewController

@property (nonatomic ,weak)   id <AcquirePhotoVCDelegate> delegate;
@property (nonatomic ,strong) NSMutableArray *selectedImageArray;

@property (nonatomic,assign) AcquirePhotoState status;


- (void)setCameraChildViewController;//先设置子控制器  再设置  界面内容

- (void)setVideoChildViewController;

- (void)setPhotoLibraryChildViewController;

@end

// 视频 储存之指定文件夹
//打开 时 闪光灯开启问题
