//
//  PhotoPreviewBigScrollView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define kZoomStep 2


#import "PhotoPreviewBigScrollView.h"

#import "ScanBigPhotoScrollView.h"
#import "BrandTagView.h"
#import "SurePhotoModel.h"

@interface PhotoPreviewBigScrollView()

<UIScrollViewDelegate>

@property (strong , nonatomic) UIImageView *imageView;

@end


@implementation PhotoPreviewBigScrollView

{
    CGPoint  _pointToCenterAfterResize;
    CGFloat  _scaleToRestoreAfterResize;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView
{
    self.delegate = self;
    self.imageView = nil;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = TRUE;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.imageView.frame = frameToCenter;
    
    CGPoint contentOffset = self.contentOffset;
    
    // ensure horizontal offset is reasonable
    if (frameToCenter.origin.x != 0.0)
        contentOffset.x = 0.0;
    
    // ensure vertical offset is reasonable
    if (frameToCenter.origin.y != 0.0)
        contentOffset.y = 0.0;
    
    self.contentOffset = contentOffset;
    
    // ensure content insert is zeroed out using translucent navigation bars
    self.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging)
    {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    if (sizeChanging)
    {
        [self recoverFromResizing];
    }
}

#pragma mark - Public Implementation
#pragma mark -

- (void)prepareForReuse
{
    // start by dropping any views and resetting the key properties
    if (self.imageView != nil)
    {
        for (UIGestureRecognizer *gestureRecognizer in self.imageView.gestureRecognizers) {
            [self.imageView removeGestureRecognizer:gestureRecognizer];
        }
    }
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.imageView = nil;
}

- (void)displayImage:(UIImage *)image
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.userInteractionEnabled = TRUE;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    
    self.contentSize = self.imageView.frame.size;
    
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setZoomScale:self.minimumZoomScale animated:FALSE];
}

#pragma mark - Support Methods

- (void)updateZoomScale:(CGFloat)newScale
{
    CGPoint center = CGPointMake(self.imageView.bounds.size.width/ 2.0, self.imageView.bounds.size.height / 2.0);
    [self updateZoomScale:newScale withCenter:center];
}

- (void)updateZoomScaleWithGesture:(UIGestureRecognizer *)gestureRecognizer newScale:(CGFloat)newScale
{
    CGPoint center = [gestureRecognizer locationInView:gestureRecognizer.view];
    [self updateZoomScale:newScale withCenter:center];
}

- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center
{
    assert(newScale >= self.minimumZoomScale);
    assert(newScale <= self.maximumZoomScale);
    
    if (self.zoomScale != newScale)
    {
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:center];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    assert(scale >= self.minimumZoomScale);
    assert(scale <= self.maximumZoomScale);
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.size.height = self.frame.size.height / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    
    CGSize boundsSize = self.bounds.size;
    
    CGFloat minScale = 0.25;
    
    if (self.imageView.bounds.size.width > 0.0 && self.imageView.bounds.size.height > 0.0)
    {
        // calculate min/max zoomscale
        CGFloat xScale = boundsSize.width  / self.imageView.bounds.size.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / self.imageView.bounds.size.height;   // the scale needed to perfectly fit the image height-wise
        
        
        minScale = MIN(xScale, yScale);
    }
    
    CGFloat maxScale = minScale * (kZoomStep * 2);
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.imageView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing
{
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:self.imageView];
    
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

#pragma mark - UIScrollViewDelegate Methods
#pragma mark -
// 返回将要缩放的UIView对象。要执行多次
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)updateBrandTag:(NSMutableArray<NSDictionary *> *)brandTagArray
{
    [self.imageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([obj isKindOfClass:[BrandTagView class]])
        {
            [obj removeFromSuperview];
        }
    }];
    
    
    [brandTagArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        CGFloat x = [[obj objectForKey:ImageWidthRateKey] floatValue] * ScreenWidth;
        CGFloat y = [[obj objectForKey:ImageHeightRateKey] floatValue] * ScreenWidth;
        
        BrandTagView * tagView = [[BrandTagView alloc]initWithFrame:CGRectMake(x, y, 100, BrandTagViewHEIGHT) Title:[obj objectForKey:ImageBrandTitle] TagIndex:idx];
        tagView.isCanMove = NO;
        tagView.isCanDelete = NO;
        
        NSLog(@"BrandTagView ====== %@",tagView);
        tagView.backgroundColor = [UIColor clearColor];
        [self.imageView addSubview:tagView];
    }];
    
}

@end
