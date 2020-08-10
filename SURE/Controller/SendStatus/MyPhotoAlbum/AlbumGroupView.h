//
//  AlbumGroupView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PhotosManager.h"

@interface AlbumGroupView : UIView

@property (nonatomic ,copy) void(^ selectPhotoAlbumClick)(PHAssetCollection *assetCollection);

- (void)showAlbumGroupView;

- (void)dismissAlbumGroupView;
@end
