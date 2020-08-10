//
//  ChatViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//


#define DefaultThumImageHigth 90.0f
#define DefaultPressImageHigth 960.0f



#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>//拍摄 照片

#import "ChatViewController.h"
#import "ChatViewCell.h"
#import "ChatViewTextCell.h" // 纯文本cell
#import "ChatViewFileCell.h"
#import "ChatViewVoiceCell.h" //音频cell
#import "ChatViewImageCell.h" // 图片cell
#import "ChatViewCallTextCell.h"

#import "ContactDetailViewController.h"//点击头像，个人详情页面

#import "IMPreviewScrollViewController.h"//点击图片观看大图

#import "HPGrowingTextView.h"


#import "ECMessage.h"
#import "ECDevice.h"
#import "ECFileMessageBody.h"
#import "ECVoiceMessageBody.h"
#import "ECImageMessageBody.h"
#import "ECUserStateMessageBody.h"
#import "ECRevokeMessageBody.h"

#import "NSString+containsString.h"
#import "ECDeviceVoiceRecordView.h"


#import "WebBrowserBaseViewController.h"
#import "ECPreviewMessageBody.h"
#import "ChatViewPreviewCell.h"

#import "TransmitContactViewController.h"
#import "ReadMessageViewController.h"

#import "ChatRevokeCell.h"
#import "MoreView.h"
#import "InputToolBarView.h"
#import "UIImage+Extend.h"

#define ToolbarInputViewHeight 43.0f
#define ToolbarMoreViewHeight 120.0f
#define ToolbarMoreViewHeight1 163.0f
#define ToolbarDefaultTotalHeigth 163.0f //ToolbarInputViewHeight+ToolbarEmojiViewHeight
#define ToolbarRecordViewHeight 163.0f

#define Alert_ResendMessage_Tag 1500


#define KNOTIFICATION_ScrollTable       @"KNOTIFICATION_ScrollTable"
#define KNOTIFICATION_RefreshMoreData   @"KNOTIFICATION_RefreshMoreData"

#define MessagePageSize 15
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define RevokeMessageTime 120000
typedef enum {
    UserState_None=0,
    UserState_Write,
    UserState_Record,
}UserState;

//文本消息，自定义扩展消息类型
const NSInteger TextMessage_OnlyText = 1000; //纯文本消息

@interface ChatViewController()
<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ECDeviceVoiceRecordViewDelegate,WebBrowserBaseViewControllerDelegate,InputToolBarViewDelegate>

{
    dispatch_once_t scrollBTMOnce;
    NSIndexPath* _longPressIndexPath;
    UIMenuController*  _menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transmitMenuItem;
    UIMenuItem *_revokeMenuItem;
    CGFloat viewHeight;
    BOOL isOpenMembersList;
    NSInteger arrowLocation;
    BOOL _isOpenSavePhoto;
    
    dispatch_source_t _timer;
    dispatch_source_t _detectTimer;
    
    UserState userInputState;
    
    
    OtherDetaileModel *_accountInfo;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray* messageArray;
@property (strong, nonatomic) NSArray *groupMembers;

#warning 录音效果页面
@property (nonatomic, strong) UIImageView *amplitudeImageView;
@property (nonatomic, strong) UILabel *recordInfoLabel;
@property (nonatomic, strong) ECMessage *playVoiceMessage;
@property (nonatomic, strong) UIView *amplitudeSuperView;

@property (nonatomic, copy) NSString *deleteAtStr;

//导航栏 标题视图
@property (nonatomic ,strong) UIView *titleview;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *stateLabel;

//切换工具栏显示
@property (nonatomic, strong) InputToolBarView *inputToolBarView;

@end

const char KAlertResendMessage;
const char KMenuViewKey;

@implementation ChatViewController
{
    
#warning 变声页面
    BOOL _isStartRecord;
#warning 表情页面
    NSString *_GroupMemberNickName;
    
    BOOL isReadDeleteMessage;
    
    NSInteger _readMessageCount;
}

-(void)ECDemo_setSessionId:(NSString*)aSessionId
{
    self.sessionId = aSessionId;

}

//初始化一个聊天界面，根据会话ID
-(instancetype)initWithSessionId:(NSString*)aSessionId
{
    if (self = [super init])
    {
        self.sessionId = aSessionId;
        
        
        
        
        [self getUserAccountWithUserID:aSessionId];
    }
    return self;
}

#pragma mark -  Lazy Loading

//消息数组
- (NSMutableArray *)messageArray
{
    if (_messageArray == nil)
    {
        _messageArray = [NSMutableArray array];
    }
    
    return _messageArray;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth,ScreenHeight - ToolbarInputViewHeight - 64.0f) style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0.0f, 0.0f, ScreenWidth,ScreenHeight -ToolbarInputViewHeight - 64.0f);
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWillBeginDragging:)];
        [_tableView addGestureRecognizer:tap];
    }
    
    return _tableView;
}


//会话标题
- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        
        //会话对象的 昵称
        _titleLabel.text = [[DemoGlobalClass sharedInstance] getOtherNameWithPhone:self.sessionId];
    }
    
    return _titleLabel;
}

//联系人是否在线
- (UILabel *)stateLabel
{
    if (_stateLabel == nil)
    {
        UILabel* stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 120.0f, 10.0f)];
        _stateLabel = stateLabel;
        _stateLabel.font = [UIFont systemFontOfSize:11.0f];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _stateLabel;
}

//标题视图
- (UIView *)titleview
{
    if (_titleview == nil)
    {
        _titleview = [[UIView alloc] initWithFrame:CGRectMake(160.0f, 0.0f, 120.0f, 44.0f)];
        _titleview.backgroundColor = [UIColor clearColor];

        //标题
        [_titleview addSubview:self.titleLabel];
        //在线状态
        [_titleview addSubview:self.stateLabel];
        
    }
    
    return _titleview;
}

- (void)setNavBarUI
{
    self.navigationItem.titleView = self.titleview;

    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(popViewController:)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearBtnClicked)];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem =rightItem;
    
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance] getUserState:self.sessionId completion:^(ECError *error, ECUserState *state)
    {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([strongSelf.sessionId isEqualToString:state.userAcc])
        {
            if (state.isOnline)
            {
                //如果在线，判断 什么设备 什么网络在线
                self.stateLabel.text = [NSString stringWithFormat:@"%@-%@", [strongSelf getDeviceWithType:state.deviceType], [strongSelf getNetWorkWithType:state.network]];
            }
            else
            {
                //如果不在线 提示“对方不在线”
                self.stateLabel.text = @"对方不在线";
            }
        }
    }];
}

- (InputToolBarView *)inputToolBarView
{
    if (_inputToolBarView == nil)
    {
        _inputToolBarView = [[InputToolBarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), ScreenWidth, ToolbarInputViewHeight)];
        _inputToolBarView.delegate = self;
        _inputToolBarView.backgroundColor = RGBA(225, 225, 225, 1);
    }
    
    return _inputToolBarView;
}

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    
    [DeviceDelegateHelper sharedInstance].sessionId = self.sessionId;
    
    viewHeight = ScreenHeight - 64.0f;    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    
    [self.view addSubview:self.tableView];
    
    //自定义导航栏
    [self setNavBarUI];
    
    //工具栏
    [self.view addSubview:self.inputToolBarView];

    //刷新单元格
    [self refreshTableView:nil];
    
    [[DemoGlobalClass sharedInstance].AtPersonArray removeAllObjects];
    
    char myBuffer[4] = {'\xe2','\x80','\x85',0};
    _deleteAtStr = [NSString stringWithCString:myBuffer encoding:NSUTF8StringEncoding];
    
}

