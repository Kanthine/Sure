//
//  BrandMenuView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol BrandMenuViewDelegate <NSObject>

//@required
//
//- (void)brandMenuViewButtonClick:(BOOL)isRequest OrderStr:(NSString *)orderByStr Des:(NSString *)desc;
//
//@end

@interface BrandMenuView : UIView

//@property (nonatomic ,weak) id <BrandMenuViewDelegate> delegate;

/*
 *orderByStr 分类参数
 *
 *desc 排序参数
 */
@property (nonatomic ,copy) void(^ brandMenuViewButtonClick)(BOOL isRequest , NSString *orderByStr , NSString *desc);

@end
