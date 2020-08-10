//
//  TapSupportDetaileVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BaseViewController.h"

@interface TapSupportDetaileVC : BaseViewController

@property (nonatomic ,strong) NSString *titleString;
@property (nonatomic ,strong) NSString *userID;
@property (nonatomic ,strong) NSString *attentionedID;//被关注ID
@property (nonatomic ,strong) NSString *type;/* 1是用户 2是店铺 3商品 4sure点赞 */

@end
