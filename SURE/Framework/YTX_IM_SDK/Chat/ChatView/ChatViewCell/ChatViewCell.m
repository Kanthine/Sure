//
//  ChatViewCell.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/8.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ChatViewCell.h"
#import <objc/runtime.h>

NSString *const KResponderCustomChatViewCellBubbleViewEvent = @"KResponderCustomChatViewCellBubbleViewEvent";
NSString *const KResponderCustomECMessageKey = @"KResponderCustomECMessageKey";

NSString *const KResponderCustomChatViewCellResendEvent = @"KResponderCustomChatViewCellResendEvent";
NSString *const KResponderCustomTableCellKey = @"KResponderCustomTableCellKey";
NSString *const KResponderCustomECMessagePortraitImgKey = @"KResponderCustomECMessagePortraitImgKey";
NSString *const KResponderCustomChatViewCellMessageReadStateEvent = @"KResponderCustomChatViewCellMessageReadStateEvent";

const char KTimeIsShowKey;

#define DefaultFrameY 10.0f

@implementation ChatViewCell {
    UIView *_sendStatusView;
    UIActivityIndicatorView *_activityView;
    UIButton *_retryBtn;
}

-(void)prepareCellUIWithSender:(BOOL)aIsSender
{
    
    self.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.isSender = aIsSender;
    
    if (self.isSender)
    {
        //消息发送方 就是当前用户
        
        self.portraitImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-50.0f, DefaultFrameY, 40.0f, 40.0f)];
        self.portraitImg.layer.cornerRadius = 20.0f;
        self.portraitImg.clipsToBounds = YES;
        self.portraitImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.portraitImg];
        
#pragma mark - 头像
        
        AccountInfo *account = [AccountInfo standardAccountInfo];
        NSString *imageUrl = account.headimg;
        
        [self.portraitImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        self.bubbleView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-self.portraitImg.frame.origin.x-40.0f-10.0f, self.portraitImg.frame.origin.y, 40.0f, self.portraitImg.frame.size.height)];
        UIImageView *bubleimg = [[UIImageView alloc] initWithFrame:self.bubbleView.bounds];
        bubleimg.image = [[UIImage imageNamed:@"chat_sender_bg"] stretchableImageWithLeftCapWidth:33.0f topCapHeight:33.0f];
        bubleimg.tag = 1000;
        _bubleimg = bubleimg;
        [self.bubbleView addSubview:bubleimg];
        bubleimg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.bubbleView];
        
        _sendStatusView = [[UIView alloc] initWithFrame:CGRectMake(self.bubbleView.frame.origin.x-25.0f, 10.0f, 20.0f, 20.0f)];
        _sendStatusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        _sendStatusView.backgroundColor = self.backgroundColor;
        [self.contentView addSubview:_sendStatusView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_sendStatusView addSubview:_activityView];
        _activityView.backgroundColor = [UIColor clearColor];
        
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendStatusView addSubview:_retryBtn];
        _retryBtn.frame = CGRectMake(0, 0, 28, 28);
        [_retryBtn setImage:[UIImage imageNamed:@"messageSendFailed"] forState:UIControlStateNormal];
        [_retryBtn setHidden:YES];
        [_retryBtn addTarget:self action:@selector(resendBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        _receipteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _receipteBtn.frame = CGRectMake(0,0, 60, 28);
        [self.contentView addSubview:_receipteBtn];
        _receipteBtn.backgroundColor = [UIColor clearColor];
        _receipteBtn.hidden = YES;
        
    } else
    {
        //消息发送方

        self.portraitImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 40.0f, 40.0f)];
        self.portraitImg.layer.cornerRadius = 20.0f;
        self.portraitImg.clipsToBounds = YES;
        self.portraitImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.portraitImg];
        
        self.fromId = [[UILabel alloc] initWithFrame:CGRectMake(self.portraitImg.frame.origin.x+self.portraitImg.frame.size.width+10.0f, self.portraitImg.frame.origin.y, 220.0f, 15.0f)];
        self.fromId.font = [UIFont systemFontOfSize:11.0f];
        self.fromId.textColor = [UIColor grayColor];
        self.fromId.backgroundColor = self.backgroundColor;
        [self.contentView addSubview:self.fromId];
        
        
        self.bubbleView = [[UIView alloc] initWithFrame:CGRectMake(self.portraitImg.frame.origin.x+self.portraitImg.frame.size.width+10.0f, self.portraitImg.frame.origin.y, 40.0f, self.portraitImg.frame.size.height)];
        UIImageView *bubleimg = [[UIImageView alloc] initWithFrame:self.bubbleView.bounds];
        bubleimg.image = [[UIImage imageNamed:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:33.0f topCapHeight:33.0f];
        bubleimg.tag = 1000;
        [self.bubbleView addSubview:bubleimg];
        _bubleimg = bubleimg;
        bubleimg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.bubbleView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapGesture:)];
    [self.bubbleView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(portraitImgTapGesture:)];
    self.portraitImg.userInteractionEnabled = YES;
    [self.portraitImg addGestureRecognizer:tap1];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30.0f)];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:11.0f];
    _timeLabel.backgroundColor = self.backgroundColor;
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.hidden = YES;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)bubbleViewWithData:(ECMessage*) message{
    self.displayMessage = message;
}

-(void)bubbleViewTapGesture:(id)sender{
    
    [self dispatchCustomEventWithName:KResponderCustomChatViewCellBubbleViewEvent userInfo:@{KResponderCustomECMessageKey:self.displayMessage}];
}

-(void)resendBtnTap:(id)sender{
    
    [self dispatchCustomEventWithName:KResponderCustomChatViewCellResendEvent userInfo:@{KResponderCustomTableCellKey:self}];
}

