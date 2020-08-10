//
//  ShareButtonView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/18.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UMSocialCore/UMSocialCore.h>

@protocol ShareButtonViewDelegate <NSObject>

@required

- (void)ownerCustomButtonClick:(UMSocialPlatformType)platformType;

@end


@interface ShareButtonView : UIView

@property (nonatomic ,weak) id <ShareButtonViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ImageTitle:(NSString *)imageTitleString;

@property (nonatomic ,assign) UMSocialPlatformType platformType;

@end

// 坐标 height = width + 25.0;
