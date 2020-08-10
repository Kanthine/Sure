//
//  BrandTagView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BrandTagView.h"

#import "SignView.h"
#import "BrandTagPointView.h"

@interface BrandTagView ()


@property (nonatomic, strong) SignView *titleView;
@property (nonatomic,strong) BrandTagPointView *pulsingView;
@property (nonatomic,assign) BOOL reverse;

@end

@implementation BrandTagView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)titleString TagIndex:(NSUInteger)index
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];

        _tagIndex = index;
        self.userInteractionEnabled = YES;
        
        _tagTitleString = titleString;
        self.pulsingView = [[BrandTagPointView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self addSubview:self.pulsingView];
        self.pulsingView.center = CGPointMake(0, BrandTagViewHEIGHT + 13 / 2.0);
        self.tagtype = BrandTagTypeNomal;
        self.pulsingView.backgroundColor = [UIColor clearColor];
        
        
        UIFont *titleFont = [UIFont fontWithName:LightFontName size:14];
        CGSize textSize = [titleString boundingRectWithSize:CGSizeMake(300, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil].size;

        
        UIImage *image = [UIImage imageNamed:@"textSign"];// 25 ： 19
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 25, 40) resizingMode:UIImageResizingModeStretch];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 10, 40)];
        imageView.image = image;
        imageView.alpha = .8f;
        [self addSubview:imageView];
        
        
        CGFloat lableHeight = CGRectGetHeight(frame) * 23.0 / 45.0;//文字底部高度
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 10, lableHeight)];
        titleLable.text = titleString;
        titleLable.textColor = [UIColor whiteColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = titleFont;
        [self addSubview:titleLable];
        
        
        
        frame.size.width = textSize.width + 10;
        self.frame = frame;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)buttonClick
{
    
    NSLog(@"%@",self.goodIDString);

    if (_isCanMove == NO && _isCanDelete == NO)
    {
        _tapBrandTagClick(self.goodIDString);
    }
    
    
    
}

- (void)setIsCanMove:(BOOL)isCanMove
{
    _isCanMove = isCanMove;
    
    if (isCanMove)
    {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:pan];
    }
}

- (void)setIsCanDelete:(BOOL)isCanDelete
{
    _isCanDelete = isCanDelete;
    
    if (isCanDelete)
    {
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesClick:)];
        longPressGes.minimumPressDuration = 1.5f;
        [self addGestureRecognizer:longPressGes];
    }
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
    self.frame = CGRectMake(iconPoint.x - BrandTagViewHEIGHT / 2, iconPoint.y - BrandTagViewHEIGHT / 2, self.frame.size.width, self.frame.size.height);
}

-(void)setTagtype:(BrandTagType)tagtype
{
    _tagtype = tagtype;
    switch (_tagtype)
    {
        case BrandTagTypeNomal:
            self.pulsingView.icon = [UIImage imageNamed:@"big_biaoqian_dian"];
            break;
        case BrandTagTypeLocation:
            self.pulsingView.icon = [UIImage imageNamed:@"big_biaoqian_didian"];
            break;
        case BrandTagTypePeople:
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
        
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateTagViewFrame:Title:BrandIDStr:GoodsID:TagIndex:)])
        {
            [self.delegate updateTagViewFrame:self.frame Title:_tagTitleString BrandIDStr:self.brandIDString GoodsID:self.goodIDString TagIndex:_tagIndex];
            
        }
        
    }
    
}



@end
