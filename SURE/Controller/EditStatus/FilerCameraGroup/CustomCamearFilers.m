//
//  CustomCamearFilers.m
//  SURE
//
//  Created by 王玉龙 on 16/11/3.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CustomCamearFilers.h"

#import <objc/runtime.h>





#import "FWCommonTools.h"
#import "FWNashvilleFilter.h"
#import "FWLordKelvinFilter.h"
#import "GPUImageVibranceFilter.h"
#import "FWAmaroFilter.h"
#import "FWRiseFilter.h"
#import "FWHudsonFilter.h"
#import "FW1977Filter.h"
#import "FWValenciaFilter.h"
#import "FWXproIIFilter.h"
#import "FWWaldenFilter.h"
#import "FWLomofiFilter.h"
#import "FWInkwellFilter.h"
#import "FWSierraFilter.h"
#import "FWEarlybirdFilter.h"
#import "FWSutroFilter.h"
#import "FWToasterFilter.h"
#import "FWBrannanFilter.h"
#import "FWHefeFilter.h"


static char GPUImageFilterGroupTitleKey;
static char GPUImageFilterGroupColorKey;

@implementation GPUImageFilterGroup(addTitleColor)

-(void)setTitle:(NSString *)title
{
    [self willChangeValueForKey:@"GPUImageFilterGroupTitleKey"];
    objc_setAssociatedObject(self, &GPUImageFilterGroupTitleKey,
                             title,
                             OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"GPUImageFilterGroupTitleKey"];
}

- (NSString *)title {
    return objc_getAssociatedObject(self, &GPUImageFilterGroupTitleKey);
}

- (void)setColor:(UIColor *)color {
    [self willChangeValueForKey:@"GPUImageFilterGroupColorKey"];
    objc_setAssociatedObject(self, &GPUImageFilterGroupColorKey,
                             color,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"GPUImageFilterGroupColorKey"];
}

-(UIColor *)color
{
    return objc_getAssociatedObject(self, &GPUImageFilterGroupColorKey);
}

@end





@implementation CustomCamearFilers

+ (NSArray *)getfilerGroupArrayWithCamear:(GPUImageStillCamera *)videoCamera
{
    GPUImageFilterGroup *camearNormal = [CustomCamearFilers camearNormal];
    [videoCamera addTarget:camearNormal];
    
    GPUImageFilterGroup *camearAmatorkaFilter = [CustomCamearFilers camearAmatorkaFilter];
    [videoCamera addTarget:camearAmatorkaFilter];
    
    GPUImageFilterGroup *cameraMissEtikate = [CustomCamearFilers cameraMissEtikate];
    [videoCamera addTarget:cameraMissEtikate];
    
    GPUImageFilterGroup *cameraSoftEleganceFilter = [CustomCamearFilers cameraSoftEleganceFilter];
    [videoCamera addTarget:cameraSoftEleganceFilter];
    
    
    GPUImageFilterGroup *cameraNashvilleFilter = [CustomCamearFilers cameraNashvilleFilter];
    [videoCamera addTarget:cameraNashvilleFilter];
    
    
//    NSArray *filerGroupArray1 = [NSArray arrayWithObjects:camearNormal,camearAmatorkaFilter,cameraMissEtikate,cameraSoftEleganceFilter,cameraNashvilleFilter,nil];
//    
//    
//    return filerGroupArray1;
//    
    
    GPUImageFilterGroup *cameraLordKelvinFilter = [CustomCamearFilers cameraLordKelvinFilter];
    [videoCamera addTarget:cameraLordKelvinFilter];
    
    GPUImageFilterGroup *cameraAmaroFilter = [CustomCamearFilers cameraAmaroFilter];
    [videoCamera addTarget:cameraAmaroFilter];
    
    GPUImageFilterGroup *cameraRiseFilter = [CustomCamearFilers cameraRiseFilter];
    [videoCamera addTarget:cameraRiseFilter];
    
    GPUImageFilterGroup *cameraHudsonFilter = [CustomCamearFilers cameraHudsonFilter];
    [videoCamera addTarget:cameraHudsonFilter];
    
    GPUImageFilterGroup *cameraXproIIFilter = [CustomCamearFilers cameraXproIIFilter];
    [videoCamera addTarget:cameraXproIIFilter];
    
    GPUImageFilterGroup *camera1977Filter = [CustomCamearFilers camera1977Filter];
    [videoCamera addTarget:camera1977Filter];
    
    GPUImageFilterGroup *cameraValenciaFilter = [CustomCamearFilers cameraValenciaFilter];
    [videoCamera addTarget:cameraValenciaFilter];
    
    
    GPUImageFilterGroup *cameraWaldenFilter = [CustomCamearFilers cameraWaldenFilter];
    [videoCamera addTarget:cameraWaldenFilter];
    
    
    GPUImageFilterGroup *cameraLomofiFilter = [CustomCamearFilers cameraLomofiFilter];
    [videoCamera addTarget:cameraLomofiFilter];
    
    
    
    GPUImageFilterGroup *cameraInkwellFilter = [CustomCamearFilers cameraInkwellFilter];
    [videoCamera addTarget:cameraInkwellFilter];
    
    
    
    GPUImageFilterGroup *cameraSierraFilter = [CustomCamearFilers cameraSierraFilter];
    [videoCamera addTarget:cameraSierraFilter];
    
    
    GPUImageFilterGroup *cameraEarlybirdFilter = [CustomCamearFilers cameraEarlybirdFilter];
    [videoCamera addTarget:cameraEarlybirdFilter];
    
    
    GPUImageFilterGroup *cameraSutroFilter = [CustomCamearFilers cameraSutroFilter];
    [videoCamera addTarget:cameraSutroFilter];
    
    
    GPUImageFilterGroup *cameraToasterFilter = [CustomCamearFilers cameraToasterFilter];
    [videoCamera addTarget:cameraToasterFilter];
    
    
    GPUImageFilterGroup *cameraBrannanFilter = [CustomCamearFilers cameraBrannanFilter];
    [videoCamera addTarget:cameraBrannanFilter];
    
    
    GPUImageFilterGroup *cameraHefeFilter = [CustomCamearFilers cameraHefeFilter];
    [videoCamera addTarget:cameraHefeFilter];
    
    GPUImageFilterGroup *cameraGlassSphereFilter = [CustomCamearFilers cameraGlassSphereFilter];
    [videoCamera addTarget:cameraGlassSphereFilter];
    
    
    NSArray *filerGroupArray = [NSArray arrayWithObjects:camearNormal,camearAmatorkaFilter,cameraMissEtikate,cameraSoftEleganceFilter,cameraLordKelvinFilter,cameraAmaroFilter,cameraRiseFilter,cameraHudsonFilter,cameraXproIIFilter,camera1977Filter,cameraValenciaFilter,cameraWaldenFilter,cameraLomofiFilter,cameraInkwellFilter,cameraSierraFilter,cameraEarlybirdFilter,cameraSutroFilter,cameraToasterFilter,cameraBrannanFilter,cameraHefeFilter,cameraGlassSphereFilter,cameraNashvilleFilter,nil];
    
    
    return filerGroupArray;
}

