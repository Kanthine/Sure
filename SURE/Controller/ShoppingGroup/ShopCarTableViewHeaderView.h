//
//  ShopCarTableViewHeaderView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/25.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ShopCarTableViewHeaderView;

@protocol ShopCarTableViewHeaderViewDelegate <NSObject>

// 点击buyer选择按钮回调
- (void)brandSelected:(ShopCarTableViewHeaderView *)sender;
// 点击buyer编辑回调按钮
- (void)brandEditingSelected:(ShopCarTableViewHeaderView *)sender;

@end



@interface ShopCarTableViewHeaderView : UIView


@property (nonatomic,assign) NSInteger sectionIndex;
@property (nonatomic,assign) id<ShopCarTableViewHeaderViewDelegate>delegate;


@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *brandLogoImageView;
@property (weak, nonatomic) IBOutlet UIButton *brandDetaileButton;
@property (weak, nonatomic) IBOutlet UIButton *brandEditButton;



@end
