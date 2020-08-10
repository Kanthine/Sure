//
//  ProductAttributeCell.h
//  SURE
//
//  Created by 王玉龙 on 16/11/11.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKTagView.h>
@interface ProductAttributeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *attributeNameLable;

@property (weak, nonatomic) IBOutlet SKTagView *tagView;



@end
