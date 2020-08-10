//
//  PhotoPreviewViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SurePhotoModel;
@interface PhotoPreviewViewController : UIViewController

- (instancetype)initWithModelArray:(NSMutableArray<SurePhotoModel *>*)modelArray IndexPath:(NSInteger)index;

@end


