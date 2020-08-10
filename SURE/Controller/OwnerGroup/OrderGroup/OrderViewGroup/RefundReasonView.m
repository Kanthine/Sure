//
//  RefundReasonView.m
//  SURE
//
//  Created by 王玉龙 on 17/2/17.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"RefundReasonTableCell"
#define AnimationDuration 0.2f
#define PickerSheetViewHeight 350


#import "RefundReasonView.h"
#import <Masonry.h>

@interface RefundReasonTableCell : UITableViewCell

@property (nonatomic ,strong) UILabel *reasonLanle;
@property (nonatomic ,strong) UIImageView *selectImageView;

@end


@implementation RefundReasonTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.reasonLanle];
        [self.contentView addSubview:self.selectImageView];

        [self.reasonLanle mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(@10);
        }];
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(self);
             make.right.mas_equalTo(@-10);
             make.width.mas_equalTo(@22);
             make.height.mas_equalTo(@22);
         }];

    }
    
    return self;
}

- (UILabel *)reasonLanle
{
    if (_reasonLanle == nil)
    {
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TextColorBlack;
        lable.textAlignment = NSTextAlignmentLeft;
        
        _reasonLanle = lable;
    }
    
    return _reasonLanle;
}

- (UIImageView *)selectImageView
{
    if (_selectImageView == nil)
    {
        _selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"refundReasonSelectNo"] highlightedImage:[UIImage imageNamed:@"refundReasonSelect"]];
        _selectImageView.highlighted = NO;
        _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _selectImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    _selectImageView.highlighted = selected;

    
}

@end





















@interface RefundReasonView()
<UITableViewDelegate,UITableViewDataSource>

{
    NSString *_reasonString;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic ,strong) UIButton *confirmButton;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataArray;

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@end

@implementation RefundReasonView

- (instancetype)initWithReasonStr:(NSString *)reasonStr
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        _reasonString = reasonStr;

        [self addSubview:self.coverButton];
        
        [self addSubview:self.contentView];
        
    }
    return self;
}

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, PickerSheetViewHeight);


        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = TextColorBlack;
        lable.font = [UIFont systemFontOfSize:15];
        lable.text = @"退款原因";
        [_contentView addSubview:lable];
        UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame) - 1, ScreenWidth, 1)];
        lineLable.backgroundColor = GrayLineColor;
        [_contentView addSubview:lineLable];

        
        [_contentView addSubview:self.tableView];

        
        
        [_contentView addSubview:self.confirmButton];
        _confirmButton.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame) - 45, ScreenWidth, 45);

        

    }
    
    return _contentView;
}

- (UIButton *)confirmButton
{
    if (_confirmButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor redColor];

        
        _confirmButton = button;
    }
    
    return _confirmButton;
}

- (void)confirmButtonClick
{
    self.refundReasonViewConfirmButtonClick(_reasonString);
    
    
    [self dismissPickerView];
}

- (UIButton *)coverButton
{
    if (_coverButton == nil)
    {
        // 遮盖
        _coverButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _coverButton.backgroundColor = [UIColor blackColor];
        _coverButton.alpha = 0.0;
        [_coverButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        _coverButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    
    return _coverButton;
}

// 消失
- (void)dismissPickerView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeTranslation(0, PickerSheetViewHeight);
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished)
     {
         [self.contentView removeFromSuperview];
         [self.coverButton removeFromSuperview];
         [self removeFromSuperview];
     }];}

// 出现
- (void)show
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeTranslation(0,  -PickerSheetViewHeight);
         self.coverButton.alpha = 0.3;
     }];
}

- (NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = @[@"多拍/拍错/不想要",
                       @"协商一致退款",
                       @"未按约定时间发货",
                       @"其他"];
    }
    
    return _dataArray;
}

#pragma mark - UITableViewDataSource

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, PickerSheetViewHeight - 45 - 44) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;

        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[RefundReasonTableCell class] forCellReuseIdentifier:CellIdentifer];
    }
    
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundReasonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];

    cell.reasonLanle.text = _dataArray[indexPath.row];

    
    if ([cell.reasonLanle.text isEqualToString:_reasonString])
    {
        [cell setSelected:YES animated:YES];
        cell.selectImageView.highlighted = YES;
        _reasonString = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _reasonString = _dataArray[indexPath.row];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
}

- (void)setCurrentReasonStr:(NSString *)currentReasonStr
{
    if ([_currentReasonStr isEqualToString:currentReasonStr] == NO)
    {
        _currentReasonStr = currentReasonStr;
        
        
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if ([obj isEqualToString:currentReasonStr])
            {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                RefundReasonTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [cell setSelected:YES animated:YES];
                cell.selectImageView.highlighted = YES;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                *stop = YES;
            }
        }];
    }
}

@end
