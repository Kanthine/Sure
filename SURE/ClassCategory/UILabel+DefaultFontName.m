//
//  UILabel+DefaultFontName.m
//  SURE
//
//  Created by 王玉龙 on 16/12/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "UILabel+DefaultFontName.h"

@implementation UILabel (DefaultFontName)


/**
 *每个NSObject的子类都会调用下面这个方法 在这里将init方法进行替换，使用我们的新字体
 *如果在程序中又特殊设置了字体 则特殊设置的字体不会受影响 但是不要在Label的init方法中设置字体
 *从init和initWithFrame和nib文件的加载方法 都支持更换默认字体
 */

/*
+(void)load
{
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        Class class = [self class];
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        //替换三个方法
        SEL originalSelector = @selector(init);
        SEL originalSelector2 = @selector(initWithFrame:);
        SEL originalSelector3 = @selector(awakeFromNib);
        SEL swizzledSelector = @selector(DefaultBaseInit);
        SEL swizzledSelector2 = @selector(DefaultBaseInitWithFrame:);
        SEL swizzledSelector3 = @selector(DefaultBaseAwakeFromNib);
        
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method originalMethod2 = class_getInstanceMethod(class, originalSelector2);
        Method originalMethod3 = class_getInstanceMethod(class, originalSelector3);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSelector2);
        Method swizzledMethod3 = class_getInstanceMethod(class, swizzledSelector3);
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        BOOL didAddMethod2 =
        class_addMethod(class,
                        originalSelector2,
                        method_getImplementation(swizzledMethod2),
                        method_getTypeEncoding(swizzledMethod2));
        BOOL didAddMethod3 =
        class_addMethod(class,
                        originalSelector3,
                        method_getImplementation(swizzledMethod3),
                        method_getTypeEncoding(swizzledMethod3));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
            
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        if (didAddMethod2) {
            class_replaceMethod(class,
                                swizzledSelector2,
                                method_getImplementation(originalMethod2),
                                method_getTypeEncoding(originalMethod2));
        }else {
            method_exchangeImplementations(originalMethod2, swizzledMethod2);
        }
        if (didAddMethod3)
        {
            class_replaceMethod(class,
                                swizzledSelector3,
                                method_getImplementation(originalMethod3),
                                method_getTypeEncoding(originalMethod3));
        }else
        {
            method_exchangeImplementations(originalMethod3, swizzledMethod3);
        }
        
        
        
        
        
        
        SEL originalSelector4 = @selector(font);
        SEL swizzledSelector4 = @selector(DefaultBaseFont);
        
        
        
        Method originalMethod4 = class_getInstanceMethod(class, originalSelector4);
        Method swizzledMethod4 = class_getInstanceMethod(class, swizzledSelector4);
        
        
        
        BOOL didAddMethod4 =
        class_addMethod(class,
                        originalSelector4,
                        method_getImplementation(swizzledMethod4),
                        method_getTypeEncoding(swizzledMethod4));
        
        if (didAddMethod4)
        {
            class_replaceMethod(class,
                                swizzledSelector4,
                                method_getImplementation(originalMethod4),
                                method_getTypeEncoding(originalMethod4));
            
        }
        else
        {
            method_exchangeImplementations(originalMethod4, swizzledMethod4);
        }

    });

}
 */



/**
 *在这些方法中将你的字体名字换进去
 */
- (instancetype)DefaultBaseInit
{
    id __self = [self DefaultBaseInit];
    UIFont * font = [UIFont fontWithName:FontName size:self.font.pointSize];
    if (font) {
        self.font=font;
    }
    return __self;
}

-(instancetype)DefaultBaseInitWithFrame:(CGRect)rect
{
    id __self = [self DefaultBaseInitWithFrame:rect];
    UIFont * font = [UIFont fontWithName:FontName size:self.font.pointSize];
    if (font)
    {
        self.font=font;
    }
    return __self;
}

-(void)DefaultBaseAwakeFromNib
{
    [self DefaultBaseAwakeFromNib];
    UIFont * font = [UIFont fontWithName:FontName size:self.font.pointSize];
    if (font)
    {
        self.font=font;
    }
}

- (UIFont *)DefaultBaseFont
{
    UIFont * font = [self DefaultBaseFont];
    
    if (font)
    {
        font = [UIFont fontWithName:FontName size:font.pointSize];
    }
    
    return font;
}



@end
