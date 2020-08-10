//
//  ECDeviceScrollView.m
//  ECSDKDemo_OC
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import "ECDeviceVoiceRecordView.h"

#define ToolbarRecordViewHeight 183.0f

@interface ECDeviceVoiceRecordView ()
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *hightImageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIResponder<UITextInput> *inputView;
@end

@implementation ECDeviceVoiceRecordView
{
    UIScrollView* myscrollview;
    
    NSMutableArray* markimgs;
    
    
    NSInteger _num;
    UILabel *_Label;
    UILabel *_Label2;
}

+ (instancetype)sharedInstanced {
    static dispatch_once_t onceToken;
    static ECDeviceVoiceRecordView *voiceRecordView = nil;
    dispatch_once(&onceToken, ^{
        voiceRecordView = [[[self class] alloc] init];
    });
    return voiceRecordView;
}

-(instancetype)init {
    self=[super init];
    if (self) {
        _imageArray = [NSMutableArray array];
        _hightImageArray = [NSMutableArray array];
        _titleArray = [NSMutableArray array];
        _inputView = [[UITextView alloc] init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray = [NSMutableArray array];
        _hightImageArray = [NSMutableArray array];
        _titleArray = [NSMutableArray array];
        _inputView = [[UITextView alloc] init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageItems:(NSArray*)imageItems HightImageItems:(NSArray*)HightImageItems titleLabel:(NSArray*)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [_imageArray removeAllObjects];
        [_hightImageArray removeAllObjects];
        [_titleArray removeAllObjects];
        [_imageArray addObjectsFromArray:imageItems];
        [_hightImageArray addObjectsFromArray:HightImageItems];
        [_titleArray addObjectsFromArray:titleArray];

        [self buildUI];
        
    }
    return self;
}

- (void)setImages:(NSArray*)imageArray hightImages:(NSArray*)hightImageArray title:(NSArray*)titleArray {
    [_imageArray removeAllObjects];
    [_hightImageArray removeAllObjects];
    [_titleArray removeAllObjects];
    [_imageArray addObjectsFromArray:imageArray];
    [_hightImageArray addObjectsFromArray:hightImageArray];
    [_titleArray addObjectsFromArray:titleArray];
}

- (void)buildUI {
    self.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    _num = _imageArray.count;
    myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0.0f, self.frame.size.width, self.frame.size.height)];
    myscrollview.backgroundColor = [UIColor whiteColor];
    myscrollview.scrollsToTop = NO;
    myscrollview.showsHorizontalScrollIndicator = NO;
    myscrollview.delegate = self;
    myscrollview.pagingEnabled = YES;
    [self addSubview:myscrollview];
    
    NSInteger maxCount = _imageArray.count>_titleArray.count?_imageArray.count:_titleArray.count;

    for (int i = 0; i<maxCount; i++) {
        //状态
        _Label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2+i *[UIScreen mainScreen].bounds.size.width, 5.0f, 200, 17.0f)];
        _Label.backgroundColor = [UIColor clearColor];
        _Label.textAlignment = NSTextAlignmentCenter;
        _Label.text=_titleArray[i];
        _Label.textColor = [UIColor blackColor];
        _Label.font = [UIFont systemFontOfSize:15.0f];
        [myscrollview addSubview:_Label];
        
        UIButton* _imgviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgviewBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2 +i *[UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(_Label.frame)+5, 100, 100);
        _imgviewBtn.contentMode = UIViewContentModeScaleAspectFill;
        _imgviewBtn.userInteractionEnabled = YES;
        _imgviewBtn.backgroundColor = [UIColor clearColor];
        [_imgviewBtn setBackgroundImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
        [_imgviewBtn setBackgroundImage:[UIImage imageNamed:_hightImageArray[i]] forState:UIControlStateHighlighted];
        
        [_imgviewBtn addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_imgviewBtn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_imgviewBtn addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_imgviewBtn addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragOutside];
        [_imgviewBtn addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragInside];
        [myscrollview addSubview:_imgviewBtn];
    }
    
    myscrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*_num, myscrollview.bounds.size.height);
    
    markimgs = [NSMutableArray array];
    
    
    
    [self loadPageControlSubViews];
}

- (void)loadPageControlSubViews{

    

    
    [self reloadPageViewSize];
}

- (void)reloadPageViewSize{
    CGSize pageSize_def = CGSizeMake(12, 12);
    CGSize pageSize_cur = CGSizeMake(12, 12);
    
    if (_defaultPageIndicatorImage) {
        pageSize_def = _defaultPageIndicatorImage.size;
        
    }
    if (_currentPageIndicatorImage) {
        pageSize_cur = _currentPageIndicatorImage.size;
    }
    
}

