//
//  SearchViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchResultVC.h"
#import "UIImage+Extend.h"
@interface SearchViewController ()

<UISearchResultsUpdating,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

{
}

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSMutableArray *tempsArray;

@end

@implementation SearchViewController

- (NSArray *)resultArray
{
    if (!_resultArray)
    {
        _resultArray = @[@"国服第一臭豆腐 No.1 Stinky Tofu CN.",
                         @"比尔吉沃特(Bill Ji walter)",
                         @"瓦洛兰 Valoran",
                         @"祖安 Zaun",
                         @"德玛西亚 Demacia",
                         @"诺克萨斯 Noxus",
                         @"艾欧尼亚 Ionia",
                         @"皮尔特沃夫 Piltover",
                         @"弗雷尔卓德 Freijord",
                         @"班德尔城 Bandle City",
                         @"无畏先锋",
                         @"战争学院 The Institute of War",
                         @"巨神峰",
                         @"雷瑟守备(JustThunder",
                         @"裁决之地(JustRule)",
                         @"黑色玫瑰(Black Rose)",
                         @"暗影岛（Shadow island）",
                         @"钢铁烈阳（Steel fierce）",
                         @"恕瑞玛沙漠 Shurima Desert",
                         @"均衡教派（Balanced sect）",
                         @"水晶之痕（Crystal Scar）",
                         @"影流（Shadow Flow ）",
                         @"守望之海（The Watchtower of sea）",
                         @"皮尔特沃夫",
                         @"征服之海",
                         @"扭曲丛林 Twisted Treeline",
                         @"教育网专区",
                         @"试炼之地 Proving Grounds",
                         @"发条魔灵：奥莉安娜（Orianna）",
                         @"战争之王：潘森（Pantheon）",
                         @"钢铁大使：波比（Poopy）",
                         @"披甲龙龟：拉莫斯（Rammus）",
                         @"荒漠屠夫：雷克顿（Renekton）",
                         @"傲之追猎者：雷恩加尔（Rengar）",
                         @"放逐之刃：瑞文（Rivan）",
                         @"机械公敌：兰博（Rumble）",
                         @"流浪法师：瑞兹（Ryze）",
                         @"凛冬之怒：瑟庄妮：（Sejuani）",
                         @"恶魔小丑：萨科（Shaco）",
                         @"暮光之眼：慎（Shen）",
                         @"龙血武姬：希瓦娜（Shyvana）",
                         @"炼金术士：辛吉德（Singed）",
                         @"亡灵勇士：赛恩（Sion）",
                         @"战争女神：希维尔（Sivir）",
                         @"水晶先锋：斯卡纳（Skarner）",
                         @"琴瑟仙女：娑娜（Sona）",
                         @"众星之子：索拉卡（Soraka）",
                         @"策士统领：斯维因（Swain）",
                         @"暗黑元首：辛德拉（Syndra）",
                         @"刀锋之影：泰隆（Talon）",
                         @"宝石骑士：塔里克（Taric）",
                         @"迅捷斥候：提莫（Teemo",
                         @"魂锁典狱长：锤石（Thresh）",
                         @"麦林炮手：崔丝塔娜（Tristana）",
                         @"诅咒巨魔：特兰德尔（Trundle）",
                         @"蛮族之王：泰达米尔（Tryndamere）",
                         @"卡牌大师：崔斯特（Twisted Fate）",
                         @"瘟疫之源：图奇（Twitch）",
                         @"野兽之灵：乌迪尔（Udyr）",
                         @"首领之傲：厄加特（Urgot）",
                         @"惩戒之箭：韦鲁斯（Varus）",
                         @"暗夜猎手：薇恩（Vayne）",
                         @"邪恶小法师：维伽（Veigar）",
                         @"皮城执法官：蔚（Vi）",
                         @"机械先驱：维克托（Viktor）",
                         @"猩红收割者：弗拉基米尔（Vladimir）",
                         @"雷霆咆哮：沃利贝尔（Volibear）",
                         @"嗜血猎手：沃里克（Warwick）",
                         @"远古巫灵：泽拉斯（Xerath）",
                         @"德邦总管：赵信（XinZhao）",
                         @"掘墓者：约里克(Yorick)",
                         @"影流之主：劫（Zed）",
                         @"爆破鬼才：吉格斯（Ziggs）",
                         @"时光守护者：基兰（Zilean）",
                         @"荆棘之兴：婕拉（Zyra）].mutableCopy"];
    }
    return _resultArray;
}

- (NSMutableArray *)tempsArray
{
    if (!_tempsArray)
    {
        _tempsArray = [NSMutableArray array];
    }
    return _tempsArray;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customNavBar];
    
    [self initSearchController];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//     self.searchController.active = true;
    [self.navigationController.navigationBar addSubview:self.searchController.searchBar];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchController.searchBar removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"我的订单";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)initSearchController
{
    SearchResultVC *resultTVC = [[SearchResultVC alloc] init];
    UINavigationController *resultVC = [[UINavigationController alloc] initWithRootViewController:resultTVC];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultVC];
    self.searchController.searchResultsUpdater = self;
    
    self.definesPresentationContext = YES;

    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    //_searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    
    self.searchController.searchBar.frame = CGRectMake(60,7,ScreenWidth - 80,30);
    
    
    
//    self.tableView.tableHeaderView = self.searchController.searchBar;

    
    self.searchController.searchBar.delegate = self;
    
//    resultTVC.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    
//    [self customSearchBar];
}

- (void)customSearchBar
{
    _searchController.searchBar.placeholder=@"搜索全部订单"; // placeholder
    
//      [_searchController.searchBar setSearchFieldBackgroundImage:[[UIImage loadNavBarBackgroundImage] imageByApplyingAlpha:.3f] forState:UIControlStateNormal];
    
//    [_searchController.searchBar setBackgroundImage:[UIImage imageNamed:@"navBar"]]; // 设置搜索框背景图，要跟上面的区分哦，两者不一样
    [_searchController.searchBar setImage:[UIImage imageNamed:@"navBar_Search"]  forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];// 设置搜索框内放大镜图片
    
    _searchController.searchBar.tintColor= [UIColor redColor];// 设置搜索框内按钮文字颜色，以及搜索光标颜色。
    
//    _searchController.searchBar.barTintColor=[UIColor brownColor];// 设置搜索框背景颜色
    

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.resultArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
    
    SearchResultVC *resultVC = (SearchResultVC *)navController.topViewController;
    [self filterContentForSearchText:self.searchController.searchBar.text];
    resultVC.resultsArray = self.tempsArray;
    [resultVC.tableView reloadData];
    
    
    
    searchController.searchBar.showsCancelButton = YES;
    for(id sousuo in [searchController.searchBar subviews])
    {
        for (id zz in [sousuo subviews])
        {
            NSLog(@"%@",zz);
            
            if([zz isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            
        }
    }
    
    
}

#pragma mark - Private Method
- (void)filterContentForSearchText:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    [self.tempsArray removeAllObjects];
    for (int i = 0; i < self.resultArray.count; i++)
    {
        NSString *title = self.resultArray[i];
        NSRange storeRange = NSMakeRange(0, title.length);
        NSRange foundRange = [title rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length)
        {
            [self.tempsArray addObject:self.resultArray[i]];
        }
    }
}


@end
