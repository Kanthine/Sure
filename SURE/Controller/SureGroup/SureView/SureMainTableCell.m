//
//  SureMainTableCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"SureMainCollectionCell"

#import "SureMainTableCell.h"
#import <Masonry.h>

#import "BaseViewController.h"

#import "NSString+SureAttributedString.h"
#import "BrandTagView.h"



#import "ShareViewController.h"
#import "TapSupportDetaileVC.h"
#import "SingleProductDetaileVC.h"


@interface SureMainCollectionCell : UICollectionViewCell

{
    UIButton *_playButton;
    AVPlayerItem *_playerItem;
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;
}


@property (nonatomic ,assign) BOOL tagHidden;
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,copy) void(^ tapTagClick)(NSString *goodIDString);

- (void)updateImageCellWithFileModel:(SUREFileModel *)fileModel;

@end

@implementation SureMainCollectionCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
         }];
    }
    
    return self;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick:)];
        [_imageView addGestureRecognizer:tapGesture];
        
    }
    
    return _imageView;
}

- (void)updateImageCellWithFileModel:(SUREFileModel *)fileModel
{
    self.tagHidden = NO;
    [self releaserPlayerView];

    if (fileModel.isImage)
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:fileModel.urlString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
     //   self.imageView.image = [UIImage imageNamed:@"placeholderImage"];
    }
    else
    {
//        if (fileModel.videoLocalityPathString)
//        {
//            [self setPlayVideoViewWithVideoURL:[NSURL fileURLWithPath:fileModel.videoLocalityPathString]];
//        }
//        else
//        {
             [self setPlayVideoViewWithVideoURL:[NSURL URLWithString:fileModel.urlString]];
//        }        
    }
    
    [self updateTagWithTagArray:fileModel.tagArray];
}

/*
 * 点击图片 标签隐藏与重现
 */
- (void)tapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    
    _tagHidden = !_tagHidden;
    
    if (_tagHidden == YES)
    {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (obj.tag > 11)
             {
                 obj.hidden = YES;
             }
         }];
    }
    else
    {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (obj.tag > 11)
             {
                 obj.hidden = NO;
             }
         }];
    }
}

- (void)releaserPlayerView
{
    [_playButton removeFromSuperview];
    _playButton = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    _playerItem = nil;
}

- (void)setPlayVideoViewWithVideoURL:(NSURL *)videoURL
{
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.contentView.layer addSublayer:_playerLayer];
    
    
    _playButton = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    [_playButton setImage:[UIImage imageNamed:@"playVideo"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_playButton];
}

- (void)playVideoButtonClick:(UIButton *)button
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem)
    {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^
     {
         _playButton.alpha = 1.0f;
     }];
}

- (void)updateTagWithTagArray:(NSArray<NSDictionary *> *)tagArray
{
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (obj.tag > 10)
         {
             [obj removeFromSuperview];
         }
     }];
    
    
    //添加图片的标签
    if (tagArray && tagArray.count)
    {
        __weak __typeof(self)weakSelf = self;
        
        [tagArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             CGFloat x = [[obj objectForKey:@"lat"] floatValue] * ScreenWidth;
             CGFloat y = [[obj objectForKey:@"lng"] floatValue] * ScreenWidth;
             NSString *tagString = [obj objectForKey:@"lablename"];
             NSString *goodID = [obj objectForKey:@"goodsid"];
             
             BrandTagView *tagView = [[BrandTagView alloc]initWithFrame:CGRectMake(x, y, 100, BrandTagViewHEIGHT) Title:tagString TagIndex:0];
             tagView.tag = 12 + idx;
             tagView.goodIDString = goodID;
             tagView.isCanMove = NO;
             tagView.isCanDelete = NO;
             [weakSelf.contentView addSubview:tagView];
             [weakSelf.contentView bringSubviewToFront:tagView];
             tagView.tapBrandTagClick = ^(NSString *goodIDString)
             {
                 weakSelf.tapTagClick(goodIDString);
             };
             
         }];
    }
}

@end












@interface SureMainTableCell()

<UICollectionViewDelegate,UICollectionViewDataSource>

