//
//  MyHeaderBackImageVC.m
//  SURE
//
//  Created by 王玉龙 on 17/1/12.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define ImageScale 250.0 / 375.0

#define CellIdentifer @"MyHeaderBackImageTableCell"

#import "MyHeaderBackImageVC.h"
#import <Masonry.h>
#import "FilePathManager.h"
#import "TimeStamp.h"
#import "PhotoCropViewController.h"

#import "AlbumPhotoViewController.h"
#import "AlbumLibraryViewController.h"

@interface MyHeaderBackImageTableCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *backImageView;

@end


@implementation MyHeaderBackImageTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self.contentView addSubview:self.backImageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(@5);
            make.left.mas_equalTo(@10);
            make.bottom.mas_equalTo(@-5);
            make.right.mas_equalTo(@-10);
        }];
    }
    
    
    return self;
}

- (UIImageView *)backImageView
{
    if (_backImageView == nil)
    {
        _backImageView = [[UIImageView alloc]init];
    }
    
    return _backImageView;
}



@end




@interface MyHeaderBackImageVC ()

<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic ,strong) NSMutableArray *imageArray;

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation MyHeaderBackImageVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myCropImageSuccessClick:) name:@"myCropImageSuccess" object:nil];
    
    [self customNavBar];
    
    
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"更换背景";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = ImageScale * (ScreenWidth - 20) + 10;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MyHeaderBackImageTableCell class] forCellReuseIdentifier:CellIdentifer];
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
        [_tableView setTableFooterView:[UIView new]];
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.imageArray.count > 0)
    {
        return 3;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.imageArray.count > 0 && section == 1)
    {
        return self.imageArray.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyHeaderBackImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.backImageView.contentMode = UIViewContentModeScaleAspectFit;

    if (indexPath.section == 0)
    {
        // 默认图片
        cell.backImageView.image = [UIImage imageNamed:@"owner_Back"];
    }
    else if (self.imageArray.count > 0 && indexPath.section == 1)
    {
        NSString *imagePath = self.imageArray[indexPath.row];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        if (image)
        {
            cell.backImageView.image = image;
        }
        
    }
    else
    {
        cell.backImageView.image = [UIImage imageNamed:@"backImage_Add"];
        cell.backImageView.contentMode = UIViewContentModeCenter;
    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ((self.imageArray.count > 0 && indexPath.section == 2) || (self.imageArray.count <= 0 && indexPath.section == 1))
    {
        [self addBackImage];
    }
    else
    {
        __weak __typeof__(self) weakSelf = self;
        MyHeaderBackImageTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImage *image = cell.backImageView.image;
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"您要使用这张图片作为背景？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"使用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
              {
                  [weakSelf setBackImageWithImage:image];
              }];
        
        
        [alertView addAction:cancelAction];
        [alertView addAction:confirmAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void)setBackImageWithImage:(UIImage *)image
{
    NSData *data = nil;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    

    
    NSString *filePath = [FilePathManager getDefaultBackImagePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }
    
    BOOL isSuccess = [data writeToFile:filePath atomically:YES];
    
    if (isSuccess)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeBackImageSuccess" object:nil userInfo:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 || indexPath.section == 0)
    {
        // 最后一行，添加照片不可删除
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //数组删除
        //数据库删除 本地删除
        //单元格删除
        
        NSString *path = _imageArray[indexPath.row];
        
        if ([[NSFileManager defaultManager] removeItemAtPath:path error:NULL])
        {
            NSLog(@"Removed successfully");
            [_imageArray removeObjectAtIndex:indexPath.row];
            
            if (_imageArray.count > 0)
            {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            
            [tableView reloadData];
        }



    }
}

- (NSMutableArray *)imageArray
{
    if (_imageArray == nil)
    {
        _imageArray = [NSMutableArray array];
        
        
        NSString *fodlerPath = [FilePathManager createBackImageFolderIfNotExist];
        
        NSFileManager *myFileManager=[NSFileManager defaultManager];
        
        NSDirectoryEnumerator *myDirectoryEnumerator;
        
        myDirectoryEnumerator=[myFileManager enumeratorAtPath:fodlerPath];
        
        //列举目录内容，可以遍历子目录
        NSString *imagePath = nil;
        while((imagePath=[myDirectoryEnumerator nextObject])!=nil)
        {
            imagePath = [NSString stringWithFormat:@"%@/%@",fodlerPath,imagePath];
            if (imagePath.length > 1 && ![imagePath isEqualToString:[FilePathManager getDefaultBackImagePath]])
            {
                [_imageArray addObject:imagePath];
            }
            
        }
        
        [_tableView reloadData];

    }
    
    return _imageArray;
}

- (void)addBackImage
{
    
    __weak __typeof__(self) weakSelf = self;

    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
           {
           }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
      {
          AlbumPhotoViewController *album = [[AlbumPhotoViewController alloc]init];
          album.cropSize = CGSizeMake(ScreenWidth, ImageScale * ScreenWidth);
          UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:album];
          nav.navigationBarHidden = YES;
          [weakSelf presentViewController:nav animated:YES completion:nil];
      }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            AlbumLibraryViewController *album = [[AlbumLibraryViewController alloc]init];
            album.cropSize = CGSizeMake(ScreenWidth, ImageScale * ScreenWidth);
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:album];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];
    
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:libraryAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    PhotoCropViewController *cropVC = [[PhotoCropViewController alloc]initWithImage:image cropFrame:CGRectMake(0, (ScreenHeight - 64 - 250) / 2.0, ScreenWidth, 250) limitScaleRatio:3];
    [picker pushViewController:cropVC animated:YES];
}

- (void)myCropImageSuccessClick:(NSNotification *)notification
{
    UIImage *image = notification.userInfo[@"image"];
    
    NSString *imagePath = [self getImagePath:image];
    
    NSLog(@"imagePath ======== %@",imagePath);
    
    [_imageArray addObject:imagePath];
    [_tableView reloadData];
//    [self dismissViewControllerAnimated:YES completion:nil];
}


//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image
{
    Image = [Image compressToMaxDataSizeKBytes:50 * 1024];
    
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil)
    {
        data = UIImageJPEGRepresentation(Image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(Image);
    }
    
    NSString *fodlerPath = [FilePathManager createBackImageFolderIfNotExist];
    
    NSString *dateString = [TimeStamp createCurrentTimeToTimestamp];
    
    NSString *filePath = [[fodlerPath stringByAppendingPathComponent:dateString] stringByAppendingString:@".png"];
    
    BOOL isSuccess = [data writeToFile:filePath atomically:YES];
    
    if (isSuccess)
    {
        return filePath;
    }
    
    NSLog(@"filePath === %@",filePath);
    
    return filePath;
}


@end
