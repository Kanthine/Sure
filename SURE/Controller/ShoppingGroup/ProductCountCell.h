//
//  ProductCountCell.h
//  SURE
//
//  Created by 王玉龙 on 16/11/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductCountCellDelegate <NSObject>

@required

- (void)observeCountLableValueChangeWithNewString:(NSString *)newString;

@end

@interface ProductCountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countLable;
@property (nonatomic ,assign) id <ProductCountCellDelegate> delegate;

@end
