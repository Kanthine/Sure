//
//  BrandDetaileCollectionSureCell.h
//  SURE
//
//  Created by 王玉龙 on 17/1/10.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseViewController;

@interface BrandDetaileCollectionSureCell : UICollectionViewCell

@property (nonatomic ,weak) BaseViewController *currentViewController;

- (void)updateBrandDetaileCollectionSureCellWithModel:(SUREModel *)sureModel;

@end
