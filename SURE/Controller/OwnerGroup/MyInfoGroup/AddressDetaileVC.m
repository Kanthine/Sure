//
//  AddressDetaileVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AddressDetaileVC.h"

#import "AddressDetaileView.h"

#import "ErrorTipView.h"
#import "ValidateClass.h"

#import "CustomSwitch.h"

#import "UserInfoHttpManager.h"

@interface AddressDetaileVC ()

<AddressDetaileViewDelegate>

{
    UIButton *_saveNavBarButton;
    __weak IBOutlet UIScrollView *_scrollView;
    
    
    UIView *_defaultView;
    
    
    NSString *_nameString;
    NSString *_phoneString;
    NSString *_detaileString;
    
    NSString *_provence_ID_String;
    NSString *_city_ID_String;
    NSString *_arer_ID_String;
    
    NSString *_provenceString;
    NSString *_cityString;
    NSString *_arerString;
    
    NSString *_adressName;//默认地址 收货地址
}

@property (nonatomic ,strong) UserInfoHttpManager *httpManager;

@property (nonatomic ,strong) AddressDetaileView *infoView;


@end

@implementation AddressDetaileVC

- (void)dealloc
{
    _httpManager = nil;
}

- (UserInfoHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[UserInfoHttpManager alloc]init];
    }
    
    return _httpManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGBA(220, 220, 220, 1);
    [self customNavBar];
    
    [self.view addSubview:self.infoView];
    
    [self setDefaultAddressInfo];
    
    

    
    

    
    NSLog(@"address_name ==== %@",_adressModel.address_name);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    
    if (_detaileState == AddressDetaileStateAdd)
    {
        self.navigationItem.title = @"添加新地址";
    }
    else
    {
        self.navigationItem.title = @"编辑收货地址";
    }
    
    
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _saveNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [_saveNavBarButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveNavBarButton addTarget:self action:@selector(saveNavBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:_saveNavBarButton];
    self.navigationItem.rightBarButtonItem = saveItem;
}


-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveNavBarButtonClick
{
    
    if (_detaileState == AddressDetaileStateEdit)
    {
        if (_provence_ID_String == nil || _provence_ID_String.length == 0)
        {
            _provence_ID_String = _adressModel.provinceID;
            _provenceString = _adressModel.province;
        }
        
        if (_city_ID_String == nil || _city_ID_String.length == 0)
        {
            _city_ID_String = _adressModel.cityID;
            _cityString = _adressModel.city;
        }
        
        if (_arer_ID_String == nil || _arer_ID_String.length == 0)
        {
            _arer_ID_String = _adressModel.districtID;
            _arerString = _adressModel.district;
            
        }
    }

    
    _nameString = _infoView.nameTf.text;
    _phoneString = _infoView.phoneTf.text;
    _detaileString = _infoView.addressTf.text;
    
    [self addShippingAdress];
}

- (void)setDefaultAdress:(CustomSwitch *)switchUI
{
    NSLog(@"switchUI.isOn ======== %d",switchUI.isOn);
    
    
    if (_isNecessarySetDefaultAddress)
    {
        if (switchUI.isOn)
        {
            _adressName = @"默认地址";
        }
        else
        {
            _adressName = @"收货地址";
        }
    }
    else
    {
        if (switchUI.isOn)
        {
            _adressName = @"默认地址";
        }
        else
        {
            _adressName = @"收货地址";
        }
    }
    
}


- (AddressDetaileView *)infoView
{
    if (_infoView == nil)
    {
        _infoView = [[NSBundle mainBundle] loadNibNamed:@"AddressDetaileView" owner:nil options:nil][0];
        _infoView.delegate = self;
        _infoView.frame = CGRectMake(0, 0, ScreenWidth, AddressDetaileView_Height);
    }
    
    return _infoView;
}

- (void)setDefaultAddressInfo
{
    if (_detaileState == AddressDetaileStateEdit)
    {
        _infoView.nameTf.text = _adressModel.nameString;
        _infoView.phoneTf.text = _adressModel.phoneString;
        _infoView.addressTf.text = _adressModel.addressString;
        _infoView.placeLable.hidden = YES;
        _adressName = _adressModel.address_name;
        
        [_infoView scroToCurrentLocationWithProvence:_adressModel.provinceID City:_adressModel.cityID Area:_adressModel.districtID];
        
        NSString *nameStr;
        if ([_adressModel.province isEqualToString:_adressModel.city])
        {
            nameStr = [NSString stringWithFormat:@"%@ %@",_adressModel.city,_adressModel.district];
        }
        else if (_adressModel.district == nil || [_adressModel.district isEqualToString:@""])
        {
            nameStr = [NSString stringWithFormat:@"%@ %@",_adressModel.province,_adressModel.city];
        }
        else
        {
            nameStr = [NSString stringWithFormat:@"%@ %@ %@",_adressModel.province,_adressModel.city,_adressModel.district];
        }
        
        [_infoView.provenceButton setTitle:nameStr forState:UIControlStateNormal];
    }
    else if (_detaileState == AddressDetaileStateAdd)
    {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, AddressDetaileView_Height + 20, ScreenWidth, 50)];
        _defaultView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_defaultView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 50)];
        lable.text = @"设置默认地址";
        lable.textColor = TextColorBlack;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textAlignment = NSTextAlignmentLeft;
        [_defaultView addSubview:lable];
        
        CustomSwitch *switchUI = [[CustomSwitch alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 10, 50, 30)];
        if (_isNecessarySetDefaultAddress)
        {
            switchUI.on = YES;
            _adressName = @"默认地址";
        }
        else
        {
            switchUI.on = NO;
            _adressName = @"收货地址";
        }
        [switchUI addTarget:self action:@selector(setDefaultAdress:) forControlEvents:UIControlEventValueChanged];
        switchUI.onColor = [UIColor colorWithRed:0.20f green:0.42f blue:0.86f alpha:1.00f];
        



        
        
        [_defaultView addSubview:switchUI];
    }

}




