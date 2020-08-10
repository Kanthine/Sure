//
//  AssetViewCell.m
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define kThumbnailLength    (ScreenWidth - 5 * 2 )/ 4.0   //78.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)


#import "AssetViewCell.h"

#import "PhotoShowViewController.h"
#import "PhotoLibraryViewController.h"
#import "EditImageModel.h"
#import "AssetView.h"
@interface AssetViewCell()

<AssetViewDelegate>

@end

@implementation AssetViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX
{
    
    if (self.contentView.subviews.count<assets.count)
    {
        for (int i=0; i<assets.count; i++)
        {
            if (i>((NSInteger)self.contentView.subviews.count-1))
            {
                PhotoLibraryViewController *vc =(PhotoLibraryViewController *)self.selfNavBarController;
                ALAsset  *asset = assets[i];
                
                
                NSLog(@"url.description == %@",asset.defaultRepresentation.url.path);
                
                BOOL isSelected  = NO;
                for (EditImageModel *acquireImage in vc.acquiredImageArray)
                {
                    
                    if ([acquireImage.resourceURL isEqual:asset.defaultRepresentation.url])
                    {
                        isSelected = YES;
                        [self tapSelectHandle:isSelected asset:asset];
                        break;

                    }
                    
                }
                
                AssetView *assetView=[[AssetView alloc] initWithFrame:CGRectMake(assetViewX+(kThumbnailSize.width+minimumInteritemSpacing)*i, minimumLineSpacing-1, kThumbnailSize.width, kThumbnailSize.height)];
//                [assetView bind:assets[i] selectionFilter:selectionFilter isSeleced:[((PhotoShowViewController*)_delegate).indexPathsForSelectedItemsArray containsObject:assets[i]]];
                [assetView bind:assets[i] selectionFilter:selectionFilter isSeleced:isSelected];
                assetView.delegate=self;
                [self.contentView addSubview:assetView];
                
                
            }
            else
            {
                ((AssetView*)self.contentView.subviews[i]).frame=CGRectMake(assetViewX+(kThumbnailSize.width+minimumInteritemSpacing)*(i), minimumLineSpacing-1, kThumbnailSize.width, kThumbnailSize.height);
                [(AssetView*)self.contentView.subviews[i] bind:assets[i] selectionFilter:selectionFilter isSeleced:[((PhotoShowViewController*)_delegate).indexPathsForSelectedItemsArray containsObject:assets[i]]];
            }
            
            
            
            
        }
        
    }
    else
    {
        for (int i = self.contentView.subviews.count; i>0; i--)
        {
            if (i>assets.count)
            {
                [((AssetView*)self.contentView.subviews[i-1]) removeFromSuperview];
            }
            else
            {
                ((AssetView*)self.contentView.subviews[i-1]).frame=CGRectMake(assetViewX+(kThumbnailSize.width + minimumInteritemSpacing)*(i-1), minimumLineSpacing - 1, kThumbnailSize.width, kThumbnailSize.height);
                
                
                [(AssetView*)self.contentView.subviews[i-1] bind:assets[i-1] selectionFilter:selectionFilter isSeleced:[((PhotoShowViewController*)_delegate).indexPathsForSelectedItemsArray containsObject:assets[i-1]]];
            }
        }
    }
}

#pragma mark - ZYQAssetView Delegate

-(BOOL)shouldSelectAsset:(ALAsset *)asset
{
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldSelectAsset:)]) {
        return [_delegate shouldSelectAsset:asset];
    }
    return YES;
}

-(void)tapSelectHandle:(BOOL)select asset:(ALAsset *)asset
{
    // 选中 取消选中
    if (select)
    {
        if (_delegate!=nil&&[_delegate respondsToSelector:@selector(didSelectAsset:)])
        {
            [_delegate didSelectAsset:asset];
        }
    }
    else
    {
        if (_delegate!=nil&&[_delegate respondsToSelector:@selector(didDeselectAsset:)])
        {
            [_delegate didDeselectAsset:asset];
        }
    }
}

@end
