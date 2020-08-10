//
//  UIButton+DefaultFontName.m
//  SURE
//
//  Created by 王玉龙 on 16/12/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "UIButton+DefaultFontName.h"

@implementation UIButton (DefaultFontName)

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
                      
                      
                      SEL originalSelector = @selector(titleLabel);
                      SEL swizzledSelector = @selector(DefaultBaseTitleLabel);
                      
                      
                      
                      Method originalMethod = class_getInstanceMethod(class, originalSelector);
                      Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
                      
                      
                      
                      BOOL didAddMethod =
                      class_addMethod(class,
                                      originalSelector,
                                      method_getImplementation(swizzledMethod),
                                      method_getTypeEncoding(swizzledMethod));
                      
                      if (didAddMethod) {
                          class_replaceMethod(class,
                                              swizzledSelector,
                                              method_getImplementation(originalMethod),
                                              method_getTypeEncoding(originalMethod));
                          
                      } else {
                          method_exchangeImplementations(originalMethod, swizzledMethod);
                      }
                  });
    
}



- (UILabel *)DefaultBaseTitleLabel
{
    UILabel *__lable = [self DefaultBaseTitleLabel];
    if (__lable)
    {
        UIFont * font = [UIFont fontWithName:FontName size:__lable.font.pointSize];
        __lable.font = font;
    }
    
    
    return __lable;
}

*/
@end
