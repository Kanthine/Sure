//
//  ShopCarTableViewCell.h
//  SURE
//
//  Created by 王玉龙 on 16/10/25.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,ShopCarTableCellType)
{
    ShopCarTableCellTypeNormal = 0,
    ShopCarTableCellTypeEdit,
};


@class ShopCarTableViewCell;

@protocol ShopCarTableViewCellDelegate <NSObject>

// 点击单个商品选择按钮回调
- (void)commoditySelectedStatusClick:(ShopCarTableViewCell *)cell isSelected:(BOOL)choosed;
// 商品的增加或者减少回调
- (void)plusOrMinusCommodityNumberClick:(ShopCarTableViewCell *)cell tag:(NSInteger)tag;
//删除 商品
- (void)deleteProductClick:(ShopCarTableViewCell *)cell;
// 点击编辑规格按钮下拉回调
- (void)editingProductAttributeInfoClick:(ShopCarTableViewCell *)cell;

// 点击图片回调到主页显示
- (void)clickProductIMG:(ShopCarTableViewCell *)cell;


@end


@interface ShopCarTableViewCell : UITableViewCell

@property (nonatomic,assign) id<ShopCarTableViewCellDelegate>delegate;



@property (weak, nonatomic) IBOutlet UIButton *leftChooseButton;
@property (weak, nonatomic) IBOutlet UIButton *commodityImageButton;



@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UILabel *commodityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *commodityKindLable;
@property (weak, nonatomic) IBOutlet UILabel *commodityPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *commodityNumberLable;


@property (weak, nonatomic) IBOutlet UIView *editStatusView;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *currentKindLable;
@property (weak, nonatomic) IBOutlet UIButton *changeKindButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteCommodityButton;





- (void)updateCellData;




@end
