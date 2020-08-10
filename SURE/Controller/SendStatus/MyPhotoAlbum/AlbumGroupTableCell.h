//
//  AlbumGroupTableCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define AlbumGroupTableCellHeight    ScreenWidth / 4.0

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>


@interface AlbumGroupTableCell : UITableViewCell

- (void)updateCellWithAssetCollection:(PHAssetCollection *)assetCollection;

@end
