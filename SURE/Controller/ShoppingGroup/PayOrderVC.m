//
//  PayOrderVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"PayOrderCell"

#import "PayOrderVC.h"
#import "PayOrderCell.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "DataSigner.h"
#import "AliOrder.h"

#import "OrderListVC.h"

#import "AFNetAPIClient.h"

@interface PayOrderVC ()

<UITableViewDelegate,UITableViewDataSource>

{
    UIButton *_rightNavBarButton;
    NSDictionary *_payIndo;
    __weak IBOutlet UITableView *_tableView;
    
}

@end

@implementation PayOrderVC

- (instancetype)initWithPayInfo:(NSDictionary *)payInfo
{
    self = [super init];
    if (self)
    {
        _payIndo = payInfo;
        
        
        NSLog(@"payInfo ===== %@",payInfo);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = RGBA(220, 220, 220,1);
    
    [self customNavBar];
    [self setAliPayResult];//支付宝支付结果
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"支付";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_rightNavBarButton setTitle:@"下一步" forState:UIControlStateNormal];
    _rightNavBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightNavBarButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnAction
{
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];

    
    if (cell == nil)
    {
        cell = [[PayOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifer];
    }
    
    cell.textLabel.text = indexPath.row == 0 ? @"支付宝" : @"微信";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = TextColorBlack;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"推荐使用 %@", indexPath.row == 0 ? @"支付宝" : @"微信"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = TextColor149;
    
    cell.imageView.image = indexPath.row == 0 ? [UIImage imageNamed:@"pay_Alipay"] :[UIImage imageNamed:@"pay_WeChat"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0)
    {
        [self aliPayWithOrder];
    }
    
    if (indexPath.row == 1)
    {
        NSString *resultStr = [self jumpToBizPay];
    }
    
}


#pragma mark - Alipay

- (void)aliPayWithOrder
{
    
    NSString *orderString = [_payIndo objectForKey:@"order_string"];
    //调用 支付宝 支付
    
    NSLog(@"orderString ===== %@",orderString);
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:LocalURLSCHEME callback:^(NSDictionary *resultDic)
     {
        NSLog(@"支付宝支付结果 ==== %@",resultDic);
         
         if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000)
         {
             [self paySuccessThenNotificationServer];
             [self jumpOrderListWithSuccess:NO];
         }
         else
         {
             [self jumpOrderListWithSuccess:NO];
         }
    }];
}

- (void)setAliPayResult
{
    //支付宝 支付结果的回调
    APPDELEGETE.aliPayOrderResult = ^(NSDictionary*dic)
    {
        NSLog(@"支付宝支付结果 ==== %@",dic);
        //支付成功
        if ([[dic objectForKey:@"resultStatus"] integerValue]==9000)
        {
            [self paySuccessThenNotificationServer];
            [self jumpOrderListWithSuccess:YES];
        }
        else
        {
            [self jumpOrderListWithSuccess:NO];
        }
    };
    
    
    //微信的支付结果 回调
    APPDELEGETE.libWeChatPayResult = ^(NSString*result)
    {


    };
    
}

- (void)jumpOrderListWithSuccess:(BOOL)isSuccess
{

    __block OrderListVC *listVC = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([obj isKindOfClass:[OrderListVC class]])
        {
            listVC = obj;
            *stop = YES;
        }
    }];
    
    
    if (listVC == nil)
    {
        listVC = [[OrderListVC alloc]init];
        if (isSuccess)
        {
            listVC.orderType = OrderStateWaitSendGoods;
        }
        else
        {
            listVC.orderType = OrderStateWaitPay;
        }
        [listVC requestNetworkGetData];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:listVC animated:YES];
    }
}

#pragma mark - WXpay

- (NSString *)jumpToBizPay
{

    NSString *stamp = [NSString stringWithFormat:@"1487143296"];
    
    //调起微信支付
    PayReq* req   = [[PayReq alloc] init];
    req.partnerId = @"1432523702";
    req.package    = @"Sign=WXPay";
    req.prepayId  = @"wx2017021515213644dec8f8730761650216";
    req.nonceStr  = @"FsDjW8m5vrDWWXFq";
    req.sign      = @"b936fc90b68d1a4eb2ada639f0a1e040";
    req.timeStamp  = stamp.intValue;
    
    [WXApi sendReq:req];
    
    return @"";

    
    
    
    
    
    
    
    
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil)
    {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil)
        {
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0)
            {
                
            }
            else
            {
                return [dict objectForKey:@"retmsg"];
            }
        }
        else
        {
            return @"服务器返回错误，未获取到json对象";
        }
    }
    else
    {
        return @"服务器返回错误";
    }
}

- (void)paySuccessThenNotificationServer
{
    // 此处使用 AFNetAPIClient 防止页面释放后请求停止
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,PaySuccess];
    NSDictionary *parameterDict = @{@"order_id":_payIndo[@"order_id"]};
    [[AFNetAPIClient sharedClient] requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeUseLoadThenCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"支付成功===== %@",responseObject);
         
         
         if (error)
         {
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                
                                
                            });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                NSDictionary *dict = [responseObject objectForKey:@"data"];
                                
                                
                                
                            });
             
         }
     }];

}

@end