//view出现时触发
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
    
    dispatch_once(&scrollBTMOnce , ^
    {
        [self scrollViewToBottom:YES];
    });
    [self scrollTableView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //监听用户状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserState:) name:@"KNOTIFICATION_onUserState" object:nil];
    
    //监听消息状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:KNOTIFICATION_onMesssageChanged object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordingAmplitude:) name:KNOTIFICATION_onRecordingAmplitude object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageCompletion:) name:KNOTIFICATION_SendMessageCompletion object:nil];
    
    //清空聊天消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessageArray:) name:KNotification_DeleteLocalSessionMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadMediaAttachFileCompletion:) name:KNOTIFICATION_DownloadMessageCompletion object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceiveMessageDelete:) name:KNOTIFICATION_ReceiveMessageDelete object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTableView) name:KNOTIFICATION_ScrollTable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreMessage) name:KNOTIFICATION_RefreshMoreData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageReadState:) name:KNOTIFICATION_IsReadMessage object:nil];

    //群组成员昵称
    _GroupMemberNickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"GroupMemberNickName"];
}

//view出现后触发
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    extern NSString *const Notification_ChangeMainDisplay;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChangeMainDisplay object:@0];
    [[DeviceDBHelper sharedInstance] markMessagesAsReadOfSession:self.sessionId];
}

//view消失时触发
-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_onRecordingAmplitude object:nil];
    
    if (self.playVoiceMessage)
    {
        //如果前一个在播放
        objc_setAssociatedObject(self.playVoiceMessage, &KVoiceIsPlayKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[ECDevice sharedInstance].messageManager stopPlayingVoiceMessage];
    }
    
    self.playVoiceMessage = nil;
    
    [super viewWillDisappear:animated];
}

//返回上一层
-(void)popViewController:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_ScrollTable object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_RefreshMoreData object:nil];
    [[DeviceDBHelper sharedInstance] markMessagesAsReadOfSession:self.sessionId];
    [self.view.layer removeAllAnimations];
    [self.tableView.layer removeAllAnimations];
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = 0;
    }
    
    if (_detectTimer) {
        dispatch_source_cancel(_detectTimer);
        _detectTimer = 0;
    }
    
    [DeviceDelegateHelper sharedInstance].sessionId = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    if ([self.navigationController.viewControllers.firstObject isKindOfClass:[ChatViewController class]])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)dealloc
{
    [self.tableView.layer removeAllAnimations];
    self.tableView = nil;
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = 0;
    }
    
    if (_detectTimer) {
        dispatch_source_cancel(_detectTimer);
        _detectTimer = 0;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private method 

//判断聊天对方设备
-(NSString*)getDeviceWithType:(ECDeviceType)type
{
    switch (type) {
        case ECDeviceType_AndroidPhone:
            return @"Android手机";
            
        case ECDeviceType_iPhone:
            return @"iPhone手机";
            
        case ECDeviceType_iPad:
            return @"iPad平板";
            
        case ECDeviceType_AndroidPad:
            return @"Android平板";
            
        case ECDeviceType_PC:
            return @"PC";
            
        case ECDeviceType_Web:
            return @"Web";
            
        case ECDeviceType_Mac:
            return @"Mac";
            
        default:
            return @"未知";
    }
}

//判断聊天对方网络
-(NSString*)getNetWorkWithType:(ECNetworkType)type
{
    switch (type) {
        case ECNetworkType_WIFI:
            return @"wifi";
            
        case ECNetworkType_4G:
            return @"4G";
            
        case ECNetworkType_3G:
            return @"3G";
            
        case ECNetworkType_GPRS:
            return @"GRPS";
            
        case ECNetworkType_LAN:
            return @"Internet";
        default:
            return @"其他";
    }
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView && self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

#pragma mark - 清空聊天记录

-(void)clearBtnClicked
{
    userInputState = UserState_None;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[DeviceDBHelper sharedInstance] getAllMessagesOfSessionId:self.sessionId].count == 0)
    {
        hud.labelText = @"没有内容可以清除";
    }
    else
    {
        hud.labelText = @"正在清除聊天内容";
    }
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [self performSelectorOnMainThread:@selector(clearTableView) withObject:nil waitUntilDone:[NSThread isMainThread]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DeviceDBHelper sharedInstance] deleteAllMessageSaveSessionOfSession:self.sessionId];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mainviewdidappear" object:nil];
            [hud hide:YES afterDelay:1.0];
        });
    });
}

#pragma mark - notification method

//清除消息数组
-(void)clearMessageArray:(NSNotification*)notification
{
    NSString *session = (NSString*)notification.object;
    if ([session isEqualToString:self.sessionId])
    {
        [self performSelectorOnMainThread:@selector(clearTableView) withObject:nil waitUntilDone:[NSThread isMainThread]];
    }
}

-(void)clearTableView
{
    [self.messageArray removeAllObjects];
    [self.tableView reloadData];
}

-(void)refreshTableView:(NSNotification*)notification
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (notification == nil)
    {
        [self.messageArray removeAllObjects];
        
        NSArray* message = [[DeviceDBHelper sharedInstance] getLatestHundredMessageOfSessionId:self.sessionId andSize:MessagePageSize];
        if (message.count == MessagePageSize)
        {
            [self.messageArray addObject:[NSNull null]];
        }
        [self.messageArray addObjectsFromArray:message];
        [self.tableView reloadData];
        
    }
    else
    {
        
        ECMessage *message = (ECMessage*)notification.object;
        if (![message.sessionId isEqualToString:self.sessionId])
        {
            return;
        }

        if (message.messageState==ECMessageState_Receive)
        {
            [self startTimer];
        }
        
        if (notification.userInfo)
        {
            [self ReceiveMessageRevoke:notification.userInfo];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mainviewdidappear" object:nil];
            [self.messageArray addObject:message];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }

    if (self.messageArray.count > 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_ScrollTable object:nil];
        });
    }
}

-(void)scrollTableView
{
    if (self && self.tableView && self.messageArray.count>0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - 下拉刷新，加载更多消息

-(void)loadMoreMessage
{
    ECMessage *message = [self.messageArray objectAtIndex:1];
    NSArray * array = [[DeviceDBHelper sharedInstance] getMessageOfSessionId:self.sessionId beforeTime:message.timestamp andPageSize:MessagePageSize];
    
    CGFloat offsetOfButtom = self.tableView.contentSize.height-self.tableView.contentOffset.y;
    
    NSInteger arraycount = array.count;
    if (array.count == 0) {
        [self.messageArray removeObjectAtIndex:0];
    } else {
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, arraycount)];
        [self.messageArray insertObjects:array atIndexes:indexset];
        if (array.count < MessagePageSize) {
            [self.messageArray removeObjectAtIndex:0];
        }
    }
    [self.tableView reloadData];
    self.tableView.contentOffset = CGPointMake(0.0f, self.tableView.contentSize.height-offsetOfButtom);
}

#pragma mark - 收到消息删除通知

-(void)ReceiveMessageDelete:(NSNotification*)notification
{
    
    NSString *msgId = notification.userInfo[@"msgid"];
    NSString *sessionId = notification.userInfo[@"sessionid"];
    
    __weak  __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if ([strongSelf.sessionId isEqualToString:sessionId]) {
            for (NSInteger i=strongSelf.messageArray.count-1; i>=0; i--) {
                id content = [strongSelf.messageArray objectAtIndex:i];
                if ([content isKindOfClass:[NSNull class]]) {
                    continue;
                }
                ECMessage *currMsg = (ECMessage *)content;
                if ([msgId isEqualToString:currMsg.messageId]) {
                    if ([currMsg.messageBody isKindOfClass:[ECFileMessageBody class]]) {
                        ECFileMessageBody* body = (ECFileMessageBody*)currMsg.messageBody;
                        body.localPath = nil;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.tableView beginUpdates];
                        if ([[DemoGlobalClass sharedInstance].userName isEqualToString:currMsg.to]) {
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@",msgId]];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [strongSelf.tableView endUpdates];
                    });
                    break;
                }
            }
        }
    });
}

