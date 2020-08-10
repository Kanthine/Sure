//
//  TapAssetView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapAssetViewDelegate <NSObject>

-(void)touchSelect:(BOOL)select;
-(BOOL)shouldTap;

@end


@interface TapAssetView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<TapAssetViewDelegate> delegate;

@end
