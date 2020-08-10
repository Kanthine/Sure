//
//  StaticFilerChooseView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/23.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^ FilerChooseBlock)(NSInteger idx);

@interface StaticFilerChooseView : UIView

{
    FilerChooseBlock _filterChooserBlock;
}

@property (nonatomic , strong) UIImage *filterImage;

- (void)addSelectedEvent:(FilerChooseBlock)filterChooseBlock;

@end