#pragma mark - 收到消息撤回通知
-(void)ReceiveMessageRevoke:(NSDictionary*)dict {
    
    NSString *msgId =dict[@"msgid"];
    NSString *sessionId = dict[@"sessionid"];
    ECMessage *insertMessage = dict[@"message"];
    
    __weak  __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if ([strongSelf.sessionId isEqualToString:sessionId]) {
            for (NSInteger i=strongSelf.messageArray.count-1; i>=0; i--) {
                id content = [strongSelf.messageArray objectAtIndex:i];
                if ([content isKindOfClass:[NSNull class]]) {
                    continue;
                }
                ECMessage *message = (ECMessage *)content;
                if ([msgId isEqualToString:message.messageId]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSNumber* isplay = objc_getAssociatedObject(message, &KVoiceIsPlayKey);
                        if (isplay.boolValue) {
                            objc_setAssociatedObject(weakSelf.playVoiceMessage, &KVoiceIsPlayKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            [[ECDevice sharedInstance].messageManager stopPlayingVoiceMessage];
                            weakSelf.playVoiceMessage = nil;
                        }
                        
                        [weakSelf.messageArray replaceObjectAtIndex:i withObject:insertMessage];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        
                    });
                    break;
                }
            }
        }
    });
}

#pragma mark - 收到消息已读通知
- (void)refreshMessageReadState:(NSNotification*)noti {
    NSDictionary *dict = noti.object;
    NSString *messageId = [dict objectForKey:@"messageId"];
    NSString *sessionId = [dict objectForKey:@"sessionid"];
    
    __weak  __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if ([strongSelf.sessionId isEqualToString:sessionId]) {
            for (NSInteger i=strongSelf.messageArray.count-1; i>=0; i--) {
                id content = [strongSelf.messageArray objectAtIndex:i];
                if ([content isKindOfClass:[NSNull class]]) {
                    continue;
                }
                ECMessage *message = (ECMessage *)content;
                if ([messageId isEqualToString:message.messageId]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSNumber* isplay = objc_getAssociatedObject(message, &KVoiceIsPlayKey);
                        if (isplay.boolValue) {
                            objc_setAssociatedObject(weakSelf.playVoiceMessage, &KVoiceIsPlayKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            [[ECDevice sharedInstance].messageManager stopPlayingVoiceMessage];
                            weakSelf.playVoiceMessage = nil;
                        }
                        message.isRead = YES;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        
                    });
                    break;
                }
            }
        }
    });
}

-(NSInteger)ExtendTypeOfTextMessage:(ECMessage*)message
{
    return TextMessage_OnlyText;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    
    //tableView上滑动时，重置隐藏工具栏
    [UIView animateWithDuration:0.25 delay:0.0f options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState) animations:^
    {
        [_inputToolBarView resetToolBarToBottom];
    } completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    id content = [self.messageArray objectAtIndex:indexPath.row];
    if ([content isKindOfClass:[NSNull class]])
    {
        return 44.0f;
    }
    
    ECMessage *message = (ECMessage*)content;
    
    // 判断Cell是否显示时间
    BOOL isShow = NO;
    if (indexPath.row == 0)
    {
        isShow = YES;
    }
    else
    {
        id preMessagecontent = [self.messageArray objectAtIndex:indexPath.row - 1];
        if ([preMessagecontent isKindOfClass:[NSNull class]])
        {
            isShow = YES;
        }
        else
        {
            
            NSNumber *isShowNumber = objc_getAssociatedObject(message, &KTimeIsShowKey);
            if (isShowNumber)
            {
                isShow = isShowNumber.boolValue;
            }
            else
            {
                ECMessage *preMessage = (ECMessage*)preMessagecontent;
                long long timestamp = message.timestamp.longLongValue;
                long long pretimestamp = preMessage.timestamp.longLongValue;
                isShow = ((timestamp - pretimestamp) > 180000); //与前一条消息比较大于3分钟显示
            }
        }
    }
    objc_setAssociatedObject(message, &KTimeIsShowKey, @(isShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    //根据cell内容获取高度
    CGFloat height = 0.0f;
    switch (message.messageBody.messageBodyType)
    {
        case MessageBodyType_None:
        {
            if ([[message.messageBody class] isSubclassOfClass:[ECRevokeMessageBody class]]) {
                height = [ChatRevokeCell getHightOfCellViewWith:message.messageBody];
            }
        }
            break;
        case MessageBodyType_Text:
        {
            height = [ChatViewTextCell getHightOfCellViewWith:message.messageBody];
        }
            break;
            
        case MessageBodyType_Voice:
        case MessageBodyType_Video:
        case MessageBodyType_Image:
        case MessageBodyType_File: {
#warning 根据文件的后缀名来获取多媒体消息的类型 麻烦 缺少displayName
            ECFileMessageBody *body = (ECFileMessageBody *)message.messageBody;
            if (body.localPath.length > 0) {
                body.localPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:body.localPath.lastPathComponent];
            }
            
            if (body.displayName.length==0) {
                if (body.localPath.length > 0) {
                    body.displayName = body.localPath.lastPathComponent;
                } else if (body.remotePath.length>0) {
                    body.displayName = body.remotePath.lastPathComponent;
                } else {
                    body.displayName = @"无名字";
                }
            }
            
            switch (message.messageBody.messageBodyType) {
                case MessageBodyType_Voice:
                    height = [ChatViewVoiceCell getHightOfCellViewWith:body];
                    break;
                case MessageBodyType_Image:
                    height = [ChatViewImageCell getHightOfCellViewWith:body];
                    break;
                default:
                    height = [ChatViewFileCell getHightOfCellViewWith:body];
                    break;
            }
        }
            break;
        case MessageBodyType_Call:
            height = [ChatViewCallTextCell getHightOfCellViewWith:message.messageBody];
            break;
        case MessageBodyType_Preview:
        {
            ECPreviewMessageBody *body = (ECPreviewMessageBody *)message.messageBody;
            if (body.thumbnailLocalPath.length > 0) {
                body.thumbnailLocalPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:body.thumbnailLocalPath.lastPathComponent];
            }
            if (body.localPath.length > 0)
            {
                body.localPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:body.localPath.lastPathComponent];
            }

            height = [ChatViewPreviewCell getHightOfCellViewWith:message.messageBody];
        }
            break;
        default:
        {
            ECFileMessageBody *body = (ECFileMessageBody *)message.messageBody;
            body.displayName = body.remotePath.lastPathComponent;
            height = [ChatViewFileCell getHightOfCellViewWith:body];
            break;
        }
    }
    
    // 显示的时间高度为30.0f
    return height+(isShow?30.0f:0.0f);
}