- (void)cinfirmChooseAreaWithProvence:(NSDictionary *)ProvenceDict City:(NSDictionary *)cityDict Area:(NSDictionary *)areaDict
{
    
    _provence_ID_String = [ProvenceDict objectForKey:@"region_id"];
    _city_ID_String = [cityDict objectForKey:@"region_id"];
    _arer_ID_String = [areaDict objectForKey:@"region_id"];

    _provenceString = [ProvenceDict objectForKey:@"region_name"];
    _cityString = [cityDict objectForKey:@"region_name"];
    _arerString = [areaDict objectForKey:@"region_name"];
    
    NSString *nameStr;
    if ([_provenceString isEqualToString:_cityString])
    {
        nameStr = [NSString stringWithFormat:@"%@ %@",_cityString,_arerString];
    }
    else if (_arerString == nil || [_arerString isEqualToString:@""])
    {
        nameStr = [NSString stringWithFormat:@"%@ %@",_provenceString,_cityString];
    }
    else
    {
        nameStr = [NSString stringWithFormat:@"%@ %@ %@",_provenceString,_cityString,_arerString];
    }
    
    [_infoView.provenceButton setTitle:nameStr forState:UIControlStateNormal];
    /*
     {
     "parent_id" : "104",
     "agency_id" : "0",
     "region_id" : "922",
     "region_name" : "巴马",
     "region_type" : "3"
     },
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)addShippingAdress
{
    if ([self isEffectiveString] == NO)
    {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    AccountInfo *account = [AccountInfo standardAccountInfo];

    NSDictionary *parameterDict;
    if (_detaileState == AddressDetaileStateAdd)
    {
        //九个参数 添加地址
        parameterDict = @{@"user_id":account.userId,@"consignee":_nameString,@"country":@"1",@"province":_provence_ID_String,@"city":_city_ID_String,@"district":_arer_ID_String,@"address":_detaileString,@"mobile":_phoneString,@"address_name":_adressName};
        
        hud.label.text = @"添加...";

    }
    else
    {
        

        
        //十个参数 修改地址
        parameterDict = @{@"user_id":account.userId,@"consignee":_nameString,@"country":@"1",@"province":_provence_ID_String,@"city":_city_ID_String,@"district":_arer_ID_String,@"address":_detaileString,@"mobile":_phoneString,@"address_name":_adressName,@"address_id":_adressModel.address_id};
        hud.label.text = @"修改中...";

        _adressModel.address_name = _adressName;
        
        NSLog(@"_adressName ====== %@",_adressName);
        
        
        _adressModel.cityID = _city_ID_String;
        _adressModel.provinceID = _provence_ID_String;
        _adressModel.districtID = _arer_ID_String;
        
        if ([_adressName isEqualToString:@"收货地址"])
        {
            _adressModel.isDefaultAdress = NO;
        }
        if ([_adressName isEqualToString:@"默认地址"])
        {
            _adressModel.isDefaultAdress = YES;
        }
        _adressModel.nameString = _nameString;
        _adressModel.phoneString = _phoneString;
        _adressModel.addressString = _detaileString;
        
        _adressModel.city = _cityString;
        _adressModel.district = _arerString;
        _adressModel.province = _provenceString;
        
        _adressModel.provinceCityName = [NSString stringWithFormat:@"%@ %@",_infoView.provenceButton.titleLabel.text,_detaileString];
    }
    
    
    
    //默认地址 收货地址
    
    // Set the label text.
    
    [self.httpManager addShippingAdressParameterDict:parameterDict CompletionBlock:^(NSError *error)
    {
        [hud hideAnimated:YES];

        if (error == nil)
        {
            
            
            if (_detaileState == AddressDetaileStateAdd)
            {
                
            }
            else
            {
                [ShippingAddressModel updateShippingAdressWithModel:_adressModel];
            }
            

            
            //修改成功后，需要本地修改
            [self leftBtnAction];
        }
    }];
}

- (BOOL)isEffectiveString
{
    //高 40
    if (_nameString == nil || _nameString.length == 0)
    {
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"请输入姓名" frame:CGRectMake(50, 30, 200, 50)];
        [tipView showInView:self.view ShowDuration:2];
        
        return NO;
    }
    
    if ([ValidateClass isMobile:_phoneString] == NO)
    {
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"手机号码有误" frame:CGRectMake(50, 70, 200, 50)];
        [tipView showInView:self.view ShowDuration:2];
        
        
        return NO;
    }
    
    if ( !(_provence_ID_String.length > 0 && _city_ID_String.length > 0 && _arer_ID_String.length > 0 ))
    {
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"请选择省市" frame:CGRectMake(50, 110, 200, 50)];
        [tipView showInView:self.view ShowDuration:2];
        
        return NO;
    }
    
    if (_detaileString == nil || _detaileString.length == 0)
    {
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"请填写街道地址" frame:CGRectMake(50, 150, 200, 50)];
        [tipView showInView:self.view ShowDuration:2];
        
        return NO;
    }
    
    return YES;
}

@end
