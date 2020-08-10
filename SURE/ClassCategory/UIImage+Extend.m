//
//  UIImage+Extend.m
//  SURE
//
//  Created by 王玉龙 on 16/10/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)

#pragma mark - 导航栏

+ (UIImage *)loadNavBarBackgroundImage
{
    UIImage *oldImage = [UIImage imageNamed:@"navBar"];
    
    UIImage *newImage = [oldImage scaleToSize:CGSizeMake(ScreenWidth, 64)];
    
    return newImage;
}

- (UIImage *)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 切 三角

- (UIImage * )cropImageWithRect:(CGSize)size HeightScale:(CGFloat)scale
{
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    //先切掉 多余的 再裁三角形
    //裁掉多余的 ，而非 压缩多余的
    //1 、 照片太宽 如扁平型的 高度拉伸后 裁剪多余的宽度 screenScale < imageScale
    //2、  照片太窄 瘦高型的   宽度拉伸后 裁剪多余的高度 screenScale > imageScale
    
    UIImage *scaleImage = self ;//[self cropImgRect:size];
    
    
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//设置上下文
    
    
    // 切 三角形
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddLineToPoint(currentContext, width, 0);
    CGContextAddLineToPoint(currentContext, width, height * scale);
    CGContextAddLineToPoint(currentContext, 0, height);
    CGContextClosePath(currentContext);
    CGContextClip(currentContext);
    
    
    //坐标系转换
    //因为CGContextDrawImage会使用Quartz内的以左下角为(0,0)的坐标系
    CGContextTranslateCTM(currentContext, 0, height);
    CGContextScaleCTM(currentContext, 1, -1);
    CGContextDrawImage(currentContext, CGRectMake(0, 0, width, height), [scaleImage CGImage]);
    
    
    //结束绘画
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)scaleToSize916
{
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat imageScale = imageWidth / imageHeight;
    
    CGFloat defaultScale = 16.0 / 9.0;
    
    if (imageScale < defaultScale)
    {
        // 宽度小 拉宽 裁高
        
        CGFloat newImageHeight = imageWidth / defaultScale;
        CGFloat y = (imageHeight - newImageHeight) / 2.0;
        
        CGRect frame = CGRectMake(0, y , imageWidth, newImageHeight);
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], frame);
        UIImage* subImage = [UIImage imageWithCGImage: imageRef];
        CGImageRelease(imageRef);
        
        return subImage;

        
    }
    else
    {
        // 高度小 拉高 裁宽
        
        
        CGFloat newImageWidth = imageHeight * defaultScale;
        CGFloat x = (imageWidth - newImageWidth) / 2.0;
        
        CGRect frame = CGRectMake(x, 0 , newImageWidth, imageHeight);
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], frame);
        UIImage* subImage = [UIImage imageWithCGImage: imageRef];
        CGImageRelease(imageRef);
        
        return subImage;

        
    }
    
    
    
    
    
}

#pragma mark - 拍照

- (UIImage *)cropCameraImage
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat y = 44.0 / ScreenHeight * height;
    
    // 1080 * 1920  0.5625
    // 320 * 576  0.555
    // 3.375 3.333
    //
    NSLog(@"width ======= %f",width);
    
    NSLog(@"height ======= %f",height);

    NSLog(@"y ======= %f",y);

    
    CGRect frame = CGRectMake(0, y * 3, width, width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], frame);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}

//修改 图片 方向
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp)
    {
        return self;
    }
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage *)compressToMaxDataSizeKBytes:(CGFloat)size
{
    NSData * data = UIImageJPEGRepresentation(self, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f)
    {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(self, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes)
        {
            break;
        }
        else
        {
            lastData = dataKBytes;
        }
    }
    
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}

@end