#pragma mark -消息已读操作
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellContent = [self.messageArray objectAtIndex:indexPath.row];
    if ([cellContent isKindOfClass:[ECMessage class]]) {
        
        ECMessage *message = (ECMessage*)cellContent;
        if (!message.isRead && message.messageState == ECMessageState_Receive) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"已阅了消息%@---%d",message.messageId,message.isRead);
                [[ECDevice sharedInstance].messageManager readedMessage:message completion:^(ECError *error, ECMessage *amessage) {
                    if (error.errorCode == ECErrorType_NoError) {
                        [[IMMsgDBAccess sharedInstance] updateMessageReadState:amessage.sessionId messageId:amessage.messageId isRead:amessage.isRead];
                    }
                }];
            });
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    id cellContent = [self.messageArray objectAtIndex:indexPath.row];
    
    if ([cellContent isKindOfClass:[NSNull class]])
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellrefresscellid"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellrefresscellid"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
            UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityView.tag = 100;
            activityView.center = cell.contentView.center;
            [cell.contentView addSubview:activityView];
        }
        UIActivityIndicatorView * activityView = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityView startAnimating];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_RefreshMoreData object:nil];
        });
        return cell;
    }
    
    ECMessage *message = (ECMessage*)cellContent;
    BOOL isSender = (message.messageState==ECMessageState_Receive?NO:YES);
    
    NSInteger fileType = message.messageBody.messageBodyType;
    
    NSString *cellidentifier = [NSString stringWithFormat:@"%@_%@_%d", isSender?@"issender":@"isreceiver",NSStringFromClass([message.messageBody class]),(int)fileType];
    
    if (message.messageBody.messageBodyType==MessageBodyType_Text)
    {
        cellidentifier = [NSString stringWithFormat:@"%@_%ld",cellidentifier,(long)[self ExtendTypeOfTextMessage:message]];
    }
    
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        switch (message.messageBody.messageBodyType)
        {
            case MessageBodyType_None:
            {
                if ([[message.messageBody class] isSubclassOfClass:[ECRevokeMessageBody class]])
                {
                    cell = [[ChatRevokeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
                }
            }
                break;
                
            case MessageBodyType_Text:
            {
                cell = [[ChatViewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
            }
                break;
            case MessageBodyType_Voice:
                cell = [[ChatViewVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
                break;
            case MessageBodyType_Image:
                cell = [[ChatViewImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
                break;
            case MessageBodyType_Call:
                cell = [[ChatViewCallTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
                break;
            case MessageBodyType_Preview:
                cell = [[ChatViewPreviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
                break;
            default:
                cell = [[ChatViewFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
                break;
        }
        
        CGRect frame = cell.frame;
        frame.size.width = tableView.frame.size.width;
        cell.frame = frame;
        
        //更新单元格信息 头像
        [cell prepareCellUIWithSender:isSender];
        
        if (![[message.messageBody class] isSubclassOfClass:[ECRevokeMessageBody class]])
        {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellHandleLongPress:)];
            [cell.bubbleView addGestureRecognizer:longPress];
        }
    }
    
    [cell bubbleViewWithData:[self.messageArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - GestureRecognizer

-(void)cellHandleLongPress:(UILongPressGestureRecognizer * )longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [longPress locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return;
        
        id tableviewcell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([tableviewcell isKindOfClass:[ChatViewCell class]]) {
            ChatViewCell *cell = (ChatViewCell *)tableviewcell;
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView message:cell.displayMessage];
        }
    }
}

- (void)showMenuViewController:(UIView *)showInView message:(ECMessage*)message {
    
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
    }
    
    if (_transmitMenuItem == nil) {
        _transmitMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transmitMessage:)];
    }
    
    
    if (_revokeMenuItem == nil) {
        _revokeMenuItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeMessage:)];
    }
    
    objc_setAssociatedObject(_menuController, &KMenuViewKey, message, OBJC_ASSOCIATION_RETAIN);
    MessageBodyType messageType = message.messageBody.messageBodyType;
    if (messageType == MessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem, _transmitMenuItem]];
        
    } else if (messageType== MessageBodyType_Image || messageType==MessageBodyType_Preview)
    {
        // 检测是否安装了微信
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
        {
            
        }
        else
        {
            [_menuController setMenuItems:@[_deleteMenuItem, _transmitMenuItem]];
        }
        
    } else {
        [_menuController setMenuItems:@[_deleteMenuItem, _transmitMenuItem]];
    }
    
    NSTimeInterval tmp = [[NSDate date] timeIntervalSince1970]*1000;
    NSInteger count = tmp - message.timestamp.longLongValue;
    if (message.messageState == ECMessageState_SendSuccess && count<=RevokeMessageTime && ![message.from isEqualToString:message.to]) {
        NSMutableArray *arr = [_menuController.menuItems mutableCopy];
        [arr addObject:_revokeMenuItem];
        _menuController.menuItems = arr;
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

#pragma mark - 复制消息
- (void)copyMenuAction:(id)sender {
    [_menuController setMenuItems:nil];
    //复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row < self.messageArray.count) {
        ECMessage *message = [self.messageArray objectAtIndex:_longPressIndexPath.row];
        ECTextMessageBody *body = (ECTextMessageBody*)message.messageBody;
        pasteboard.string = body.text;
    }
    _longPressIndexPath = nil;
}

#pragma mark - 删除消息
- (void)deleteMenuAction:(id)sender {
    [_menuController setMenuItems:nil];
    if (_longPressIndexPath && _longPressIndexPath.row >= 0) {
        ECMessage *message = [self.messageArray objectAtIndex:_longPressIndexPath.row];
        NSNumber* isplay = objc_getAssociatedObject(message, &KVoiceIsPlayKey);
        if (isplay.boolValue) {
            objc_setAssociatedObject(self.playVoiceMessage, &KVoiceIsPlayKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [[ECDevice sharedInstance].messageManager stopPlayingVoiceMessage];
            self.playVoiceMessage = nil;
        }
        
        if (message==self.messageArray.lastObject) {
            //删除最后消息才需要刷新session
            if (message==self.messageArray.firstObject) {
                //如果删除的也是唯一一个消息，删除session
                [[DeviceDBHelper sharedInstance] deleteMessage:message andPre:nil];
            } else {
                //使用前一个消息刷新session
                [[DeviceDBHelper sharedInstance] deleteMessage:message andPre:[self.messageArray objectAtIndex:_longPressIndexPath.row-1]];
            }
        } else {
            [[IMMsgDBAccess sharedInstance] deleteMessage:message.messageId andSession:self.sessionId];
        }
        
        [self.messageArray removeObject:message];
        [self.tableView deleteRowsAtIndexPaths:@[_longPressIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - 消息撤回
-(void)revokeMessage:(UIMenuController*)menu {
    
    [_menuController setMenuItems:nil];
    if (_longPressIndexPath && _longPressIndexPath.row >= 0) {
        ECMessage *message = [self.messageArray objectAtIndex:_longPressIndexPath.row];
        NSNumber* isplay = objc_getAssociatedObject(message, &KVoiceIsPlayKey);
        if (isplay.boolValue) {
            objc_setAssociatedObject(self.playVoiceMessage, &KVoiceIsPlayKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [[ECDevice sharedInstance].messageManager stopPlayingVoiceMessage];
            self.playVoiceMessage = nil;
        }
        
        NSInteger row = _longPressIndexPath.row;
        __weak typeof(self)weakSelf = self;
        [[ECDevice sharedInstance].messageManager revokeMessage:message completion:^(ECError *error, ECMessage *message) {
            
            __strong typeof(weakSelf)strongSelf = weakSelf;
            NSLog(@"撤回消息 error=%d", (int)error.errorCode);
            if (error.errorCode == ECErrorType_NoError) {
                ECRevokeMessageBody *revokeBody = [[ECRevokeMessageBody alloc] initWithText:@"你撤回了一条消息"];
                ECMessage *amessage = [[ECMessage alloc] initWithReceiver:message.sessionId body:revokeBody];
                NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
                amessage.timestamp = [NSString stringWithFormat:@"%lld", (long long)tmp];
                amessage.isRead = YES;
                amessage.isGroup = NO;
                amessage.messageState = ECMessageState_SendSuccess;
                [strongSelf.messageArray replaceObjectAtIndex:row withObject:amessage];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [strongSelf scrollTableView];
                [[DeviceDBHelper sharedInstance] updateSrcMessage:message.sessionId msgid:message.messageId withDstMessage:amessage];
            } else {
                MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString stringWithFormat:@"错误码:%d",(int)error.errorCode];
                hud.margin = 10.0f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }
        }];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - 转发消息到联系人
-(void)transmitMessage:(UIMenuController*)menu
{
    ECMessage *message = (ECMessage*)objc_getAssociatedObject(menu, &KMenuViewKey);
    TransmitContactViewController *contactVc = [[TransmitContactViewController alloc] init];
    contactVc.message = message;
    [self.navigationController pushViewController:contactVc animated:YES];
}

#pragma mark - 点击消息触发UIResponder custom
- (void)dispatchCustomEventWithName:(NSString *)name userInfo:(NSDictionary *)userInfo
{
    ECMessage * message = [userInfo objectForKey:KResponderCustomECMessageKey];
    if ([name isEqualToString:KResponderCustomChatViewFileCellBubbleViewEvent])
    {
        [self fileCellBubbleViewTap:message];
    }
    else if ([name isEqualToString:KResponderCustomChatViewImageCellBubbleViewEvent])
    {
        [self imageCellBubbleViewTap:message];
    }
    else if ([name isEqualToString:KResponderCustomChatViewVoiceCellBubbleViewEvent])
    {
        [self voiceCellBubbleViewTap:message];
    }
    else if ([name isEqualToString:KResponderCustomChatViewCellResendEvent])
    {
        
        ChatViewCell *resendCell = [userInfo objectForKey:KResponderCustomTableCellKey];
        ECMessage *message = resendCell.displayMessage;

        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"重发该消息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重发",nil];
        objc_setAssociatedObject(alertView, &KAlertResendMessage, message, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        alertView.tag = Alert_ResendMessage_Tag;
        [alertView show];
        
    } else if ([name isEqualToString:KResponderCustomECMessagePortraitImgKey])
    {
        //点击用户头像 进入用户详情页面
        NSString *sendPhone = message.from;
        if ([sendPhone isEqualToString:[DemoGlobalClass sharedInstance].userName])
        {
//            id viewController = [[NSClassFromString(@"PersonViewController") alloc] init];
//            [self.navigationController pushViewController:viewController animated:YES];

        }
        else
        {
            ContactDetailViewController *contactVC = [[ContactDetailViewController alloc] init];
            contactVC.dict = @{nameKey:[[DemoGlobalClass sharedInstance] getOtherNameWithPhone:sendPhone],phoneKey:sendPhone,imageKey:[[DemoGlobalClass sharedInstance] getOtherImageWithPhone:sendPhone]};
            [self.navigationController pushViewController:contactVC animated:YES];
        }
        
    }
    else if ([name isEqualToString:KResponderCustomChatViewTextLnkCellBubbleViewEvent]) {
        
        NSString *url = [userInfo objectForKey:@"url"]?:nil;
        WebBrowserBaseViewController *webBrowserVC = [[WebBrowserBaseViewController alloc] init];
        webBrowserVC.view.tag = Message_Link;
        webBrowserVC.urlStr = url;
        webBrowserVC.delegate = self;
        [self.navigationController pushViewController:webBrowserVC animated:YES];
        
    } else if ([name isEqualToString:KResponderCustomChatViewPreviewCellBubbleViewEvent]) {
        
        ECPreviewMessageBody *body = (ECPreviewMessageBody*)message.messageBody;
        WebBrowserBaseViewController *webBrowserVC = [[WebBrowserBaseViewController alloc] initWithBody:body andDelegate:self];
        webBrowserVC.view.tag = Message_Link;
        [self.navigationController pushViewController:webBrowserVC animated:YES];
    }
    else if ([name isEqualToString:KResponderCustomChatViewCellMessageReadStateEvent])
    {
        ReadMessageViewController *readVC = [[ReadMessageViewController alloc] initWithMessage:message];
        [self.navigationController pushViewController:readVC animated:YES];
    }
}

-(void)fileCellBubbleViewTap:(ECMessage*)message {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"无法打开该文件";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(void)playVoiceMessage:(ECMessage*)message {
    
    NSNumber* isplay = objc_getAssociatedObject(message, &KVoiceIsPlayKey);
    if (isplay == nil) {
        //首次点击
        isplay = @YES;
    } else {
        isplay = @(!isplay.boolValue);
    }
    
    if (self.playVoiceMessage) {
        //如果前一个在播放
        objc_setAssociatedObject(self.playVoiceMessage, &KVoiceIsPlayKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[ECDevice sharedInstance].messageManager stopPlayingVoiceMessage];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.messageArray indexOfObject:self.playVoiceMessage] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        self.playVoiceMessage = nil;
    }

    __weak __typeof(self) weakSelf = self;
    if (isplay.boolValue) {
        self.playVoiceMessage = message;
        objc_setAssociatedObject(message, &KVoiceIsPlayKey, isplay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if ([DemoGlobalClass sharedInstance].isPlayEar) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        } else {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        }
        
        [[ECDevice sharedInstance].messageManager playVoiceMessage:(ECVoiceMessageBody*)message.messageBody completion:^(ECError *error) {
            if (weakSelf) {
                objc_setAssociatedObject(weakSelf.playVoiceMessage, &KVoiceIsPlayKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                weakSelf.playVoiceMessage = nil;
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.messageArray indexOfObject:self.playVoiceMessage] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView endUpdates];
            }
        }];
        
        [weakSelf.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.messageArray indexOfObject:self.playVoiceMessage] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.tableView endUpdates];
    }
}

-(void)voiceCellBubbleViewTap:(ECMessage*)message{
    
    ECVoiceMessageBody* mediaBody = (ECVoiceMessageBody*)message.messageBody;
    if (mediaBody.localPath.length>0 && [[NSFileManager defaultManager] fileExistsAtPath:mediaBody.localPath]) {
         [self playVoiceMessage:message];
    } else if (message.messageState == ECMessageState_Receive && mediaBody.remotePath.length>0){
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"正在获取文件";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        __weak __typeof(self)weakSelf = self;
        [[DeviceChatHelper sharedInstance] downloadMediaMessage:message andCompletion:^(ECError *error, ECMessage *message) {
            
            if (weakSelf == nil) {
                return;
            }
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            if (error.errorCode != ECErrorType_NoError) {
                MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"获取文件失败";
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
            }
        }];
    }
}

-(void)imageCellBubbleViewTap:(ECMessage*)message
{
    if (message.messageBody.messageBodyType >= MessageBodyType_Voice) {
        ECImageMessageBody *mediaBody = (ECImageMessageBody*)message.messageBody;
        
        if (mediaBody.localPath.length>0 && [[NSFileManager defaultManager] fileExistsAtPath:mediaBody.localPath]) {
            
            _isOpenSavePhoto = ![message.userData myContainsString:@"fireMessage"];
            [self showPhotoBrowser:[self getImageMessageLocalPath] index:[self getImageMessageIndex:mediaBody]];
            
        } else if (message.messageState == ECMessageState_Receive && mediaBody.remotePath.length>0 && ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",message.messageId]]==NO)) {
            
            MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在获取文件";
            hud.removeFromSuperViewOnHide = YES;
            
            __weak __typeof(self)weakSelf = self;
            
            [[DeviceChatHelper sharedInstance] downloadMediaMessage:message andCompletion:^(ECError *error, ECMessage *message) {
                
                if (weakSelf == nil) {
                    return ;
                }
                
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                if (error.errorCode == ECErrorType_NoError) {
                    if ([mediaBody.localPath hasSuffix:@".jpg"] || [mediaBody.localPath hasSuffix:@".png"]) {
                        
                        [strongSelf showPhotoBrowser:[self getImageMessageLocalPath] index:[self getImageMessageIndex:mediaBody]];
                    }
                } else {
                    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"获取文件失败";
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:2];
                }
            }];
        }
    }
}

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == Alert_ResendMessage_Tag) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            ECMessage *message = objc_getAssociatedObject(alertView, &KAlertResendMessage);
            [self.messageArray removeObject:message];
            [[DeviceChatHelper sharedInstance] resendMessage:message];
            [self.messageArray addObject:message];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 图片浏览器 Photo browser

//获取会话消息里面为图片消息的路径数组
- (NSArray *)getImageMessageLocalPath
{
    NSArray *imageMessage = [[DeviceDBHelper sharedInstance] getAllTypeMessageLocalPathOfSessionId:self.sessionId type:MessageBodyType_Image];
    NSMutableArray *localPathArray = [NSMutableArray array];
    NSString *localPath = [NSString string];
    for (int index = 0; index < imageMessage.count; index++) {
        localPath = [[imageMessage objectAtIndex:index] localPath];
        if (localPath) {//图片路径
            localPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:localPath.lastPathComponent];
            [localPathArray addObject:localPath];
        }
    }
    return localPathArray;
}

// 返回点击图片的索引号
- (NSInteger)getImageMessageIndex:(ECImageMessageBody *)mediaBody
{
    NSArray *array = [self getImageMessageLocalPath];
    NSInteger index = 0;
    for (int i= 0;i<array.count;i++) {
        
        if ([[array objectAtIndex:i] isEqualToString:mediaBody.localPath]) {
            index = i;
        }
    }
    return index;
}

//展示图片
-(void)showPhotoBrowser:(NSArray*)imageArray index:(NSInteger)currentIndex
{
    if (imageArray && [imageArray count] > 0)
    {
        IMPreviewScrollViewController *imageVC = [[IMPreviewScrollViewController alloc]initWithImageArray:imageArray CurrentIndex:currentIndex];
        imageVC.navigationController.navigationBarHidden = YES;
       [self.navigationController pushViewController:imageVC animated:YES];
    }
    
}

#pragma mark - 创建工具栏和布局变化操作

- (void)createAmplitudeImageView
{

    _amplitudeSuperView = [[UIView alloc] initWithFrame:CGRectMake(0,0 , kScreenWidth, [UIScreen mainScreen].bounds.size.height-ToolbarRecordViewHeight)];
    _amplitudeSuperView.backgroundColor = [UIColor grayColor];
    _amplitudeSuperView.alpha = 0.8;
    [self.tableView setUserInteractionEnabled:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:_amplitudeSuperView];
    
    self.amplitudeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"press_speak_icon_07"]];
    _amplitudeImageView.center = CGPointMake(kScreenWidth/2, self.view.bounds.size.height/2-40.0f);
    self.recordInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, _amplitudeImageView.frame.size.height-40.0f, _amplitudeImageView.frame.size.width, 30.0f)];
    _recordInfoLabel.backgroundColor = [UIColor clearColor];
    _recordInfoLabel.textAlignment = NSTextAlignmentCenter;
    _recordInfoLabel.textColor = [UIColor whiteColor];
    _recordInfoLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [_amplitudeImageView addSubview:_recordInfoLabel];
    [_amplitudeSuperView addSubview:_amplitudeImageView];
}

#pragma mark - 录音操作

//按下操作
-(void)recordButtonTouchDown:(ECDeviceVoiceRecordView*)voiceRecordView {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];

    if (_amplitudeSuperView==nil) {
        //动态添加振幅操作
        [self createAmplitudeImageView];
    }
    
    if (self.playVoiceMessage) {
        //如果有播放停止播放语音
        objc_setAssociatedObject(self.playVoiceMessage, &KVoiceIsPlayKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[ECDevice sharedInstance].messageManager stopPlayingVoiceMessage];
        [self.tableView reloadData];
        self.playVoiceMessage = nil;
    }
    
    static int seedNum = 0;
    if(seedNum >= 1000)
        seedNum = 0;
    seedNum++;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *file = [NSString stringWithFormat:@"tmp%@%03d.amr", currentDateStr, seedNum];

    ECVoiceMessageBody * messageBody = [[ECVoiceMessageBody alloc] initWithFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:file] displayName:file];
    userInputState = UserState_Record;
    if (_timer) {
        [[DeviceChatHelper sharedInstance] sendUserState:userInputState to:self.sessionId];
    }
    
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance].messageManager startVoiceRecording:messageBody error:^(ECError *error, ECVoiceMessageBody *messageBody) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error.errorCode == ECErrorType_RecordTimeOut) {
            
            [strongSelf.amplitudeSuperView removeFromSuperview];
            strongSelf.amplitudeSuperView = nil;
            strongSelf.tableView.userInteractionEnabled = YES;
            [strongSelf sendMediaMessage:messageBody];

        }
    }];
    
    _recordInfoLabel.text = @"手指上划,取消发送";
}

