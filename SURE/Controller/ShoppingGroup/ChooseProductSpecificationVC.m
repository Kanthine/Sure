//
//  ChooseProductSpecificationVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/30.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"ProductAttributeCell"

#define CellIdentifer_Count @"ProductCountCell"


#import "ChooseProductSpecificationVC.h"

#import "UIViewController+AddShoppingCar.h"
#import "ProductAttributeButton.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "ProductAttributeCell.h"
#import "ProductCountCell.h"

@interface ChooseProductSpecificationVC ()
<UITableViewDelegate,UITableViewDataSource,ProductCountCellDelegate>

{
    __weak IBOutlet UIView *_chooseContentView;

    __weak IBOutlet UIImageView *_productImageView;
    __weak IBOutlet UILabel *_priceLable;
    __weak IBOutlet UILabel *_stockLable;
    __weak IBOutlet UILabel *_selectedLable;
    
    
    
    UIImageView *_cartAnimView;
    
    __weak IBOutlet UIButton *_confirmButton;
    
    
    __weak IBOutlet UITableView *_tableView;
    
    NSString *_colorStr;
    NSString *_sizeStr;
    NSString *_color_ID_Str;
    NSString *_size_ID_Str;
}


@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (nonatomic,assign) NSInteger colorIndex;
@property (nonatomic,assign) NSInteger sizeIndex;

@end

@implementation ChooseProductSpecificationVC

- (void)dealloc
{
    
}

- (instancetype)initWithEnterType:(EnterType)enterType DefaultAssociationModel:(ProductAssociationModel *)defaultAssociationModel
{
    self = [super initWithNibName:@"ChooseProductSpecificationVC" bundle:nil];
    
    if (self)
    {
        _enterType = enterType;
        _defaultAssociationModel = defaultAssociationModel;
        
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    _productImageView.superview.layer.borderWidth = .5f;
    _productImageView.superview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _productImageView.superview.layer.cornerRadius = 3;
    _productImageView.superview.clipsToBounds = YES;
    _productImageView.layer.cornerRadius = 3;
    _productImageView.clipsToBounds = YES;
    
    
    
    [_tableView registerNib:[UINib nibWithNibName:CellIdentifer bundle:nil] forCellReuseIdentifier:CellIdentifer];
    [_tableView registerNib:[UINib nibWithNibName:CellIdentifer_Count bundle:nil] forCellReuseIdentifier:CellIdentifer_Count];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBottomButtonTitle];

    NSLog(@"zeStr ======== %@",_defaultAssociationModel.goods_attr);

    NSString *goods_attr = _defaultAssociationModel.goods_attr;
    NSArray *array = [goods_attr componentsSeparatedByString:@"|"];
    
    NSString *colorStr = array[0];
    
    
    
    NSString *sizeStr = @"";
    if (array && array.count > 1)
    {
        sizeStr = array[1];
    }

    
    
    
    // 初始化界面数据
    NSDictionary *colorDict ;
    NSDictionary *sizeDict;
    if (_enterType == EnterTypeAddShoppingCar)
    {
        if (_singleProduct.attributeModelArray && _singleProduct.attributeModelArray.count > 0)
        {
            colorDict = _singleProduct.attributeModelArray[0];
        }
        
        if (_singleProduct.attributeModelArray && _singleProduct.attributeModelArray.count > 1)
        {
            sizeDict = _singleProduct.attributeModelArray[1];
        }
        _priceLable.text = [NSString stringWithFormat:@"￥%@",_singleProduct.productPriceStr];

    }
    else if (_enterType == EnterTypeNoBuy)
    {
        if (_singleProduct.attributeModelArray && _singleProduct.attributeModelArray.count > 0)
        {
            colorDict = _singleProduct.attributeModelArray[0];
        }
        
        if (_singleProduct.attributeModelArray && _singleProduct.attributeModelArray.count > 1)
        {
            sizeDict = _singleProduct.attributeModelArray[1];
        }
        _priceLable.text = [NSString stringWithFormat:@"￥%@",_singleProduct.productPriceStr];

    }
    else if (_enterType == EnterTypeShopingCarEdit)
    {
        if (_singleProduct.attributeModelArray && _singleProduct.attributeModelArray.count > 0)
        {
            colorDict = _commodityInfo.attributeModelArray[0];
        }
        
        if (_singleProduct.attributeModelArray && _singleProduct.attributeModelArray.count > 1)
        {
            sizeDict = _commodityInfo.attributeModelArray[1];
        }
        _priceLable.text = [NSString stringWithFormat:@"￥%@",_commodityInfo.oldPriceString];

        _countString = [NSString stringWithFormat:@"%ld",_commodityInfo.count];
    }
    
    
    
    NSArray *colorArray = [colorDict objectForKey:colorDict.allKeys[0]];
    NSArray *sizeArray = [sizeDict objectForKey:sizeDict.allKeys[0]];
    
    NSString *colorString;
    for (int i = 0; i < colorArray.count; i ++)
    {
        ProductAttributeModel *attModel = colorArray[i];
        if ([attModel.goods_attr_id isEqualToString:colorStr])
        {
            _color_ID_Str = attModel.goods_attr_id;
            colorString = attModel.attr_value;
            self.colorIndex = i;
            break;
        }
    }
    
    NSString *sizeString;
    for (int i = 0; i < sizeArray.count; i ++)
    {
        ProductAttributeModel *attModel = sizeArray[i];
        if ([attModel.goods_attr_id isEqualToString:sizeStr])
        {
            _size_ID_Str = attModel.goods_attr_id;
            sizeString = attModel.attr_value;
            self.sizeIndex = i;
            break;
        }
    }
    
    
    if (colorStr.length > 0 && sizeString.length > 0)
    {
        _selectedLable.text = [NSString stringWithFormat:@"已选: %@ 、%@",colorString,sizeString];
        
    }
    else if ([colorStr isEqualToString:@""] && sizeString)
    {
        _selectedLable.text = [NSString stringWithFormat:@"已选: %@",sizeString];
    }
    else if ([sizeString isEqualToString:@""] && colorStr)
    {
        _selectedLable.text = [NSString stringWithFormat:@"已选: %@",colorStr];
    }
    else
    {
        _selectedLable.text = @"";
    }
    
    
    NSLog(@"_color_ID_Str ==== %@",_color_ID_Str);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addShoppingCarSucceed
{
    sleep(.01);
    
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)])
    {
        [parent dismissSemiModalView];
    }
    if (self.enterType == EnterTypeAddShoppingCar)
    {
        self.block();
    }
    if (_enterType == EnterTypeNoBuy)
    {
        self.block();
    }
}

