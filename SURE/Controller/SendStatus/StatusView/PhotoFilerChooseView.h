//
//  PhotoFilerChooseView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoFilerChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame ThumbnailImage:(UIImage *)thumbnailImage;


@property (nonatomic ,copy) void(^ didSelectItemAtIndexPath)(NSIndexPath *indexPath,UIImage *filerImage);

@end