-(void)receiptBtnTap:(id)sender{
    
    [self dispatchCustomEventWithName:KResponderCustomChatViewCellMessageReadStateEvent userInfo:@{KResponderCustomECMessageKey:self.displayMessage}];
}

- (void)portraitImgTapGesture:(id)send
{
    [self dispatchCustomEventWithName:KResponderCustomECMessagePortraitImgKey userInfo:@{KResponderCustomECMessageKey:self.displayMessage}];
}
/**
 *@brief 更新发送状态
 */
-(void)updateMessageSendStatus:(ECMessageState)state{
    
    CGFloat imageFrameY = DefaultFrameY;
    //是否显示时间
    NSNumber *isShowNumber = objc_getAssociatedObject(self.displayMessage, &KTimeIsShowKey);
    BOOL isShow = isShowNumber.boolValue;
    _timeLabel.hidden = !isShow;
    
    if (isShow) {
        _timeLabel.text = [self getDateDisplayString:self.displayMessage.timestamp.longLongValue];
        imageFrameY = 40.0f;
    }
    
    CGFloat bubleFrameY = 0.0f;
    if(self.displayMessage.isGroup && !self.isSender) {
        self.fromId.text = [[DemoGlobalClass sharedInstance] getOtherNameWithPhone:self.displayMessage.from];
        bubleFrameY = 15.0f;
        self.fromId.frame = CGRectMake(60.0f, imageFrameY, 220.0f, 15.0f);
    }
    
    CGRect imageFrame = self.portraitImg.frame;
    CGRect bubbleFrame = self.bubbleView.frame;
    imageFrame.origin.y = imageFrameY;
    bubbleFrame.origin.y = imageFrameY+bubleFrameY;
    self.portraitImg.frame = imageFrame;
    self.bubbleView.frame = bubbleFrame;
    

    //更新发送状态显示
    if (self.isSender) {
        if (state == ECMessageState_Sending) {
            [_sendStatusView setHidden:NO];
            
            [_activityView startAnimating];
            [_activityView setHidden:NO];
            
            [_retryBtn setHidden:YES];
            _receipteBtn.hidden = YES;
            _sendStatusView.frame = CGRectMake(self.bubbleView.frame.origin.x-30.0f, self.bubbleView.frame.origin.y+self.bubbleView.frame.size.height*0.5-14.0f, 30.0f, 28.0f);
        } else if (state == ECMessageState_SendFail) {
            [_sendStatusView setHidden:NO];
            
            [_activityView stopAnimating];
            [_activityView setHidden:YES];
            
            [_retryBtn setHidden:NO];
            _receipteBtn.hidden = YES;
            _sendStatusView.frame = CGRectMake(self.bubbleView.frame.origin.x-30.0f, self.bubbleView.frame.origin.y+self.bubbleView.frame.size.height*0.5-14.0f, 30.0f, 28.0f);
        } else if (state == ECMessageState_SendSuccess){
            [_sendStatusView setHidden:YES];
            
            [_activityView stopAnimating];
            [_activityView setHidden:YES];
            
            [_retryBtn setHidden:YES];
            [_retryBtn removeFromSuperview];
            if ([self.displayMessage.from isEqualToString:self.displayMessage.to]) {
                return;
            }
            
            
            NSInteger unreadCount = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_%@",self.displayMessage.messageId,CellMessageUnReadCount]];
            NSInteger readCount = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_%@",self.displayMessage.messageId,CellMessageReadCount]];
            NSString *str = ([self.displayMessage.sessionId hasPrefix:@"g"] && !(readCount==0 && unreadCount==0))?@"人未读":@"未读";
            if (unreadCount>=0 || ![self.displayMessage.sessionId hasPrefix:@"g"]) {
                str = (self.displayMessage.isRead&&unreadCount==0)==YES?@"已读":str;
                NSString *unreadStr = unreadCount==0?str:[NSString stringWithFormat:@"%ld%@",(long)unreadCount,str];
                _receipteBtn.hidden = NO;
                [_receipteBtn setTitle:unreadStr forState:UIControlStateNormal];
                [_receipteBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:_receipteBtn.currentTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:[UIColor redColor]}] forState:UIControlStateNormal];
                CGFloat width = _receipteBtn.currentAttributedTitle.size.width+10;
                CGFloat _receipbtnW = self.bubbleView.frame.origin.x-width;
                _receipteBtn.frame = CGRectMake(_receipbtnW<=0?0:_receipbtnW, self.bubbleView.frame.origin.y+self.bubbleView.frame.size.height*0.5-14.0f, width-10, 28);
                if ([self.displayMessage.sessionId hasPrefix:@"g"]) {
                    [_receipteBtn addTarget:self action:@selector(receiptBtnTap:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            
            
        }
        [self.contentView bringSubviewToFront:_sendStatusView];
    } else {
        if (self.displayMessage.isGroup || self.portraitImg.image == nil) {
            self.portraitImg.image = [[DemoGlobalClass sharedInstance] getOtherImageWithPhone:self.displayMessage.from];
        }
    }
}

//时间显示内容
-(NSString *)getDateDisplayString:(long long) miliSeconds{

    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"今天 HH:mm:ss";
        } else if ((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = @"昨天 HH:mm:ss";
        } else {
            dateFmt.dateFormat = @"MM-dd HH:mm:ss";
        }
    }
    return [dateFmt stringFromDate:myDate];
}

+(CGFloat)getHightOfCellViewWith:(ECMessageBody *)message{
    NSAssert(NO, @"ChatViewCell: 不能调用基类的方法，无实现");
    return 0;
}
@end
