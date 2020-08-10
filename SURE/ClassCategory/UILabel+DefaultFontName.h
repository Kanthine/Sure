//
//  UILabel+DefaultFontName.h
//  SURE
//
//  Created by 王玉龙 on 16/12/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DefaultFontName)

@end


/*
 一、需求背景介绍
 在项目比较成熟的基础上，遇到了这样一个需求，应用中需要引入新的字体，需要更换所有Label的默认字体，但是同时，对于一些特殊设置了字体的label又不需要更换。乍看起来，这个问题确实十分棘手，首先项目比较大，一个一个设置所有使用到的label的font工作量是巨大的，并且在许多动态展示的界面中，可能会漏掉一些label，产生bug。其次，项目中的label来源并不唯一，有用代码创建的，有xib和storyBoard中的，这也将浪费很大的精力。这种情况下，我们可能会有下面两种处理方式。
 
 二、处理方式
 
 1、使用框架
 
 创建我们自己的BaseLabel类，在其中进行默认字体的设置，并且并不影响在使用过程中特殊设置字体的label，这种方式可以满足我们的需求，但是并不适于我们的场景，项目已经成熟，重建一个label基类，来让所有的UILabel都换成它的工作量不会比重新设置所有label字体的工作量小太多。但这也是有优势的，至少如果下次再换字体，我们就不用麻烦了。
 
 2、使用runtime替换UILabel初始化方法
 
 这是最简单方便的方法，我们可以使用runtime机制替换掉UILabel的初始化方法，在其中对label的字体进行默认设置。因为Label可以从initWithFrame、init和nib文件三个来源初始化，所以我们需要将这三个初始化的方法都替换掉。
 */
