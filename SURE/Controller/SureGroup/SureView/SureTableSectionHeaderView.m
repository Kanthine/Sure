//
//  SureTableSectionHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SureTableSectionHeaderView.h"
#import <Masonry.h>

#import "SureViewController.h"
#import "MySureViewController.h"
#import "HandleResultView.h"
@interface SureTableSectionHeaderView()

{
    SUREModel *_sureModel;
}

@property (strong, nonatomic) UIButton *detaileButton;
@property (strong, nonatomic) UIButton *moreButton;

@end

@implementation SureTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        __weak __typeof__(self) weakSelf = self;
        
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.headerTitleLable];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.detaileButton];
        
        
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.mas_equalTo(@10);
             make.width.mas_equalTo(@30);
             make.height.mas_equalTo(@30);
         }];

        
        
        [self.headerTitleLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@50);
             make.bottom.mas_equalTo(@0);
             make.top.mas_equalTo(@0);
             make.width.mas_equalTo(@(ScreenWidth - 50 - 60));
         }];

        
        
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.width.mas_equalTo(@60);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.top.mas_equalTo(@0);
         }];
        
        
        [self.detaileButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.width.mas_equalTo(@60);
             make.bottom.mas_equalTo(@0);
             make.top.mas_equalTo(@0);
         }];
    }
    
    
    return self;
}

#pragma mark - Build UI


- (UILabel *)headerTitleLable
{
    if (_headerTitleLable == nil)
    {
        _headerTitleLable = [[UILabel alloc]init];
        _headerTitleLable.backgroundColor = [UIColor clearColor];
        _headerTitleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _headerTitleLable.textAlignment = NSTextAlignmentLeft;
        _headerTitleLable.textColor = [UIColor blackColor];
    }
    
    return _headerTitleLable;
}

- (UIImageView *)headerImageView
{
    if (_headerImageView == nil)
    {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.layer.cornerRadius = 15;
    }
    
    return _headerImageView;
}

- (UIButton *)moreButton
{
    if (_moreButton == nil)
    {
        _moreButton = [[UIButton alloc]init];
        
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moreButton_Gray"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_moreButton addSubview:imageView];
        
        __weak __typeof__(_moreButton) weakSelf = _moreButton;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.right.mas_equalTo(@-10);
             make.width.mas_equalTo(@20);
             make.height.mas_equalTo(@5);
         }];


    }
    
    return _moreButton;
}

- (UIButton *)detaileButton
{
    if (_detaileButton == nil)
    {
        _detaileButton = [[UIButton alloc] init];
        [_detaileButton addTarget:self action:@selector(detaileButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _detaileButton;
}

#pragma mark - Button Click

- (void)moreButtonClick
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        //未登录
        [self sectionHeaderReportAction];
    }
    else
    {
        //已登录
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if ([account.userId isEqualToString:_sureModel.uid])
        {
            // 判断当前状态用户是自己
            [self sectionHeaderDeleteAction];
        }
        else
        {
            // 判断当前状态用户不是自己
            [self sectionHeaderReportAction];
        }
        
    }

    
//    _sectionHeaderMoreButtonClick();
}

- (void)detaileButtonClick
{
    
    if ([AuthorizationManager isAuthorization] == NO)
    {
        //未登录
        MySureViewController *detaileVC = [[MySureViewController alloc]initWithParentID:_sureModel.uid UserID:@"" UserType:SureUserTypeOtherNoAttention SureListType:SureListTypeSURE];
        detaileVC.hidesBottomBarWhenPushed = YES;
        [self.currentViewController.navigationController pushViewController:detaileVC animated:YES];
    }
    else
    {
        //已登录
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if ([account.userId isEqualToString:_sureModel.uid])
        {
            // 判断当前状态用户是自己
            MySureViewController *detaileVC = [[MySureViewController alloc]initWithParentID:_sureModel.uid UserID:account.userId UserType:SureUserTypeMy SureListType:SureListTypeSURE];
            detaileVC.hidesBottomBarWhenPushed = YES;
            [self.currentViewController.navigationController pushViewController:detaileVC animated:YES];
        }
        else
        {
            // 判断当前状态用户不是自己
            MySureViewController *detaileVC = [[MySureViewController alloc]initWithParentID:_sureModel.uid UserID:account.userId UserType:SureUserTypeOtherNoAttention SureListType:SureListTypeSURE];
            detaileVC.hidesBottomBarWhenPushed = YES;
            [self.currentViewController.navigationController pushViewController:detaileVC animated:YES];
            
        }
    }

//    _sectionHeaderDetaileButtonClick();
}

- (void)sectionHeaderReportAction
{
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       [weakSelf reportSureModel];
                                   }];
    UIAlertAction *saveImageAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [weakSelf savePhotoToAlbumModel];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:reportAction];
    [actionSheet addAction:saveImageAction];
    [actionSheet addAction:cancelAction];
    [self.currentViewController presentViewController:actionSheet animated:YES completion:nil];
}

