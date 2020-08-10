//
//  PhotoLibraryViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define kPopoverContentSize CGSizeMake(ScreenWidth, ScreenHeight - 44 - 49)

#import "PhotoLibraryViewController.h"

#import "PhotoGroupViewController.h"

@interface PhotoLibraryViewController ()


@end

@implementation PhotoLibraryViewController

- (id)init
{
    PhotoGroupViewController *groupViewController = [[PhotoGroupViewController alloc] init];
    
    if (self = [super initWithRootViewController:groupViewController])
    {
        _maximumNumberOfSelection      = 10;
        _minimumNumberOfSelection      = 0;
        _assetsFilter                  = [ALAssetsFilter allAssets];
        _showCancelButton              = YES;
        _showEmptyGroups               = NO;
        _selectionFilter               = [NSPredicate predicateWithValue:YES];
        _isFinishDismissViewController = YES;
        self.preferredContentSize = kPopoverContentSize;

    }
    
    return self;
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationBar.hidden = NO;
}
@end
