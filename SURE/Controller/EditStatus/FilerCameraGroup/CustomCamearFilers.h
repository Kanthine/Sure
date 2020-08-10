//
//  CustomCamearFilers.h
//  SURE
//
//  Created by 王玉龙 on 16/11/3.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GPUImageFilterGroup(addTitleColor)

@property (nonatomic , copy) NSString *title;

@property (nonatomic , strong) UIColor *color;


@end




@interface CustomCamearFilers : NSObject

+ (NSArray *)getfilerGroupArrayWithCamear:(GPUImageStillCamera *)videoCamera;

+ (GPUImageFilterGroup *)camearNormal;

+ (GPUImageFilterGroup *)camearAmatorkaFilter;

+ (GPUImageFilterGroup *)cameraMissEtikate;

+ (GPUImageFilterGroup *)cameraSoftEleganceFilter;

+ (GPUImageFilterGroup *)cameraNashvilleFilter;

+ (GPUImageFilterGroup *)cameraLordKelvinFilter;

+ (GPUImageFilterGroup *)cameraAmaroFilter;

+ (GPUImageFilterGroup *)cameraRiseFilter;

+ (GPUImageFilterGroup *)cameraHudsonFilter;

+ (GPUImageFilterGroup *)cameraXproIIFilter;

+ (GPUImageFilterGroup *)camera1977Filter;

+ (GPUImageFilterGroup *)cameraValenciaFilter;

+ (GPUImageFilterGroup *)cameraWaldenFilter;

+ (GPUImageFilterGroup *)cameraLomofiFilter;

+ (GPUImageFilterGroup *)cameraInkwellFilter;

+ (GPUImageFilterGroup *)cameraSierraFilter;

+ (GPUImageFilterGroup *)cameraEarlybirdFilter;

+ (GPUImageFilterGroup *)cameraSutroFilter;

+ (GPUImageFilterGroup *)cameraToasterFilter;

+ (GPUImageFilterGroup *)cameraBrannanFilter;

+ (GPUImageFilterGroup *)cameraHefeFilter;

+ (GPUImageFilterGroup *)cameraGlassSphereFilter;

@end



//@interface GPUImageFilterGroup(addTitleColor)
//
//@property (nonatomic , copy) NSString *title;
//
//@property (nonatomic , strong) UIColor *color;
//
//
//@end




//@interface CustomImageFilers : NSObject
//
//+ (NSArray *)getImageFilersArrayWithCamear:(UIImage *)image;
//
//+ (UIImage *)imageNormalFiler;
//
//+ (UIImage *)imageAmatorkaFilter;
//
//+ (UIImage *)imageMissEtikate;
//
//+ (UIImage *)imageSoftEleganceFilter;
//
//+ (UIImage *)imageNashvilleFilter;
//
//+ (UIImage *)imageLordKelvinFilter;
//
//+ (UIImage *)imageAmaroFilter;
//
//+ (UIImage *)imageRiseFilter;
//
//+ (UIImage *)imageHudsonFilter;
//
//+ (UIImage *)imageXproIIFilter;
//
//+ (UIImage *)image1977Filter;
//
//+ (UIImage *)imageValenciaFilter;
//
//+ (UIImage *)imageWaldenFilter;
//
//+ (UIImage *)imageLomofiFilter;
//
//+ (UIImage *)imageInkwellFilter;
//
//+ (UIImage *)imageSierraFilter;
//
//+ (UIImage *)imageEarlybirdFilter;
//
//+ (UIImage *)imageSutroFilter;
//
//+ (UIImage *)imageToasterFilter;
//
//+ (UIImage *)imageBrannanFilter;
//
//+ (UIImage *)imageHefeFilter;
//
//+ (UIImage *)imageGlassSphereFilter;
//
//@end
