//
//  AssetView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@protocol AssetViewDelegate <NSObject>

-(BOOL)shouldSelectAsset:(ALAsset*)asset;
-(void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;

@end


@interface AssetView : UIView

@property (nonatomic, weak) id<AssetViewDelegate> delegate;

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end
