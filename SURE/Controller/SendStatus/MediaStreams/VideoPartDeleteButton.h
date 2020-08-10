//
//  VideoPartDeleteButton.h
//  SURE
//
//  Created by 王玉龙 on 16/12/26.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    VideoPartDeleteButtonStyleDelete,
    VideoPartDeleteButtonStyleNormal,
    VideoPartDeleteButtonStyleDisable,
}VideoPartDeleteButtonStyle;

@interface VideoPartDeleteButton : UIButton

@property (assign, nonatomic) VideoPartDeleteButtonStyle deleteStyle;


- (void)setButtonStyle:(VideoPartDeleteButtonStyle)style;

@end