- (void)reportSureModel
{
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"请输入举报内容" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
     {
         
     }];
    
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       UITextField *textFiled = [alertView.textFields firstObject];
                                       [weakSelf reportSurerWithModel:_sureModel ReportText:textFiled.text];
                                   }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertView addAction:reportAction];
    [alertView addAction:cancelAction];
    [self.currentViewController presentViewController:alertView animated:YES completion:nil];
}

- (void)reportSurerWithModel:(SUREModel *)sureModel ReportText:(NSString *)reportText
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *parDict = @{@"uid":account.userId,@"fdid":sureModel.internalBaseClassIdentifier,@"report_t":@"",@"report_text":reportText};
    __weak __typeof__(self) weakSelf = self;

    [self.currentViewController.httpManager reportObjectWithParameterDict:parDict CompletionBlock:^(NSError *error)
     {
         if (error)
         {
             [[[HandleResultView alloc]initWithIsFinish:NO Title:@"举报失败"] showToSuperView:weakSelf.currentViewController.view];
             
         }
         else
         {
             [[[HandleResultView alloc]initWithIsFinish:YES Title:@"我们已经受理举报"] showToSuperView:weakSelf.currentViewController.view];
             
         }
     }];
}

- (void)sectionHeaderDeleteAction
{
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
   {
       [weakSelf deleteMyStatusModel];
   }];
    UIAlertAction *saveImageAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          [weakSelf savePhotoToAlbumModel];
                                      }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    
    [actionSheet addAction:deleteAction];
    [actionSheet addAction:saveImageAction];
    [actionSheet addAction:cancelAction];
    [self.currentViewController presentViewController:actionSheet animated:YES completion:nil];
}

- (void)deleteMyStatusModel
{
    __weak __typeof__(self) weakSelf = self;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"您确定要删除这个状态？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
       {
           [weakSelf confirmDeleteMyStatusModel];
       }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    
    [alertView addAction:cancelAction];
    [alertView addAction:deleteAction];
    [self.currentViewController presentViewController:alertView animated:YES completion:nil];
    
}

- (void)confirmDeleteMyStatusModel
{
    NSDictionary *dict = @{@"id":_sureModel.internalBaseClassIdentifier};
    
    __weak __typeof__(self) weakSelf = self;

    [self.currentViewController.httpManager deleteSureStatusWithParameterDict:dict CompletionBlock:^(NSError *error)
     {
         if (error)
         {
             
             
         }
         else
         {
             //删除成功
             [weakSelf.currentViewController.sureListArray removeObject:_sureModel];//本地删除
             [weakSelf.currentViewController.tableView deleteSections:[NSIndexSet indexSetWithIndex:_section] withRowAnimation:UITableViewRowAnimationFade];//界面删除
             
             [weakSelf.currentViewController.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
         }
     }];
    
}


NSMutableArray<NSString *> *saveImagArray = nil;
- (void)savePhotoToAlbumModel
{
    saveImagArray = [NSMutableArray array];
    [_sureModel.imglistModelArray enumerateObjectsUsingBlock:^(SUREFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [saveImagArray addObject:obj.urlString];
     }];
    
    [self savePhotoToAlbum];
}

- (void)savePhotoToAlbum
{
    __weak __typeof__(self) weakSelf = self;
    
    NSLog(@"saveImageArray ======= %ld",saveImagArray.count);
    
    if (saveImagArray && saveImagArray.count > 0)
    {
        NSString *urlString = saveImagArray[0];
        
        NSLog(@"urlString ======= %@",urlString);
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
         {
             
             NSLog(@"currentThread ======= %@",[NSThread currentThread]);
             
             
             UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
         }];
        
        
    }
    else
    {
        saveImagArray = nil;
        [[[HandleResultView alloc]initWithIsFinish:YES Title:@"已保存到系统相册"] showToSuperView:self.currentViewController.view];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error)
    {
        msg = @"保存图片失败";
        
        [[[HandleResultView alloc]initWithIsFinish:NO Title:@"保存失败"] showToSuperView:self.currentViewController.view];
    }
    else
    {
        msg = @"保存图片成功" ;
        
        [saveImagArray removeObjectAtIndex:0];
        [self savePhotoToAlbum];
    }
    
    
    
    NSLog(@"保存结果 ======  %@",msg);
}


#pragma mark - Button Click


- (void)updateSectionHeaderInfoWith:(SUREModel *)sureModel
{
    _sureModel = sureModel;
    
    self.headerTitleLable.text = sureModel.sureName;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:sureModel.sureHeader] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}

@end