- (void)attachVoiceRecordViewToToobar:(UIView *)toolBar WithInputView:(UIResponder<UITextInput> *)inputView {
    
    self.delegate = toolBar;
    _inputView = inputView;
    if (inputView.isFirstResponder) {
        [inputView resignFirstResponder];
    }
    if (!([self platformSource] || _titleArray.count>0 || _imageArray.count>0)) {
        NSLog(@"%@:请先设置数据源",NSStringFromClass([self class]));
        return;
    }
    CGRect superFrame = toolBar.superview.frame;
    self.frame = CGRectMake(0.0f, superFrame.size.height-ToolbarRecordViewHeight, toolBar.frame.size.width, ToolbarRecordViewHeight);
   
    [self buildUI];
    CGRect frame = toolBar.frame;
    frame.origin.y = self.frame.origin.y-frame.size.height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onclickedVoiceRecordView:toolBarWillChangeFame:completion:)]) {
        [self.delegate onclickedVoiceRecordView:self toolBarWillChangeFame:frame completion:^{
            toolBar.frame = frame;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGRect moreFrame = self.frame;
                moreFrame.origin.y = toolBar.superview.bounds.size.height;
                self.frame = moreFrame;
                [toolBar.superview addSubview:self];
                [UIView animateWithDuration:0.15 delay:0 options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState) animations:^{
                    self.frame = CGRectMake(0.0f, superFrame.size.height-ToolbarRecordViewHeight, toolBar.frame.size.width, ToolbarRecordViewHeight);
                } completion:^(BOOL finished){
                }];
            });
        }];
    }
}

- (BOOL)platformSource
{
    if ([self respondsToSelector:@selector(setImages:hightImages:title:)])
    {
        [self setImages:@[@"press_talk_icon"] hightImages:@[@"press_talk_icon_on",] title:@[@"按住说话"]];
        return YES;
    }
    return NO;
}

- (void)switchToDefaultKeyboard {
    [_inputView becomeFirstResponder];
    [self removeFromSuperview];
}

-(void)exitVoiceRecordView:(UIView *)toolBar {
    if (self.superview && !_inputView.isFirstResponder) {
        CGRect frame = toolBar.frame;
        frame.origin.y +=ToolbarRecordViewHeight;
        if (self.delegate && [self.delegate respondsToSelector:@selector(onclickedVoiceRecordView:toolBarWillChangeFame:completion:)]) {
            [self.delegate onclickedVoiceRecordView:self toolBarWillChangeFame:frame completion:^{
                toolBar.frame = frame;
            }];
        }
    }
    [self removeFromSuperview];
}
#pragma mark - 设置页面基本属性
- (void)setPages:(NSInteger)pages{
    //未实现
    _num = pages;
    
    [markimgs removeAllObjects];
    

    
    [self loadPageControlSubViews];
}

- (void)setPagingEnabled:(BOOL)pagingEnabled{
    _pagingEnabled = pagingEnabled;
    myscrollview.pagingEnabled = _pagingEnabled;
}

- (void)setHiddenPageControl:(BOOL)hiddenPageControl{
    _hiddenPageControl = hiddenPageControl;
    
}

- (void)setDefaultPageIndicatorImage:(UIImage *)defaultPageIndicatorImage{
    _defaultPageIndicatorImage = defaultPageIndicatorImage;
    for (UIImageView* imgv in markimgs) {
        //
        imgv.image = defaultPageIndicatorImage;
        imgv.backgroundColor = [UIColor clearColor];
    }
    [self reloadPageViewSize];
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage{
    
    _currentPageIndicatorImage = currentPageIndicatorImage;

    [self reloadPageViewSize];
}

#pragma mark - ECDeviceVoiceRecordViewDelegate
- (void)recordButtonTouchDown {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordButtonTouchDown:)]) {
        [self.delegate recordButtonTouchDown:self];
    }
}

- (void)recordButtonTouchUpInside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordButtonTouchUpInside:)]) {
        [self.delegate recordButtonTouchUpInside:self];
    }
}

- (void)recordButtonTouchUpOutside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordButtonTouchUpOutside:)]) {
        [self.delegate recordButtonTouchUpOutside:self];
    }
}

- (void)recordDragOutside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordDragOutside:)]) {
        [self.delegate recordDragOutside:self];
    }
}

- (void)recordDragInside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordDragInside:)]) {
        [self.delegate recordDragInside:self];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //
    CGFloat scroll_content_w = myscrollview.contentSize.width-myscrollview.bounds.size.width;
    CGFloat scroll_curr_x = scrollView.contentOffset.x;

}
@end