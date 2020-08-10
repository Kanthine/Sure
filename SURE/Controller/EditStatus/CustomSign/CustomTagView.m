//
//  CustomTagView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/14.
//  Copyright © 2016年 longlong. All rights reserved.
//


#import "CustomTagView.h"

#import "SignView.h"

@interface CustomTagView ()

@property (nonatomic, strong) SignView *titleView;
@property (nonatomic,strong) TagPulsingView *pulsingView;
@property (nonatomic,assign) BOOL reverse;

@end

@implementation CustomTagView

-(id)initWithFrame:(CGRect)frame Title:(NSString *)titleString
{
    if (self = [super initWithFrame:frame])
    {
        _tagTitleString = titleString;
        self.pulsingView = [[TagPulsingView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self addSubview:self.pulsingView];
        self.pulsingView.center = CGPointMake(0, HEIGHT + 13 / 2.0);
        self.tagtype = kTagNomal;
        self.pulsingView.backgroundColor = [UIColor clearColor];
        
        self.titleView = [[SignView alloc]initWithFrame:CGRectMake(0, 0, 80, HEIGHT) Title:titleString];
        [self addSubview:_titleView];
   
        frame.size.width = CGRectGetWidth(self.titleView.frame);
        self.frame = frame;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:pan];
        
        
        
        
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesClick:)];
        longPressGes.minimumPressDuration = 1.5f;
        [self addGestureRecognizer:longPressGes];
    }
    return self;
}

- (void)longPressGesClick:(UILongPressGestureRecognizer *)longPressGes
{
    
    if (longPressGes.state == UIGestureRecognizerStateBegan)
    {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteTagClick:)])
        {
            [self.delegate deleteTagClick:self];
        }
    }
    else
    {
        
    }
    
    

}

-(void)drawRect:(CGRect)rect
{
    self.backgroundColor  = [UIColor clearColor];
}

-(void)setIconPoint:(CGPoint)iconPoint
{
    _iconPoint = iconPoint;
    self.frame = CGRectMake(iconPoint.x - HEIGHT / 2, iconPoint.y - HEIGHT / 2, self.frame.size.width, self.frame.size.height);
}

-(void)setTagtype:(TagType)tagtype
{
    _tagtype = tagtype;
    switch (_tagtype)
    {
        case kTagNomal:
            self.pulsingView.icon = [UIImage imageNamed:@"big_biaoqian_dian"];
            break;
        case kTagLocation:
            self.pulsingView.icon = [UIImage imageNamed:@"big_biaoqian_didian"];
            break;
        case kTagPeople:
            self.pulsingView.icon = [UIImage imageNamed:@"big_biaoqian_ren"];
            break;
        default:
            break;
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        //移动的偏移向量
        CGPoint offset = [pan translationInView:pan.view.superview];
        
        
        
        
//        BOOL isContent = CGRectContainsRect(_allowPanRect,pan.view.frame);
//        if (isContent == NO)
//        {
//            return;
//        }
        
        
        CGFloat allow_X = _allowPanRect.origin.x;
        CGFloat allow_Y = _allowPanRect.origin.y;
        CGFloat allow_Width = CGRectGetWidth(_allowPanRect);
        CGFloat allow_Height = CGRectGetHeight(_allowPanRect);
        
        
        
        //判定 不移出图片边界
        if ((pan.view.frame.origin.x - 12 < allow_X && offset.x < 0)
            || (pan.view.frame.origin.x + 3 > (allow_X + allow_Width - CGRectGetWidth(pan.view.frame) ) && offset.x > 0)
            || (pan.view.frame.origin.y - 3 < _allowPanRect.origin.y && offset.y < 0)
            || (pan.view.frame.origin.y + 15 > (allow_Y + allow_Height - CGRectGetHeight(pan.view.frame)) && offset.y > 0)
           )
        {
            return;
        }
        
        //做位移变换
        pan.view.transform = CGAffineTransformTranslate(pan.view.transform, offset.x, offset.y);
        //需要重置向量属性，为下一次调用进行初始化，恢复原来的值，
        //注意：如果不重置，偏移量值将会叠加
        [pan setTranslation:CGPointZero inView:pan.view.superview];
        
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateTagViewFrame:Title:)])
        {
            [self.delegate updateTagViewFrame:self.frame Title:_tagTitleString];
        }
        
    }
    
}



@end
