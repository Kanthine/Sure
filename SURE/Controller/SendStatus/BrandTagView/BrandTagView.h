//
//  BrandTagView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define BrandTagViewHEIGHT 45

#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
    BrandTagTypeNomal,
    BrandTagTypeLocation,
    BrandTagTypePeople,
} BrandTagType;


@class BrandTagView;
@protocol BrandTagViewDelegate <NSObject>

@required
- (void)deleteTagClick:(BrandTagView *)tagView;
- (void)updateTagViewFrame:(CGRect)frame Title:(NSString *)titleString BrandIDStr:(NSString *)brandIDString GoodsID:(NSString *)goodsIDstr TagIndex:(NSUInteger)index;

@end


@interface BrandTagView : UIView

@property (nonatomic ,weak) id <BrandTagViewDelegate> delegate;

@property (nonatomic ,copy) NSString *goodIDString;
@property (nonatomic ,copy) NSString *brandIDString;

@property (nonatomic,assign) BrandTagType tagtype;
@property (nonatomic,assign) CGPoint  iconPoint; //icon中心点

//点击标签，进入商品
@property (nonatomic ,copy) void(^ tapBrandTagClick)(NSString *goodIDString);

/*
 *拖动标签 
 *必备参数
 */
@property (nonatomic,assign) BOOL isCanMove;

/*
 *删除标签
 *必备参数
 */
@property (nonatomic,assign) BOOL isCanDelete;
@property (nonatomic ,assign) NSInteger tagIndex;

@property (nonatomic,assign) CGRect allowPanRect;
@property (nonatomic ,copy)  NSString *tagTitleString;

- (instancetype) initWithFrame:(CGRect)frame Title:(NSString *)titleString TagIndex:(NSUInteger)index;

@end
