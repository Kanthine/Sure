//
//  FilerChooseView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/3.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^ FilerChooseBlock)(GPUImageFilterGroup *filter, NSInteger idx);

@interface FilerChooseView : UIView


{
    FilerChooseBlock _filterChooserBlock;
}

@property (nonatomic , strong) UIImage *filterImage;

- (void)addFilters:(NSArray *)filtersArray;

- (void)addSelectedEvent:(FilerChooseBlock)filterChooseBlock;

@end