{
    SUREModel *_sureModel;
    NSArray<SUREFileModel *> *_imageArray;
}
@property (nonatomic ,strong)  UIPageControl *pageControl;
@property (nonatomic ,strong)  UICollectionView *sureCollectionView;
@property (strong, nonatomic)  UILabel *timeLable;

@property (strong, nonatomic)  UIButton *shareButton;

@property (strong, nonatomic)  UIButton *supportButton;
@property (strong, nonatomic)  SureTapSupportView *supportView;

@end

@implementation SureMainTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.sureCollectionView];
        [self.contentView addSubview:self.pageControl];
        [self.contentView addSubview:self.statusLable];
        [self.contentView addSubview:self.supportButton];
        [self.contentView addSubview:self.shareButton];
        [self.contentView addSubview:self.supportView];
        [self.contentView addSubview:self.timeLable];
        
        __weak __typeof(self)weakSelf = self;
        [self.sureCollectionView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(weakSelf.sureCollectionView.mas_width).multipliedBy(1);
        }];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.sureCollectionView.mas_bottom).with.offset(-30);
             make.centerX.equalTo(weakSelf.sureCollectionView);
             make.height.mas_equalTo(@20);
//             make.right.mas_equalTo(@-10);
             make.width.mas_equalTo(@100);
        }];
        
      
        [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.sureCollectionView.mas_bottom).with.offset(10);
             make.left.mas_equalTo(@10);
             make.right.mas_equalTo(@-10);
         }];
      
        [self.supportButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.statusLable.mas_bottom).with.offset(0);
             make.left.mas_equalTo(@0);
             make.width.mas_equalTo(@50);
             make.height.mas_equalTo(@45);
         }];

        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.statusLable.mas_bottom).with.offset(0);
             make.left.equalTo(weakSelf.supportButton.mas_right).with.offset(0);
             make.width.mas_equalTo(@50);
             make.height.mas_equalTo(@45);
         }];
        
        [self.supportView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.shareButton.mas_bottom).with.offset(-5);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@30);
         }];
        
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.supportView.mas_bottom).with.offset(0);
             make.left.mas_equalTo(@10);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@20);
             make.bottom.mas_equalTo(@-10);
         }];
        
        
        UIView *bottomLineView =  UIView.new;
        bottomLineView.backgroundColor = GrayLineColor;
        [self.contentView addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@1);
             make.bottom.mas_equalTo(@0);
         }];

    }
    
    return self;
}

#pragma mark - Build UI

- (UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = RGBA(230, 97, 224, 1);
    }
    
    return _pageControl;
}

- (UICollectionView *)sureCollectionView
{
    if (_sureCollectionView == nil)
    {
        UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionFlowLayout.itemSize = CGSizeMake(ScreenWidth, ScreenWidth);
        collectionFlowLayout.minimumLineSpacing = 0;
        collectionFlowLayout.minimumInteritemSpacing = 0;
        
        
        _sureCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionFlowLayout];
        _sureCollectionView.dataSource = self;
        _sureCollectionView.delegate = self;
        _sureCollectionView.backgroundColor = [UIColor clearColor];
        _sureCollectionView.showsHorizontalScrollIndicator = NO;
        _sureCollectionView.showsVerticalScrollIndicator = NO;
        _sureCollectionView.pagingEnabled = YES;

        
        
        [_sureCollectionView registerClass:[SureMainCollectionCell class] forCellWithReuseIdentifier:CellIdentifer];
        _sureCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 10);

    }
    
    return _sureCollectionView;
}

- (UILabel *)statusLable
{
    if (_statusLable == nil)
    {
        _statusLable = [[UILabel alloc]init];
        _statusLable.numberOfLines = 0;
        _statusLable.textColor = TextColorBlack;
        _statusLable.font = [UIFont systemFontOfSize:14];
        _statusLable.textAlignment = NSTextAlignmentLeft;
    }
    
    
    return _statusLable;
}

- (UIButton *)supportButton
{
    if (_supportButton == nil)
    {
        _supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_supportButton setImage:[UIImage imageNamed:@"TapSupportNo"] forState:UIControlStateNormal];
        [_supportButton setImage:[UIImage imageNamed:@"TapSupportNo"] forState:UIControlStateHighlighted];
        [_supportButton setImage:[UIImage imageNamed:@"TapSupported"] forState:UIControlStateSelected];
        
        [_supportButton addTarget:self action:@selector(supportButtonClick:) forControlEvents:UIControlEventTouchUpInside];


        _supportButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _supportButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    return _supportButton;
}


