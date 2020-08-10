//
//  AlbumLibraryViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/1/12.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"AlbumGroupTableCell"

#import "AlbumLibraryViewController.h"

#import "AlbumGroupTableCell.h"
#import "PhotosManager.h"
#import "AlbumLibraryPhotoVC.h"

@interface AlbumLibraryViewController()

<UITableViewDelegate,UITableViewDataSource>

/** 保存相册文件夹 */
@property (nonatomic, strong) NSMutableArray<PHAssetCollection *> *fetchAlbumArray;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation AlbumLibraryViewController

/** 动画时间 */
static CGFloat const AnimationDuration = 0.2;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {

        __weak __typeof__(self) weakSelf = self;
        [PhotosManager loadPhotoAlbumCompletionBlock:^(NSMutableArray<PHAssetCollection *> *listArray)
         {
             weakSelf.fetchAlbumArray = listArray;
             [weakSelf.tableView reloadData];
         }];
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self customNavBar];

    [self.view addSubview:self.tableView];
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"相册";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = AlbumGroupTableCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[AlbumGroupTableCell class] forCellReuseIdentifier:CellIdentifer];
        
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchAlbumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumGroupTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    PHAssetCollection *album = self.fetchAlbumArray[indexPath.row];
    [cell updateCellWithAssetCollection:album];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHAssetCollection *album = self.fetchAlbumArray[indexPath.row];

    AlbumLibraryPhotoVC *photoVC = [[AlbumLibraryPhotoVC alloc]initWithAssetCollection:album];
    photoVC.cropSize = self.cropSize;
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (NSMutableArray<PHAssetCollection *> *)fetchAlbumArray
{
    if (_fetchAlbumArray == nil)
    {
        _fetchAlbumArray = [NSMutableArray array];
    }
    
    return _fetchAlbumArray;
}

@end