+ (GPUImageFilterGroup *)camearNormal
{
    GPUImageFilter *filter = [[GPUImageFilter alloc] init]; //默认
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"正常";
    group.color = [UIColor blackColor];
    return group;
    
}

+ (GPUImageFilterGroup *)camearAmatorkaFilter
{
    GPUImageAmatorkaFilter *filter = [[GPUImageAmatorkaFilter alloc] init];
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Amatorka";
    group.color = [UIColor blueColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraMissEtikate
{
    GPUImageMissEtikateFilter *filter = [[GPUImageMissEtikateFilter alloc] init];
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"MissEtikate";
    group.color = [UIColor greenColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraSoftEleganceFilter
{
    GPUImageSoftEleganceFilter *filter = [[GPUImageSoftEleganceFilter alloc] init];

    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"SoftElegance";
    group.color = [UIColor redColor];
    return group;
}


+ (GPUImageFilterGroup *)cameraNashvilleFilter
{
    FWNashvilleFilter *filter = [[FWNashvilleFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Nashville";
    group.color = [UIColor redColor];
    return group;
}


+ (GPUImageFilterGroup *)cameraLordKelvinFilter
{
    FWLordKelvinFilter *filter = [[FWLordKelvinFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"LordKelvin";
    group.color = [UIColor redColor];
    return group;
}


+ (GPUImageFilterGroup *)cameraAmaroFilter
{
    FWAmaroFilter *filter = [[FWAmaroFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Amaro";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraRiseFilter
{
    FWRiseFilter *filter = [[FWRiseFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Rise";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraHudsonFilter
{
    FWHudsonFilter *filter = [[FWHudsonFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Hudson";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraXproIIFilter
{
    FWXproIIFilter *filter = [[FWXproIIFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"XproII";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)camera1977Filter
{
    FW1977Filter *filter = [[FW1977Filter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"1977";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraValenciaFilter
{
    FWValenciaFilter *filter = [[FWValenciaFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Valencia";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraWaldenFilter
{
    FWWaldenFilter *filter = [[FWWaldenFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Walden";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraLomofiFilter
{
    FWLomofiFilter *filter = [[FWLomofiFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Lomofi";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraInkwellFilter
{
    FWInkwellFilter *filter = [[FWInkwellFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Inkwell";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraSierraFilter
{
    FWSierraFilter *filter = [[FWSierraFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Sierra";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraEarlybirdFilter
{
    FWEarlybirdFilter *filter = [[FWEarlybirdFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Earlybird";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraSutroFilter
{
    FWSutroFilter *filter = [[FWSutroFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Sutro";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraToasterFilter
{
    FWToasterFilter*filter = [[FWToasterFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Toaster";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraBrannanFilter
{
    FWBrannanFilter *filter = [[FWBrannanFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Brannan";
    group.color = [UIColor redColor];
    return group;
}

+ (GPUImageFilterGroup *)cameraHefeFilter
{
    FWHefeFilter *filter = [[FWHefeFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"Hefe";
    group.color = [UIColor redColor];
    return group;
}


+ (GPUImageFilterGroup *)cameraGlassSphereFilter
{
    GPUImageGlassSphereFilter *filter = [[GPUImageGlassSphereFilter alloc] init];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"GlassSphere";
    group.color = [UIColor redColor];
    return group;
}

@end