- (void)setBottomButtonTitle
{
    // 初始化界面时，设置底部按钮
    if (_enterType== EnterTypeAddShoppingCar)
    {
        [_confirmButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_productImageView sd_setImageWithURL:[NSURL URLWithString:_singleProduct.goods_thumbString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    else if(_enterType == EnterTypeNoBuy)
    {
        [_confirmButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_productImageView sd_setImageWithURL:[NSURL URLWithString:_singleProduct.goods_thumbString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    else if(_enterType == EnterTypeShopingCarEdit)
    {
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_productImageView sd_setImageWithURL:[NSURL URLWithString:_commodityInfo.imageString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }

}

// 底部按钮点击事件
- (IBAction)confirm:(id)sender
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        //没有登录时
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
        
    AccountInfo *user = [AccountInfo standardAccountInfo];
    NSString *userID = user.userId;
    NSString *att_ID = [NSString stringWithFormat:@"%@,%@",_size_ID_Str,_color_ID_Str];
    NSString *goods_number = self.countString;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:userID forKey:@"user_id"];
    [dict setObject:goods_number forKey:@"goods_number"];
    [dict setObject:att_ID forKey:@"goods_attr_id"];
    

    if (_enterType == EnterTypeAddShoppingCar || _enterType == EnterTypeNoBuy)
    {
        [self addAnimations];
        
        
        [dict setObject:_singleProduct.productIDStr forKey:@"goods_id"];
        
        
        if (_defaultAssociationModel.product_id && _defaultAssociationModel.product_id.length > 0)
        {
            [dict setObject:_defaultAssociationModel.product_id forKey:@"product_id"];
        }
        
        [self.httpManager addProductToShoppingCarWithParameterDict:dict CompletionBlock:^(NSError *error)
         {
             if (error == nil)
             {
                 NSLog(@"添加成功");
             }
         }];
    }
    else if (_enterType == EnterTypeShopingCarEdit)
    {
        [dict setObject:_commodityInfo.carIDString forKey:@"rec_id"];
        
        
        [self.httpManager updateShoppingCarProfuctParameterDict:dict CompletionBlock:^(NSError *error)
        {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(editedAttributeInfoClick:Attribute:Count:)])
            {
                
                NSDictionary *dict0 = self.dataSourceArray[0];
                NSDictionary *dict1 = self.dataSourceArray[1];
                ProductAttributeModel *colorModel = [dict0 allValues][0][self.colorIndex];
                ProductAttributeModel *sizeModel = [dict1 allValues][0][self.sizeIndex];
                
                
                
                NSString *str = [NSString stringWithFormat:@"分类: 颜色:%@ 尺码:%@",colorModel.attr_value,sizeModel.attr_value];
                
                
                if (colorModel.attr_value || sizeModel.attr_value)
                {
                    
                }
                else
                {
                    str = @"";
                }
                
                [self.delegate editedAttributeInfoClick:_defaultAssociationModel Attribute:str Count:[_countString intValue]] ;
            }
             [self addShoppingCarSucceed];
        }];
    }

    
    
}

- (IBAction)removeSelfButtonClick:(UIButton *)sender
{
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)])
    {
        [parent dismissSemiModalView];
    }
}


