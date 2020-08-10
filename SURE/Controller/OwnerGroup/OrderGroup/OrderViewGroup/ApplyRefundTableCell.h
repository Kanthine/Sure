//
//  ApplyRefundTableCell.h
//  SURE
//
//  Created by 王玉龙 on 17/2/17.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyRefundTableCell : UITableViewCell

@property (nonatomic ,strong) UILabel *refundPriceLable;
@property (nonatomic ,strong) UITextView *stateTextView;
@property (nonatomic ,strong) UIButton *reasonButton;

@property (nonatomic ,strong) UIView *photoView;

@property (nonatomic ,weak) UIViewController *currentViewController;

@property (nonatomic ,copy) void(^ applyRefundStateTextViewShowClick)(CGFloat height);
@property (nonatomic ,copy) void(^ applyRefundAddPhotoButtonClick)();

- (void)updatePhotoContentViewWithArray:(NSMutableArray<UIImage *> *)imageArray;

@end
