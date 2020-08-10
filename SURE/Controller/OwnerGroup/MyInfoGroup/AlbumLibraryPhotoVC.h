//
//  AlbumLibraryPhotoVC.h
//  SURE
//
//  Created by 王玉龙 on 17/1/12.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumLibraryPhotoVC : UIViewController

@property (nonatomic, assign) CGSize cropSize;//裁剪尺寸

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection;


@end
