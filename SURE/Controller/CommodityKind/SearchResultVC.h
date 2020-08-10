//
//  SearchResultVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 搜索结果数据
@property (nonatomic, strong) NSMutableArray *resultsArray;

@end
