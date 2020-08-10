//
//  VideoPartDeleteButton.m
//  SURE
//
//  Created by 王玉龙 on 16/12/26.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "VideoPartDeleteButton.h"

#define DELETE_BTN_NORMAL_IAMGE @"record_delete_normal.png"
#define DELETE_BTN_DELETE_IAMGE @"record_deletesure_normal.png"
#define DELETE_BTN_DISABLE_IMAGE @"record_delete_disable.png"

@interface VideoPartDeleteButton ()


@end

@implementation VideoPartDeleteButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize
{
    [self setImage:[UIImage imageNamed:DELETE_BTN_NORMAL_IAMGE] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:DELETE_BTN_DISABLE_IMAGE] forState:UIControlStateDisabled];
}

- (void)setButtonStyle:(VideoPartDeleteButtonStyle)style
{
    self.deleteStyle = style;
    switch (style) {
        case VideoPartDeleteButtonStyleNormal:
        {
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:DELETE_BTN_NORMAL_IAMGE] forState:UIControlStateNormal];
        }
            break;
        case VideoPartDeleteButtonStyleDisable:
        {
            self.enabled = NO;
        }
            break;
        case VideoPartDeleteButtonStyleDelete:
        {
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:DELETE_BTN_DELETE_IAMGE] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

@end
