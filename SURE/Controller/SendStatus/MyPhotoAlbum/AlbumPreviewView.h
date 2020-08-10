//
//  AlbumPreviewView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumGroupView.h"


@interface AlbumPreviewView : UIView

@property (nonatomic ,copy) void(^ selectPhotoAlbumClick)(NSMutableArray<PHAsset *> *listArray);
@property (nonatomic ,copy) void(^ nextStepCropImageButtonClick)(UIImage *image);


- (void)resetPreviewImage:(UIImage *)selectedImage;



@property (nonatomic ,strong) UIButton *cancelButton;
@property (nonatomic ,strong) UIButton *nextStepButton;

@end
