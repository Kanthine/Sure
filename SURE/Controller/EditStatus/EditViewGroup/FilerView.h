//
//  FilerView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/2.
//  Copyright © 2016年 longlong. All rights reserved.
//



#import <UIKit/UIKit.h>



@class EditImageModel;

@interface FilerView : UIView

//@property (nonatomic ,assign) id <FilerViewDelegate> delegate;
@property (nonatomic ,strong) EditImageModel *imageModel;

- (void)showInView:(UIView *)superView;

@end


//点击过快、滤镜不同步问题
