//
//  BrandListButton.h
//  SURE
//
//  Created by 王玉龙 on 16/10/28.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class BrandDetaileModel;

@interface BrandListButton : UIButton

@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,strong) BrandDetaileModel *brandModel;

@end
