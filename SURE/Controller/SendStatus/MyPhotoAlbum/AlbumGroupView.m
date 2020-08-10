//
//  AlbumGroupView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"AlbumGroupTableCell"
#define TableViewMaxHeight (ScreenHeight - 44 - 50)

#import "AlbumGroupView.h"
#import "AlbumGroupTableCell.h"


@interface AlbumGroupView()

<UITableViewDelegate,UITableViewDataSource>

/** 保存相册文件夹 */
@property (nonatomic, strong) NSMutableArray<PHAssetCollection *> *fetchAlbumArray;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *coverButton;

@end

@implementation AlbumGroupView

/** 动画时间 */
static CGFloat const AnimationDuration = 0.2;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.coverButton];
        [self addSubview:self.tableView];
        __weak __typeof__(self) weakSelf = self;

        
        
        [PhotosManager loadPhotoAlbumCompletionBlock:^(NSMutableArray<PHAssetCollection *> *listArray)
        {
            weakSelf.fetchAlbumArray = listArray;
            [weakSelf.tableView reloadData];
        }];
        
        
    }
    
    return self;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) style:UITableViewStylePlain];
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
    _selectPhotoAlbumClick(album);
    [self dismissAlbumGroupView];
}

- (UIButton *)coverButton
{
    if (_coverButton == nil)
    {
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverButton.backgroundColor = [UIColor blackColor];
        _coverButton.alpha = 0.0;
        [_coverButton addTarget:self action:@selector(dismissAlbumGroupView) forControlEvents:UIControlEventTouchUpInside];
        _coverButton.frame = self.bounds;
    }
    
    return _coverButton;
}

- (void)showAlbumGroupView
{
    __weak __typeof__(self) weakSelf = self;

    CGFloat tableHeight = 0;
    if (self.fetchAlbumArray && self.fetchAlbumArray.count)
    {
        tableHeight = self.fetchAlbumArray.count *  AlbumGroupTableCellHeight;
        
        if (tableHeight > TableViewMaxHeight)
        {
            tableHeight = TableViewMaxHeight;
        }
        
        
        [UIView animateWithDuration:AnimationDuration animations:^
         {
             self.tableView.frame = CGRectMake(0, 0, ScreenWidth, tableHeight);
             self.coverButton.alpha = 0.3;
         }];
    }
    else
    {
        [UIView animateWithDuration:AnimationDuration animations:^
        {
            self.coverButton.alpha = 0.3;
        } completion:^(BOOL finished)
        {
            [weakSelf showAlbumGroupView];
        }];
    }
    
}


- (void)dismissAlbumGroupView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.tableView.frame = CGRectMake(0, 0, ScreenWidth,0);

         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished)
    {
         [self.tableView removeFromSuperview];
         [self.coverButton removeFromSuperview];
         [self removeFromSuperview];
     }];
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
