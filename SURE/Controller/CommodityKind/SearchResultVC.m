//
//  SearchResultVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SearchResultVC.h"

@interface SearchResultVC ()
<UITableViewDelegate,UITableViewDelegate>
@end

@implementation SearchResultVC

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.resultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RESULT_CELL"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RESULT_CELL"];
    }
    cell.textLabel.text = self.resultsArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}

@end