//按钮外抬起操作
-(void)recordButtonTouchUpOutside:(ECDeviceVoiceRecordView*)voiceRecordView {
    
    userInputState = UserState_None;
    if (_timer) {
        [[DeviceChatHelper sharedInstance] sendUserState:userInputState to:self.sessionId];
    }
    
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance].messageManager stopVoiceRecording:^(ECError *error, ECVoiceMessageBody *messageBody) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.amplitudeSuperView removeFromSuperview];
        strongSelf.amplitudeSuperView = nil;
        strongSelf.tableView.userInteractionEnabled = YES;
    }];
}

//按钮内抬起操作
-(void)recordButtonTouchUpInside:(ECDeviceVoiceRecordView*)voiceRecordView {
    userInputState = UserState_None;
    if (_timer) {
        [[DeviceChatHelper sharedInstance] sendUserState:userInputState to:self.sessionId];
    }
    
    __weak __typeof(self)weakSelf = self;
    [[ECDevice sharedInstance].messageManager stopVoiceRecording:^(ECError *error, ECVoiceMessageBody *messageBody) {
        if (weakSelf == nil) {
            return ;
        }
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [strongSelf.amplitudeSuperView removeFromSuperview];
        strongSelf.amplitudeSuperView = nil;
        strongSelf.tableView.userInteractionEnabled = YES;

        if (error.errorCode == ECErrorType_NoError)
        {
            [strongSelf sendMediaMessage:messageBody];
            
        } else if  (error.errorCode == ECErrorType_RecordTimeTooShort) {
            
            MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.userInteractionEnabled = NO;
            hud.labelText = @"录音时间过短";
            hud.margin = 10.0f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.0f];
        }
    }];
}

