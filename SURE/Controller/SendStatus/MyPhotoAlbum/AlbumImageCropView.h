//
//  AlbumImageCropView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumImageCropView : UIView

@property (nonatomic ,strong) UIImageView *imageView;

- (UIImage *)finishCroppingImage;

@end
