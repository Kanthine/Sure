//
//  AssetViewCell.h
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@protocol AssetViewCellDelegate;

@interface AssetViewCell : UITableViewCell

@property (nonatomic ,strong) UINavigationController *selfNavBarController;
@property(nonatomic,weak)id<AssetViewCellDelegate> delegate;

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;


@end

@protocol AssetViewCellDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset;

- (void)didSelectAsset:(ALAsset*)asset;

- (void)didDeselectAsset:(ALAsset*)asset;

@end
