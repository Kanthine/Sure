//
//  RecommendCellThree.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "RecommendCellThree.h"

#import "SingleProductDetaileVC.h"
@interface RecommendCellThree()

@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *buton1;
@property (weak, nonatomic) IBOutlet UIButton *buton2;
@property (weak, nonatomic) IBOutlet UIButton *buton3;
@property (weak, nonatomic) IBOutlet UIButton *buton4;


@property (nonatomic ,strong) NSArray *dataArray;


@end

@implementation RecommendCellThree

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headerButton.adjustsImageWhenHighlighted = NO;
    self.leftButton.adjustsImageWhenHighlighted = NO;
    self.buton1.adjustsImageWhenHighlighted = NO;
    self.buton2.adjustsImageWhenHighlighted = NO;
    self.buton3.adjustsImageWhenHighlighted = NO;
    self.buton4.adjustsImageWhenHighlighted = NO;
    
    self.leftButton.tag = 1;
    self.buton1.tag = 2;
    self.buton2.tag = 3;
    self.buton3.tag = 4;
    self.buton4.tag = 5;
    [self.leftButton addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buton1 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buton2 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buton3 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buton4 addTarget:self action:@selector(pushBrandDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
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
    NSString *goodIDString = dict[@"goods_id"];
    
    SingleProductDetaileVC *singleVC = [[SingleProductDetaileVC alloc]init];
    singleVC.hidesBottomBarWhenPushed = YES;
    singleVC.goodIDString = goodIDString;
    [singleVC requestNetworkGetData];
    [self.currentViewControler.navigationController pushViewController:singleVC animated:YES];

}



- (void)updateRecommendCellThreeWithDict:(NSDictionary *)dict
{
    NSArray *array = dict[@"goods_list"];
    
    
    NSString *headerImage = [NSString stringWithFormat:@"%@/data/afficheimg/%@",ImageUrl,dict[@"ad_code"]];
    
    [self.headerButton sd_setImageWithURL:[NSURL URLWithString:headerImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    
    
    if (array && array.count)
    {
        
        self.dataArray = array;

        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             
             NSString *imageString = obj[@"goods_thumb"];
             imageString = [NSString stringWithFormat:@"%@/%@",ImageUrl,imageString];
             
             if (idx < 5)
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
            [self.leftButton sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;
        case 1:
        {
            [self.buton1 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;
        case 2:
        {
            [self.buton2 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;
        case 3:
        {
            [self.buton3 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;

        case 4:
        {
            [self.buton4 sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            
        }
            break;
        default:
            break;
    }
    
}

@end