//手指划出按钮
-(void)recordDragOutside:(ECDeviceVoiceRecordView*)voiceRecordView {
    _recordInfoLabel.text = @"松开手指,取消发送";
}

//手指划入按钮
-(void)recordDragInside:(ECDeviceVoiceRecordView*)voiceRecordView {
    _recordInfoLabel.text = @"手指上划,取消发送";
}

-(void)recordingAmplitude:(NSNotification*)notification {
    userInputState = UserState_Record;
    double amplitude = ((NSNumber*)notification.object).doubleValue;
    if (amplitude<0.14) {
        _amplitudeImageView.image = [UIImage imageNamed:@"press_speak_icon_07"];
    } else if (0.14<= amplitude <0.28) {
        _amplitudeImageView.image = [UIImage imageNamed:@"press_speak_icon_06"];
    } else if (0.28<= amplitude <0.42) {
        _amplitudeImageView.image = [UIImage imageNamed:@"press_speak_icon_05"];
    } else if (0.42<= amplitude <0.57) {
        _amplitudeImageView.image = [UIImage imageNamed:@"press_speak_icon_04"];
    } else if (0.57<= amplitude <0.71) {
        _amplitudeImageView.image = [UIImage imageNamed:@"press_speak_icon_03"];
    } else if (0.71<= amplitude <0.85) {
        _amplitudeImageView.image = [UIImage imageNamed:@"press_speak_icon_02"];
    } else if (0.85<= amplitude) {
        _amplitudeImageView.image = [UIImage imageNamed:@"press_speak_icon_01"];
    }
}

#pragma mark - moreview 动作

/**
 *@brief 图片按钮
 */
-(void)pictureBtnTap:(id)sender
{
    isReadDeleteMessage = NO;
    // 弹出照片选择
    [self popTypeOfImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)popTypeOfImagePicker:(UIImagePickerControllerSourceType)sourceType {
    
    userInputState = UserState_None;
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

/**
 *@brief 照相按钮
 */
-(void)cameraBtnTap:(id)sender {
    isReadDeleteMessage = NO;
    userInputState = UserState_None;
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

#if 0
    //只照相
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
#else
    //支持视频功能
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    imagePicker.videoMaximumDuration = 30;
#endif
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        //判断相机是否能够使用
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusAuthorized) {
            // authorized
             [self presentViewController:imagePicker animated:YES completion:NULL];
        } else if(status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
            // restricted
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在“设置-隐私-相机”选项中允许访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            });
        } else if(status == AVAuthorizationStatusNotDetermined){
            // not determined
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                     [self presentViewController:imagePicker animated:YES completion:NULL];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        [[[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在“设置-隐私-相机”选项中允许访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        isReadDeleteMessage = YES;

        NSString* button = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([button isEqualToString:@"拍照"]) {
            [self popTypeOfImagePicker:UIImagePickerControllerSourceTypeCamera];
        } else if ([button isEqualToString:@"从相册中选取"]) {
            [self popTypeOfImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
}

#pragma mark - 保存音视频文件

- (NSURL *)convertToMp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];

    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPreset640x480]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset
                                                                              presetName:AVAssetExportPreset640x480];
        
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSString* fileName = [NSString stringWithFormat:@"%@.mp4", [formater stringFromDate:[NSDate date]]];
        NSString* path = [NSString stringWithFormat:@"file:///private%@",[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]];
        mp4Url = [NSURL URLWithString:path];
        
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        
        if (wait) {
            wait = nil;
        }
    }
    
    return mp4Url;
}

