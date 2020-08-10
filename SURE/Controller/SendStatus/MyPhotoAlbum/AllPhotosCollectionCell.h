//
//  AllPhotosCollectionCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllPhotosCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *assetImage;

@property (nonatomic, strong) NSIndexPath *indexpath;

@property (nonatomic, strong) NSMutableArray *selectArray;

@end
