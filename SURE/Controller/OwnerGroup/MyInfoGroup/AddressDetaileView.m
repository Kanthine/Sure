//
//  AddressDetaileView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AddressDetaileView.h"
#import "LocationPickerView.h"

@interface AddressDetaileView()
{
    NSString *_provence_ID_String;
    NSString *_city_ID_String;
    NSString *_arer_ID_String;
}

@end

@implementation AddressDetaileView

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    [_provenceButton removeObserver:self forKeyPath:@"titleLabel.text"];
}


- (void)awakeFromNib
{
    [super awakeFromNib];

//    _addressTf.textColor = TextColorBlack;

    [_provenceButton addObserver:self forKeyPath:@"titleLabel.text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (IBAction)ChooseProOrCityButtonClick:(UIButton *)sender
{
    [_nameTf resignFirstResponder];
    [_phoneTf resignFirstResponder];
    [_addressTf resignFirstResponder];
    
    LocationPickerView *pickerView = [[LocationPickerView alloc] init];
    pickerView.pickerViewType = LocationPickerViewTypeBottom;
    [pickerView show];
    
    
    if (_arer_ID_String && _provence_ID_String && _city_ID_String)
    {
        [pickerView scroToCurrentLocationWithProvence:_provence_ID_String City:_city_ID_String Area:_arer_ID_String];
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    pickerView.locationMessage = ^(NSDictionary *ProvenceDict,NSDictionary *cityDict,NSDictionary *areaDict)
    {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cinfirmChooseAreaWithProvence:City:Area:)])
        {
            [weakSelf.delegate cinfirmChooseAreaWithProvence:ProvenceDict City:cityDict Area:areaDict];
        }
    };
}

- (void)scroToCurrentLocationWithProvence:(NSString *)provenceIDStr City:(NSString *)cityIDStr Area:(NSString *)areaIDStr
{
    _provence_ID_String = provenceIDStr;
    _city_ID_String = cityIDStr;
    _arer_ID_String = areaIDStr;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([[change objectForKey:@"new"] isEqualToString:@"省市"])
    {
        [_provenceButton setTitleColor:RGBA(187, 187, 187,1) forState:UIControlStateNormal];
    }
    else
    {
        [_provenceButton setTitleColor:TextColorBlack forState:UIControlStateNormal];
        
    }
}

- (void)textViewTextDidChange:(NSNotification *)notification
{
    if (_addressTf.text.length == 0)
    {
        _placeLable.hidden = NO;
    }
    else
    {
        _placeLable.hidden = YES;
    }
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    if (_addressTf.text.length == 0)
    {
        _placeLable.hidden = NO;
    }
    else
    {
        _placeLable.hidden = YES;
    }
}


@end