-(void)saveGifToDocument:(NSURL *)srcUrl {
    
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset) {
        
        if (asset != nil) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *imageBuffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger bufferSize = [rep getBytes:imageBuffer fromOffset:0.0 length:(unsigned long)rep.size error:nil];
            NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
            
            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
            NSString* fileName =[NSString stringWithFormat:@"%@.gif", [formater stringFromDate:[NSDate date]]];
            NSString* filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];

            [imageData writeToFile:filePath atomically:YES];
            
            ECImageMessageBody *mediaBody = [[ECImageMessageBody alloc] initWithFile:filePath displayName:filePath.lastPathComponent];
            [self sendMediaMessage:mediaBody];
        } else {
        }
    };
    
    ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:srcUrl
                  resultBlock:resultBlock
                 failureBlock:^(NSError *error){
                 }];
}

-(NSString*)saveToDocument:(UIImage*)image
{
    UIImage* fixImage = [image fixOrientation];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString* fileName =[NSString stringWithFormat:@"%@.jpg", [formater stringFromDate:[NSDate date]]];
    
    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    //图片按0.5的质量压缩－》转换为NSData
    CGSize pressSize = CGSizeMake((DefaultPressImageHigth/fixImage.size.height) * fixImage.size.width, DefaultPressImageHigth);
    UIImage * pressImage = [CommonTools compressImage:fixImage withSize:pressSize];
    NSData *imageData = UIImageJPEGRepresentation(pressImage, 0.5);
    [imageData writeToFile:filePath atomically:YES];
    
    CGSize thumsize = CGSizeMake((DefaultThumImageHigth/fixImage.size.height) * fixImage.size.width, DefaultThumImageHigth);
    UIImage * thumImage = [CommonTools compressImage:fixImage withSize:thumsize];
    NSData * photo = UIImageJPEGRepresentation(thumImage, 0.5);
    NSString * thumfilePath = [NSString stringWithFormat:@"%@.jpg_thum", filePath];
    [photo writeToFile:thumfilePath atomically:YES];

    return filePath;
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:nil];

        // we will convert it to mp4 format
        NSURL *mp4 = [self convertToMp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }

        
    } else {
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        NSString* ext = imageURL.pathExtension.lowercaseString;

        if ([ext isEqualToString:@"gif"]) {
            [self saveGifToDocument:imageURL];
        } else {
            NSString *imagePath = [self saveToDocument:orgImage];
            ECImageMessageBody *mediaBody = [[ECImageMessageBody alloc] initWithFile:imagePath displayName:imagePath.lastPathComponent];
            [self sendMediaMessage:mediaBody];
        }
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

#pragma mark - 输入框的代理InputToolBarViewDelegate

- (void)toolBarWillChangeFame:(CGRect)toobarFrame completion:(void (^)())completion {
    
    __weak typeof(self)weakSelf = self;
    void(^animations)() = ^{
        CGRect frame = weakSelf.tableView.frame;
        frame.size.height = toobarFrame.origin.y;
        weakSelf.tableView.frame = frame;
        completion();
    };
    
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
    if (self.tableView && self.messageArray.count>0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)onclickedMoreView:(InputToolBarView *)inputToolBarView moreview:(MoreView *)moreView btnTitle:(NSString*)title
{
    if ([title isEqualToString:@"图片"])
    {
        [self pictureBtnTap:nil];
    }
    else if ([title isEqualToString:@"拍摄"])
    {
        [self cameraBtnTap:nil];
    }
       
}

- (void)inputTooBarView:(InputToolBarView *)inputToolBarView growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    __weak __typeof(self)weakSelf = self;
    float diff = (growingTextView.frame.size.height - height);
    void(^animations)() = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            CGRect rect = _inputToolBarView.frame;
            rect.size.height -= diff;
            rect.origin.y += diff;
            _inputToolBarView.frame = rect;
            
            CGRect tableFrame = strongSelf.tableView.frame;
            tableFrame.size.height += diff;
            strongSelf.tableView.frame = tableFrame;
        }
    };
    
    [UIView animateWithDuration:0.1 delay:0.0f options:(UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
    if (self && self.messageArray.count>0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (BOOL)inputTooBarView:(InputToolBarView *)inputToolBarView growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    { //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self sendTextMessage];
        growingTextView.text = @"";
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    NSString *frontStr = [growingTextView.text substringToIndex:range.location+range.length];
    if ([self.sessionId hasPrefix:@"g"] && [frontStr hasSuffix:_deleteAtStr] && [text isEqualToString:@""]) {
        NSArray *array = [frontStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:_deleteAtStr]];
        if (array.count>0 && [DemoGlobalClass sharedInstance].AtPersonArray.count!=0) {
            [[DemoGlobalClass sharedInstance].AtPersonArray removeObjectAtIndex:array.count-2];
        }
        NSRange startRange = [growingTextView.text rangeOfString:@"@" options:NSBackwardsSearch range:NSMakeRange(0, range.location)];
        if (startRange.length==0) {
            return YES;
        }
        growingTextView.text = [growingTextView.text stringByReplacingCharactersInRange:NSMakeRange(startRange.location, range.location-startRange.location+range.length) withString:@""];
        return NO;
    }
    userInputState = UserState_Write;
    if ([self.sessionId hasPrefix:@"g"] && [text isEqualToString:@"@"])
    {
        isOpenMembersList = YES;
//        GroupMembersViewController *membersList = [[GroupMembersViewController alloc] init];
//        membersList.groupID = self.sessionId;
//        arrowLocation = range.location+1;
//        dispatch_after(0.1, dispatch_get_main_queue(), ^{
//            [self.navigationController pushViewController:membersList animated:YES];
//        });
    }
    
    if (range.length == 1) {
        return YES;
    }
    return YES;
}

//获取焦点
- (void)inputTooBarView:(InputToolBarView *)inputToolBarView growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
    userInputState = UserState_Write;
    if (_timer) {
        [[DeviceChatHelper sharedInstance] sendUserState:userInputState to:self.sessionId];
    }
    
    [_menuController setMenuItems:nil];
    if ([self.sessionId hasPrefix:@"g"] && [growingTextView.text myContainsString:@"@"] && isOpenMembersList && _GroupMemberNickName.length>0) {
        isOpenMembersList = NO;
        NSMutableString * string = [NSMutableString stringWithFormat:@"%@",growingTextView.text];
        if (growingTextView.text.length<arrowLocation) {
            arrowLocation-=1;
        }
        [string insertString:[NSString stringWithFormat:@"%@",_GroupMemberNickName] atIndex:arrowLocation];
        growingTextView.text = [NSString stringWithFormat:@"%@",string];
        _GroupMemberNickName = nil;
    }

}

//失去焦点
- (void)inputTooBarView:(InputToolBarView *)inputToolBarView growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    userInputState = UserState_None;
    if (_timer) {
        [[DeviceChatHelper sharedInstance] sendUserState:userInputState to:self.sessionId];
    }
}

- (void)inputTooBarView:(InputToolBarView *)inputToolBarView growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView {
    if (growingTextView.text.length > 0) {
        if (userInputState != UserState_Write) {
            userInputState = UserState_Write;
            if (_timer) {
                [[DeviceChatHelper sharedInstance] sendUserState:userInputState to:self.sessionId];
            }
        }
    }
}

#pragma mark - 发送消息操作
/**
 *@brief 发送媒体类型消息
 */
-(void)sendMediaMessage:(ECFileMessageBody*)mediaBody {
    userInputState = UserState_None;
    ECMessage *message = [[ECMessage alloc] init];
    if (isReadDeleteMessage) {
        message = [[DeviceChatHelper sharedInstance] sendMediaMessage:mediaBody to:self.sessionId withUserData:@"fireMessage"];
    } else {
        message = [[DeviceChatHelper sharedInstance] sendMediaMessage:mediaBody to:self.sessionId];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:message];
}

/**
 *@brief 发送文本消息
 */
