//
//  OperationPhotoVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationPhotoVC : UIViewController

@property (nonatomic ,strong) NSMutableArray *imageArray;//EditImageModel对象

@end

//删除照片  长按删除 ok
//滤镜功能 左右滑动  (滤镜是在原有图片的基础上添加的  添加滤镜名称)
// 添加 标签 (需要记录：标签相对于ImageSize 的相对位置，在计算出Image的坐标位置 。算出 标签的位置 即屏幕适配)
// 添加照片         (传值，避免重复添加)
// 修饰照片
//自定义标签视图类 有滤镜 有标签属性