- (UIButton *)shareButton
{
    if (_shareButton == nil)
    {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"sure_ShareGray"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"sure_ShareGray"] forState:UIControlStateHighlighted];
        _shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    }
    
    return _shareButton;
}

- (SureTapSupportView *)supportView
{
    if (_supportView == nil)
    {
        _supportView = [[SureTapSupportView alloc]init];
        [_supportView.pushSupportButton addTarget:self action:@selector(pushSupportListButtonclick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _supportView;
}

- (UILabel *)timeLable
{
    if (_timeLable == nil)
    {
        _timeLable = [[UILabel alloc]init];
        _timeLable.textColor = TextColor149;
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _timeLable;
}

#pragma mark - Button Click

/* 点赞列表 */
- (void)pushSupportListButtonclick
{
    
    NSString *userID = @"";
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        userID = account.userId;
    }
    
    TapSupportDetaileVC *supportDetaileVC = [[TapSupportDetaileVC alloc]init];
    supportDetaileVC.titleString = @"点赞用户";
    supportDetaileVC.userID = userID;
    supportDetaileVC.attentionedID = _sureModel.internalBaseClassIdentifier;
    supportDetaileVC.type = @"4";
    [supportDetaileVC requestNetworkGetData];
    supportDetaileVC.hidesBottomBarWhenPushed = YES;
    [self.currentViewController.navigationController pushViewController:supportDetaileVC animated:YES];

}

/* 分享 */
- (void)shareButtonClick
{
    NSString* thumbURL =  @"http://www.cocoachina.com/ios/20170216/18693.html";
    NSString *descr = _sureModel.sureBody;
    __block NSString *imageStr = @"";
    
    
    [_sureModel.imglistModelArray enumerateObjectsUsingBlock:^(SUREFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (obj.isImage)
         {
             imageStr = obj.urlString;
             * stop = YES;
         }
     }];
    
    
    ShareViewController *shareVC = [[ShareViewController alloc]initWithLinkUrl:thumbURL imageUrlStr:imageStr Descr:descr];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.currentViewController presentViewController:shareVC animated:NO completion:^
     {
         [shareVC showPlatView];
     }];
}

- (void)sureImageTapTagClickWithGoodID:(NSString *)goodIDString
{
    SingleProductDetaileVC *commodityDetaileVC = [[SingleProductDetaileVC alloc]init];
    commodityDetaileVC.goodIDString = goodIDString;
    [commodityDetaileVC requestNetworkGetData];
    commodityDetaileVC.hidesBottomBarWhenPushed = YES;
    [self.currentViewController.navigationController pushViewController:commodityDetaileVC animated:YES];

}

- (void)supportButtonClick:(UIButton *)sender
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        // 点赞先登录
        [AuthorizationManager getAuthorizationWithViewController:self.currentViewController];
        return;
    }
    else
    {
        
        AccountInfo *account = [AccountInfo standardAccountInfo];
        NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":_sureModel.internalBaseClassIdentifier,@"follow_type":@"4"};
        sender.userInteractionEnabled = NO;
        
        
        CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        expandAnimation.duration = 0.3f;
        expandAnimation.fromValue = [NSNumber numberWithFloat:1];
        expandAnimation.toValue = [NSNumber numberWithFloat:1.2f];
        expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        
        CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        narrowAnimation.beginTime = 0.3;
        narrowAnimation.fromValue = [NSNumber numberWithFloat:1.2f];
        narrowAnimation.duration = 0.3;
        narrowAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        
        narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CAAnimationGroup *groups = [CAAnimationGroup animation];
        groups.animations = @[expandAnimation,narrowAnimation];
        groups.duration = 0.6f;
        groups.removedOnCompletion=NO;
        groups.fillMode=kCAFillModeForwards;
        //        groups.delegate = self;
        [sender.layer addAnimation:groups forKey:@"group"];
        
        NSLog(@"点赞参数========== %@",dict);
        
        //改变SUREModel的值
        if ([_sureModel.tapModel.isTap isEqualToString:@"1"])
        {
            //已点赞 ---- >取消点赞
            NSInteger tapCount = [_sureModel.tapModel.tapCount integerValue];
            tapCount --;
            _sureModel.tapModel.tapCount = [NSString stringWithFormat:@"%ld",tapCount];
            _sureModel.tapModel.isTap = @"0";
            [_sureModel.tapModel.tapHeaderArray removeObject:account.headimg];
            [self updateTapViewWithTapModel:_sureModel.tapModel];
            
            sender.selected = NO;
            [self.currentViewController.httpManager cancelAttentionWithParameterDict:dict CompletionBlock:^(NSError *error)
             {
                 sender.userInteractionEnabled = YES;
                 
                 if (error)
                 {
                     sender.selected = YES;
                     
                     //取消点赞失败
                     NSInteger tapCount = [_sureModel.tapModel.tapCount integerValue];
                     tapCount ++;
                     _sureModel.tapModel.tapCount = [NSString stringWithFormat:@"%ld",tapCount];
                     _sureModel.tapModel.isTap = @"1";
                     [self updateTapViewWithTapModel:_sureModel.tapModel];
                 }
             }];
        }
        else
        {
            ////未点赞 ---- >点赞
            NSInteger tapCount = [_sureModel.tapModel.tapCount integerValue];
            tapCount ++;
            _sureModel.tapModel.tapCount = [NSString stringWithFormat:@"%ld",tapCount];
            _sureModel.tapModel.isTap = @"1";
            [_sureModel.tapModel.tapHeaderArray insertObject:account.headimg atIndex:0];
            [self updateTapViewWithTapModel:_sureModel.tapModel];
            
            sender.selected = YES;
            [self.currentViewController.httpManager attentionWithParameterDict:dict CompletionBlock:^(NSError *error)
             {
                 sender.userInteractionEnabled = YES;
                 if (error)
                 {
                     sender.selected = NO;
                     
                     //点赞失败
                     NSInteger tapCount = [_sureModel.tapModel.tapCount integerValue];
                     tapCount --;
                     _sureModel.tapModel.tapCount = [NSString stringWithFormat:@"%ld",tapCount];
                     _sureModel.tapModel.isTap = @"0";
                     [_sureModel.tapModel.tapHeaderArray removeObjectAtIndex:0];
                     [self updateTapViewWithTapModel:_sureModel.tapModel];
                 }
             }];
        }
    }
    
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _imageArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SureMainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];

    
    SUREFileModel *fileModel = _imageArray[indexPath.section];
    [cell updateImageCellWithFileModel:fileModel];
    
    __weak __typeof(self)weakSelf = self;

    cell.tapTagClick = ^(NSString *goodIDString)
    {
        [weakSelf sureImageTapTagClickWithGoodID:goodIDString];
//        weakSelf.sureTapTagClick(goodIDString);
    };
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x / ScreenWidth;
    _pageControl.currentPage = current;
}


- (void)updateTapViewWithTapModel:(SURETapModel *)tapModel
{
    [self.supportView updateTapViewWithCount:tapModel.tapCount HeaderArray:tapModel.tapHeaderArray];
}

/*
 *更新单元格数据
 */
- (void)updateSureMainCellDataWithModel:(SUREModel *)model
{
    _sureModel = model;
    
    
    
    
    _imageArray = model.imglistModelArray;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _imageArray.count;
    
    [self.sureCollectionView reloadData];
    self.sureCollectionView.scrollEnabled = YES;
    if (_imageArray.count == 1)
    {
        self.sureCollectionView.scrollEnabled = NO;
    }
    
    //偏移量为0
    _sureCollectionView.contentOffset = CGPointZero;
    
    self.statusLable.attributedText = [model.sureBody getAttriString];
    self.timeLable.text = model.inputtime;
    
    
    
    if ([model.tapModel.isTap isEqualToString:@"1"])
    {
        //关注
        self.supportButton.selected = YES;
    }
    else
    {
        //没有关注
        self.supportButton.selected = NO;
    }
    
    [self.supportView updateTapViewWithCount:model.tapModel.tapCount HeaderArray:model.tapModel.tapHeaderArray];
}



@end
