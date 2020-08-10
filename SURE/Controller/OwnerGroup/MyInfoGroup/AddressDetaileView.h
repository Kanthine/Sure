//
//  AddressDetaileView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define AddressDetaileView_Height  175.0f


#import <UIKit/UIKit.h>

@protocol AddressDetaileViewDelegate <NSObject>

@required

- (void)cinfirmChooseAreaWithProvence:(NSDictionary *)ProvenceDict City:(NSDictionary *)cityDict Area:(NSDictionary *)areaDict;

@end

@interface AddressDetaileView : UIView

@property (nonatomic ,assign) id <AddressDetaileViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UIButton *provenceButton;

@property (weak, nonatomic) IBOutlet UITextView *addressTf;

@property (weak, nonatomic) IBOutlet UILabel *placeLable;

- (void)scroToCurrentLocationWithProvence:(NSString *)provenceIDStr City:(NSString *)cityIDStr Area:(NSString *)areaIDStr;
@end