-(void)sendTextMessage {
    
    userInputState = UserState_None;
    if (_timer) {
        [[DeviceChatHelper sharedInstance] sendUserState:userInputState to:self.sessionId];
    }
    
    NSMutableCharacterSet *set = [NSMutableCharacterSet whitespaceCharacterSet];
    [set removeCharactersInString:_deleteAtStr];
    NSString * textString = [_inputToolBarView.inputTextView.text stringByTrimmingCharactersInSet:set];
    if (textString.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"不能发送空白消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    ECMessage* message;
    if ([self.sessionId hasPrefix:@"g"] && [textString myContainsString:_deleteAtStr]) {
        NSMutableArray *personArray = [DemoGlobalClass sharedInstance].AtPersonArray;
        NSArray *array = [textString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"@%@",_deleteAtStr]]];
        for (NSString *str in array) {
            NSArray *bookArray = [DemoGlobalClass sharedInstance].groupMemberArray;
            for (AddressBook *book in bookArray) {
                if ([str isEqualToString:book.name]) {
                    [personArray addObject:book.phones.allValues.firstObject];
                    NSSet *set = [NSSet setWithArray:personArray];
                    personArray = [NSMutableArray arrayWithObject:set.allObjects];
                }
            }
        }
        message = [[DeviceChatHelper sharedInstance] sendTextMessage:textString to:self.sessionId withUserData:nil atArray:personArray];
    } else {
        message = [[DeviceChatHelper sharedInstance] sendTextMessage:textString to:self.sessionId];
    }
    [[DemoGlobalClass sharedInstance].AtPersonArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:message];
}

/**
 *@brief 发送成功，消息状态更新
 */
-(void)sendMessageCompletion:(NSNotification*)notification {
    
    ECMessage* message = notification.userInfo[KMessageKey];
    __weak  __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if ([strongSelf.sessionId isEqualToString:message.sessionId]) {
            for (NSInteger i=strongSelf.messageArray.count-1; i>=0 ; i--) {
                id content = [strongSelf.messageArray objectAtIndex:i];
                if ([content isKindOfClass:[NSNull class]]) {
                    continue;
                }
                ECMessage *currMsg = (ECMessage *)content;
                if ([message.messageId isEqualToString:currMsg.messageId]) {
                    currMsg.messageState = message.messageState;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.tableView beginUpdates];
                        if ([message.sessionId hasPrefix:@"g"]) {
                            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:[NSString stringWithFormat:@"%@_%@",message.messageId,CellMessageReadCount]];
                            [[NSUserDefaults standardUserDefaults] setInteger:_readMessageCount forKey:[NSString stringWithFormat:@"%@_%@",message.messageId,CellMessageUnReadCount]];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [strongSelf.tableView endUpdates];
                    });
                    break;
                }
            }
        }
    });
}

//下载媒体消息附件完成，状态更新
-(void)downloadMediaAttachFileCompletion:(NSNotification*)notification {
    
    ECError *error = notification.userInfo[KErrorKey];
    if (error.errorCode != ECErrorType_NoError) {
        return;
    }
    
    ECMessage* message = notification.userInfo[KMessageKey];
    __weak  __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if ([strongSelf.sessionId isEqualToString:message.sessionId]) {
            for (NSInteger i=strongSelf.messageArray.count-1; i>=0; i--) {
                id content = [strongSelf.messageArray objectAtIndex:i];
                if ([content isKindOfClass:[NSNull class]]) {
                    continue;
                }
                ECMessage *currMsg = (ECMessage *)content;
                if (currMsg.messageBody.messageBodyType == MessageBodyType_File) {
                    currMsg = [[IMMsgDBAccess sharedInstance] getMessagesWithMessageId:currMsg.messageId OfSession:currMsg.sessionId];
                }
                if ([message.messageId isEqualToString:currMsg.messageId]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.tableView beginUpdates];
                        [strongSelf.messageArray replaceObjectAtIndex:i withObject:currMsg];
                        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [strongSelf.tableView endUpdates];
                    });
                    break;
                }
            }
        }
    });
}

- (void)sendTextMessageWithText:(NSString*)text userData:(NSString*)userData
{
    userInputState = 0;
    if (_timer)
    {
        [[DeviceChatHelper sharedInstance] sendUserState:UserState_None to:self.sessionId];
    }

    ECTextMessageBody *messageBody = [[ECTextMessageBody alloc] initWithText:text];
    ECMessage *message = [[ECMessage alloc] initWithReceiver:self.sessionId body:messageBody];
    message.userData = userData;
    ECMessage* sendMessage = [[DeviceChatHelper sharedInstance] sendMessage:message];;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:sendMessage];
}

#pragma mark - 发送抓取链接消息
- (void)onSendPreviewMsgWithUrl:(NSString *)url title:(NSString *)title imgRemotePath:(NSString *)imgRemotePath imgLocalPath:(NSString *)imgLocalPath imgThumbPath:(NSString *)imgThumbPath description:(NSString *)description
{
    
    ECMessage *message = [[ECMessage alloc] init];
    ECPreviewMessageBody *msgBody = [[ECPreviewMessageBody alloc] initWithFile:imgLocalPath displayName:[imgLocalPath lastPathComponent]];
    msgBody.url = url;
    msgBody.title = title;
    msgBody.remotePath = imgRemotePath;
    msgBody.desc = description;
    msgBody.thumbnailLocalPath = imgThumbPath;
    message = [[DeviceChatHelper sharedInstance] sendMediaMessage:msgBody to:self.sessionId];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:message];
}

#pragma mark - 发送用户输入状态消息
-(void)startTimer
{

    __weak typeof(self) weakself = self;
    if (_timer == 0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 10.0*NSEC_PER_SEC, 0); //10秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if (weakself && userInputState!=UserState_None) {
                [[DeviceChatHelper sharedInstance] sendUserState:userInputState to:weakself.sessionId];
            }
            
        });
        dispatch_resume(_timer);
    }
}

#pragma mark  收到用户输入状态消息

- (void)notifyUserState:(NSNotification*)notification {
    
    ECMessage *message = (ECMessage*)notification.object;
    if (![message.sessionId isEqualToString:self.sessionId]) {
        return;
    }
    
    if (_detectTimer) {
        dispatch_source_cancel(_detectTimer);
        _detectTimer = 0;
    }
    
    if (message.messageBody.messageBodyType == MessageBodyType_UserState) {
        ECUserStateMessageBody *body = (ECUserStateMessageBody*)message.messageBody;
        int state = [body.userState intValue];
        if (state==UserState_Write) {
            _titleLabel.text = @"正在输入...";
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _detectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_detectTimer,dispatch_time(DISPATCH_TIME_NOW, 12ull*NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
            dispatch_source_set_event_handler(_detectTimer, ^{
                dispatch_source_cancel(_detectTimer);
                _detectTimer = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _titleLabel.text = [[DemoGlobalClass sharedInstance] getOtherNameWithPhone:self.sessionId];
                });
            });
            dispatch_resume(_detectTimer);
            
        } else if (state==UserState_Record) {
            
            _titleLabel.text = @"正在录音...";
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _detectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_detectTimer,dispatch_time(DISPATCH_TIME_NOW, 12ull*NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
            dispatch_source_set_event_handler(_detectTimer, ^{
                dispatch_source_cancel(_detectTimer);
                _detectTimer = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _titleLabel.text = [[DemoGlobalClass sharedInstance] getOtherNameWithPhone:self.sessionId];
                });
            });
            dispatch_resume(_detectTimer);
            
        } else {
            _titleLabel.text = [[DemoGlobalClass sharedInstance] getOtherNameWithPhone:self.sessionId];
        }
    }
}

//拿到聊天的用户信息
- (void)getUserAccountWithUserID:(NSString *)userIDStr
{
    HttpManager *httpManager = [[HttpManager alloc]init];
    NSDictionary *dict = @{@"cur_page":@"1",@"cur_size":@"1",@"parent_id":userIDStr,@"user_id":@"",@"sure_type":@"sure"};

    [httpManager personalSureStatusWithParameterDict:dict CompletionBlock:^(OtherDetaileModel *userDetaileModel, NSError *error)
     {
         if (error)
         {
             
         }
         else
         {
             _accountInfo = userDetaileModel;
//             _titleLabel.text = userDetaileModel.userName;
             
         }
         
     }];

}

@end
