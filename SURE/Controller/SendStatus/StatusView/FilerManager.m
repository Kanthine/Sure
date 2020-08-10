//
//  FilerManager.m
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "FilerManager.h"

@implementation FilerManager

+ (void)loadFilerWithOriginalImage:(UIImage *)originalImage CompletionBlock:(void (^) ( NSMutableArray<NSDictionary *> *filerListArray))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
   {
       NSMutableArray *listArray = [NSMutableArray array];
       for (int i = 0; i < 22; i ++)
       {
           NSDictionary *filerDict = [FilerManager loadFilerInfoWithOriginalImage:originalImage FilerIndex:i];
           
           if (filerDict)
           {
               [listArray addObject:filerDict];
               
               
               NSLog(@"停止了嘛 --- %d",i);
               
               if (i < 21)//完全加载完再返回主线程时间太长，体验不好
               {
                   dispatch_async(dispatch_get_main_queue(),^
                                  {
                                      block(listArray);
                                  });
               }

           }
           
        }
       
       //加载完图片后释放滤镜缓存
       [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];

       dispatch_async(dispatch_get_main_queue(),^
                      {
                          block(listArray);
                      });
       
   });
}

+ (NSDictionary *)loadFilerInfoWithOriginalImage:(UIImage *)originalImage FilerIndex:(NSInteger)index
{

   UIImage *image = originalImage;
   
   NSString *filerNameString = nil;
   
   switch (index)
   {
       case 0:
           filerNameString = @"原始图片";
           break;
       case 1:
           filerNameString = @"MissetikateFilter";
           image = [FWApplyFilter applyMissetikateFilter:image];
           break;
       case 2:
           filerNameString = @"SoftEleganceFilter";
           image = [FWApplyFilter applySoftEleganceFilter:image];
           break;
       case 3:
           filerNameString = @"NashvilleFilter";
           image = [FWApplyFilter applyNashvilleFilter:image];
           break;
       case 4:
           filerNameString = @"LordKelvinFilter";
           image = [FWApplyFilter applyLordKelvinFilter:image];
           break;
       case 5:
           filerNameString = @"AmaroFilter";
           image = [FWApplyFilter applyAmaroFilter:image];
           break;
       case 6:
           filerNameString = @"RiseFilter";
           image = [FWApplyFilter applyRiseFilter:image];
           break;
       case 7:
           filerNameString = @"HudsonFilter";
           image = [FWApplyFilter applyHudsonFilter:image];
           break;
       case 8:
           filerNameString = @"XproIIFilter";
           image = [FWApplyFilter applyXproIIFilter:image];
           break;
       case 9:
           filerNameString = @"1977Filter";
           image = [FWApplyFilter apply1977Filter:image];
           break;
       case 10:
           filerNameString = @"ValenciaFilter";
           image = [FWApplyFilter applyValenciaFilter:image];
           break;
       case 11:
           filerNameString = @"WaldenFilter";
           image = [FWApplyFilter applyWaldenFilter:image];
           break;
       case 12:
           filerNameString = @"LomofiFilter";
           image = [FWApplyFilter applyLomofiFilter:image];
           break;
       case 13:
           filerNameString = @"InkwellFilter";
           image = [FWApplyFilter applyInkwellFilter:image];
           break;
       case 14:
           filerNameString = @"SierraFilter";
           image = [FWApplyFilter applySierraFilter:image];
           break;
       case 15:
           filerNameString = @"EarlybirdFilter";
           image = [FWApplyFilter applyEarlybirdFilter:image];
           break;
       case 16:
           filerNameString = @"SutroFilter";
           image = [FWApplyFilter applySutroFilter:image];
           break;
       case 17:
           filerNameString = @"ToasterFilter";
           image = [FWApplyFilter applyToasterFilter:image];
           break;
       case 18:
           filerNameString = @"BrannanFilter";
           image = [FWApplyFilter applyBrannanFilter:image];
           break;
       case 19:
           filerNameString = @"SketchFilter";
           image = [FWApplyFilter applySketchFilter:image];
           break;
       case 20:
           filerNameString = @"HefeFilter";
           image = [FWApplyFilter applyHefeFilter:image];
           break;
       case 21:
           filerNameString = @"AmatorkaFilter";
           image = [FWApplyFilter applyAmatorkaFilter:image];
           break;
       default:
           break;
   }
    
    if (filerNameString && image)
    {
        NSDictionary *dict = @{FilerNameKey:filerNameString,FilerImageKey:image};
        
        return dict;

    }
    else
        return nil;

}



@end
