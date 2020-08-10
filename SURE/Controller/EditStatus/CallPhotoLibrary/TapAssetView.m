//
//  TapAssetView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "TapAssetView.h"

@interface TapAssetView()

@property(nonatomic,retain)UIImageView *selectView;

@end

@implementation TapAssetView

static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

+ (void)initialize
{
    checkedIcon     = [UIImage imageNamed:@"AssetsPickerChecked@2x.png"];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    disabledColor   = [UIColor colorWithWhite:1 alpha:0.9];
}

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        _selectView=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-checkedIcon.size.width, frame.size.height-checkedIcon.size.height, checkedIcon.size.width, checkedIcon.size.height)];
        [self addSubview:_selectView];
    }
    
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_disabled)
    {
        return;
    }
    
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldTap)])
    {
        if (![_delegate shouldTap]&&!_selected)
        {
            return;
        }
    }
    
    if ((_selected=!_selected))
    {
        self.backgroundColor=selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else
    {
        self.backgroundColor=[UIColor clearColor];
        [_selectView setImage:nil];
    }
    
    //点击之后 选中状态
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(touchSelect:)])
    {
        [_delegate touchSelect:_selected];
    }
}

-(void)setDisabled:(BOOL)disabled
{
    _disabled=disabled;
    if (_disabled)
    {
        self.backgroundColor=disabledColor;
    }
    else
    {
        self.backgroundColor=[UIColor clearColor];
    }
}

-(void)setSelected:(BOOL)selected
{
    if (_disabled) {
        self.backgroundColor=disabledColor;
        [_selectView setImage:nil];
        return;
    }
    
    _selected=selected;
    if (_selected)
    {
        self.backgroundColor=selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else
    {
        self.backgroundColor=[UIColor clearColor];
        [_selectView setImage:nil];
    }
}



@end