#pragma mark -

- (CGFloat)boundingWidthWithString:(NSString  *)string Font:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName : font} ;
    CGRect  rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth - 20 , 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return rect.size.width;
}

#pragma mark - Core Animation

-(void)addAnimations
{
    
    CGFloat y = _chooseContentView.frame.origin.y + _productImageView.frame.origin.y;
    CGFloat width = _productImageView.frame.size.height;
    
    _cartAnimView=[[UIImageView alloc] initWithFrame:CGRectMake(10,y, width, width)];
    _cartAnimView.image = _productImageView.image;
    [self.view addSubview:_cartAnimView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 3];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    //这个是让旋转动画慢于缩放动画执行
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    //    {
    [_cartAnimView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //    });
    
    [UIView animateWithDuration:1.0 animations:^
     {
         _cartAnimView.frame=CGRectMake(ScreenWidth -55, -(ScreenHeight - CGRectGetHeight(self.view.frame) - 40), 0, 0);
     } completion:^(BOOL finished)
     {
         //动画完成后做的事
         [self addShoppingCarSucceed];
     }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.dataSourceArray.count)
    {
        ProductCountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer_Count forIndexPath:indexPath];
        cell.countLable.text = self.countString;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else
    {
        ProductAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self congifCell:cell indexpath:indexPath];
        return cell;
    }
}


