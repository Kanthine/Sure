//
//  SurePhotoModel.m
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SurePhotoModel.h"

#import "FilePathManager.h"

@implementation SurePhotoModel

- (NSMutableArray <NSDictionary *> *)brandTagArray
{
    if (_brandTagArray == nil)
    {
        _brandTagArray = [NSMutableArray array];
    }
    return _brandTagArray;
}


- (void)surePhotoModellocalization
{
    UIImage *image = nil;
    if (self.filerImage)
    {
        image = self.filerImage;
    }
    else
    {
        image = self.originalImage;
    }
    
    NSData *data = nil;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    
    NSString *filePath = [FilePathManager getImageFilePathString];
    
    BOOL isSuccess = [data writeToFile:filePath atomically:YES];
    
    
    if (isSuccess)
    {
        self.pathString = filePath;
    }
}

- (void)compressOriginalImageLength
{
    /*压缩至10KB*/
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        UIImage *image = [weakSelf.originalImage compressToMaxDataSizeKBytes:10 * 1024];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            weakSelf.originalImage = image;
        });
        
    });
    
    
}

@end
