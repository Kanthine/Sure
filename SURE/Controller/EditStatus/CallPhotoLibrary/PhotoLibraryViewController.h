//
//  PhotoLibraryViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - PhotoLibraryViewController

@protocol PhotoLibraryViewControllerDelegate;

@interface PhotoLibraryViewController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, PhotoLibraryViewControllerDelegate> delegate;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, copy) NSMutableArray *acquiredImageArray;

@property (nonatomic, copy) NSArray *indexPathsForSelectedItemsArray;


@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

@property (nonatomic, strong) NSPredicate *selectionFilter;

@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) BOOL showEmptyGroups;

@property (nonatomic, assign) BOOL isFinishDismissViewController;
@end


@protocol PhotoLibraryViewControllerDelegate <NSObject>

-(void)assetPickerController:(PhotoLibraryViewController *)picker didFinishPickingAssets:(NSArray *)assets;


-(void)assetPickerController:(PhotoLibraryViewController *)picker didFinishPickingImageArray:(NSMutableArray *)imageArray;

@optional

-(void)assetPickerControllerDidCancel:(PhotoLibraryViewController *)picker;

-(void)assetPickerController:(PhotoLibraryViewController *)picker didSelectAsset:(ALAsset*)asset;

-(void)assetPickerController:(PhotoLibraryViewController *)picker didDeselectAsset:(ALAsset*)asset;

-(void)assetPickerControllerDidMaximum:(PhotoLibraryViewController *)picker;

-(void)assetPickerControllerDidMinimum:(PhotoLibraryViewController *)picker;

@end


