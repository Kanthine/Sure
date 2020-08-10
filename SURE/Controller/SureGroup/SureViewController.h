//
//  SureViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BaseViewController.h"

@interface SureViewController : BaseViewController


@property (nonatomic ,strong) NSMutableArray<SUREModel *> *sureListArray;

@property (nonatomic, strong) UITableView *tableView;


@end


/*
 
 {
 "imglist": [
 {
 "lablename": "1",
 "goodsid": "111",
 "images": "aaaa"
 "lat": "a"
 "lng": "a"
 },
 {
 "lablename": "2",
 "goodsid": "111",
 "images": "aaaa"
 "lat": "b"
 "lng": "b"
 },
 {
 "lablename": "1",
 "goodsid": "111",
 "images": "bbbb"
 "lat": "a"
 "lng": "a"
 }
 ]
 }
 
 */