//这里规定  0 颜色 1 尺码
- (void)congifCell:(ProductAttributeCell *)cell indexpath:(NSIndexPath *)indexpath
{
    if (indexpath.row < self.dataSourceArray.count)
    {
        
        NSDictionary *dict = self.dataSourceArray[indexpath.row];
        cell.attributeNameLable.text = [dict allKeys][0];

        [cell.tagView removeAllTags];
        // 这东西非常关键
        cell.tagView.preferredMaxLayoutWidth = ScreenWidth - 20;
        cell.tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        cell.tagView.lineSpacing = 20;
        cell.tagView.interitemSpacing = 11;
        
        NSArray *arr = [self.dataSourceArray[indexpath.row] allValues][0];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            ProductAttributeModel *attributeModel = arr[idx];
            
            SKTag *tag = [[SKTag alloc] initWithText:attributeModel.attr_value];
            tag.font = [UIFont boldSystemFontOfSize:13];
            
            //tag.bgImg = [UIImage imageNamed:@"navBar"];
            tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
            tag.cornerRadius = 5;
            tag.borderWidth = 0;
            
            tag.textColor = TextColorBlack;
            tag.bgColor = GrayColor;
            
            
            
            if (indexpath.row == 0)
            {
                if (idx == self.colorIndex)
                {
                    tag.textColor = [UIColor whiteColor];
                    tag.bgColor = TextColorPurple;
                }
            }
            else
            {
                if (idx == self.sizeIndex)
                {
                    tag.textColor = [UIColor whiteColor];
                    tag.bgColor = TextColorPurple;
                }
            }
            
            [cell.tagView addTag:tag];
            
            
        }];
        
        
        //选中之后
        cell.tagView.didTapTagAtIndex = ^(NSUInteger index)
        {
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            
            if (indexPath.row == 0)
            {
                self.colorIndex = index;
            }
            else
            {
                self.sizeIndex = index;
            }
            NSLog(@"点击了第%ld行，第%ld个",indexPath.row,index);
            //选中之后 ，更新展示：商品图片、价格、库存、已选
            
            
            
            
            NSDictionary *dict0 = self.dataSourceArray[0];
            ProductAttributeModel *colorModel = [dict0 allValues][0][self.colorIndex];
            _color_ID_Str = colorModel.goods_attr_id;
            NSPredicate *colorPredicate = [NSPredicate predicateWithFormat:@"goods_attr CONTAINS %@", colorModel.goods_attr_id];

            ProductAttributeModel *sizeModel = nil;
            NSPredicate *sizePredicate = [NSPredicate predicateWithFormat:@"goods_attr CONTAINS %@", @"-1"];
            if (self.dataSourceArray && self.dataSourceArray.count > 1)
            {
                NSDictionary *dict1 = self.dataSourceArray[1];
                sizeModel = [dict1 allValues][0][self.sizeIndex];
                _size_ID_Str = sizeModel.goods_attr_id;
                sizePredicate = [NSPredicate predicateWithFormat:@"goods_attr CONTAINS %@", sizeModel.goods_attr_id];
            }
            
            NSArray *array;
            if (_enterType == EnterTypeAddShoppingCar || _enterType == EnterTypeNoBuy)
            {
                array = [_singleProduct.associationArray filteredArrayUsingPredicate:colorPredicate];
            }
            else
            {
                array = [_commodityInfo.associationArray filteredArrayUsingPredicate:colorPredicate];
            }
            
            
            
            
            
            array = [array filteredArrayUsingPredicate:sizePredicate];
            
            NSString *product_number;
            if (array.count)
            {
                ProductAssociationModel *assModel = array[0];
                 product_number = assModel.product_number;
                _defaultAssociationModel = assModel;
                
            }
            else
            {
                product_number = @"0";
            }
            
            
            
            NSLog(@"array ======== %@",array);
            
            
            if ([product_number isEqualToString:@"0"])
            {
                [_confirmButton setTitle:@"到货通知" forState:UIControlStateNormal];
                _confirmButton.backgroundColor = GrayColor;
                _confirmButton.userInteractionEnabled = NO;
            }
            else
            {
                
                if (self.enterType == EnterTypeAddShoppingCar)
                {
                    [_confirmButton setTitle:@"加入购物车" forState:UIControlStateNormal];
                }
                else  if (self.enterType == EnterTypeNoBuy)
                {
                    [_confirmButton setTitle:@"立即购买" forState:UIControlStateNormal];
                }
                 else
                {
                    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
                }
                _confirmButton.backgroundColor = [UIColor clearColor];
                _confirmButton.userInteractionEnabled = YES;
            }
            
            //_productImageView
            //_priceLable.text =
            _stockLable.text = [NSString stringWithFormat:@"库存: %@件",product_number];
            
            if (colorModel.attr_value || sizeModel.attr_value)
            {
                _selectedLable.text = [NSString stringWithFormat:@"已选: %@ 、%@",colorModel.attr_value,sizeModel.attr_value];
            }
            else
            {
                _selectedLable.text = @"";
            }
            
            
            
            [_tableView reloadData];
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSourceArray.count)
    {
        return 40;
    }
    else
    {
        return [tableView fd_heightForCellWithIdentifier:CellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
                {
                    [self congifCell:cell indexpath:indexPath];
                }];
    }
}

- (void)observeCountLableValueChangeWithNewString:(NSString *)newString
{
    self.countString = newString;
}

- (NSMutableArray *)dataSourceArray
{
    if (_dataSourceArray == nil)
    {
        if (_enterType == EnterTypeAddShoppingCar)
        {
            _dataSourceArray = _singleProduct.attributeModelArray;
        }
        else if (_enterType == EnterTypeNoBuy)
        {
            _dataSourceArray = _singleProduct.attributeModelArray;
        }
        else if (_enterType == EnterTypeShopingCarEdit)
        {
            _dataSourceArray = _commodityInfo.attributeModelArray;
        }
    }
    return _dataSourceArray;
}

- (NSString *)countString
{
    if (_countString == nil || [_countString isEqualToString:@""] || [_countString isEqualToString:@"0"])
    {
        _countString = @"1";
    }
    
    return _countString;
}

@end
