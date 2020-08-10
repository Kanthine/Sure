//
//  CustomTagView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define HEIGHT 45


#import <UIKit/UIKit.h>

#import "TagPulsingView.h"

typedef enum : NSUInteger
{
    kTagNomal,
    kTagLocation,
    kTagPeople,
} TagType;


@class CustomTagView;
@protocol CustomTagViewDelegate <NSObject>

@required
- (void)deleteTagClick:(CustomTagView *)tagView;
- (void)updateTagViewFrame:(CGRect)frame Title:(NSString *)titleString;
@end

@interface CustomTagView : UIView

@property (nonatomic ,weak) id <CustomTagViewDelegate> delegate;

@property (nonatomic,assign) TagType tagtype;
@property (nonatomic,assign) CGPoint  iconPoint; //icon中心点
@property (nonatomic,assign) BOOL isEdit;  //是否可以编辑
@property (nonatomic,assign) CGRect allowPanRect;
@property (nonatomic ,copy)  NSString *tagTitleString;
- (instancetype) initWithFrame:(CGRect)frame Title:(NSString *)titleString;



@end
