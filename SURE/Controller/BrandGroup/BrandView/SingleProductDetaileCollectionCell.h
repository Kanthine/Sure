//
//  SingleProductDetaileCollectionCell.h
//  SURE
//
//  Created by 王玉龙 on 17/1/11.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SingleProductDetaileCollectionCell : UICollectionViewCell


@property (nonatomic ,copy) void(^ updateSingleCollectionCellHeight)(CGFloat height);


- (void)loadHTMLString:(NSString *)htmlString;

@end
