//
//  AssetGroupViewCell.h
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end
