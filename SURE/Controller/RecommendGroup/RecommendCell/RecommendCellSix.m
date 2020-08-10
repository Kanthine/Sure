//
//  RecommendCellSix.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "RecommendCellSix.h"

#import "BrandDetaileVC.h"

@interface RecommendCellSix()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;


@property (nonatomic ,strong) NSArray *dataArray;

@end


@implementation RecommendCellSix

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.button1.tag = 1;
    self.button2.tag = 2;
    self.button3.tag = 3;
    self.button4.tag = 4;
    self.button5.tag = 5;
    self.button6.tag = 6;
    [self.button1 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button4 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button5 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button6 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)pushBrandDetaileButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 1;
    
    
    if (self.dataArray.count <= index)
    {
        return;
    }
    
    
    NSDictionary *dict = self.dataArray[index];
    NSString *brandID = dict[@"supplier_id"];
    
    BrandDetaileVC *detaileVC = [[BrandDetaileVC alloc]init];
    detaileVC.hidesBottomBarWhenPushed = YES;
    detaileVC.brandIDString = brandID;
    [detaileVC requestNetworkGetData];
    [self.currentViewControler.navigationController pushViewController:detaileVC animated:YES];
        
}

- (void)updateRecommendCellSixWithDict:(NSDictionary *)dict
{
    NSArray *array = dict[@"supplier_list"];
    
    
    if (array && array.count)
    {
        self.dataArray = array;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
//             NSString *nameString = obj[@"supplier_name"];
//             NSString *idString = obj[@"supplier_id"];
//             NSString *uidString = obj[@"user_id"];
             NSString *imageString = obj[@"brand_img"];
             imageString = [NSString stringWithFormat:@"%@/%@",ImageUrl,imageString];

             if (idx < 6)
             {
                 [self setButtonImageWithIndex:idx ImageURL:imageString];
             }
             else
             {
                 * stop = YES;
             }
             
        }];
    }
}

- (void)setButtonImageWithIndex:(NSUInteger)index ImageURL:(NSString *)urlString
{
    switch (index)
    {
        case 0:
        {
            [self.button1 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;
        case 1:
        {
            [self.button2 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;
        case 2:
        {
            [self.button3 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;
        case 3:
        {
            [self.button4 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;

        case 4:
        {
            [self.button5 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;
        case 5:
        {
            [self.button6 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;

        default:
            break;
    }

}

@end
