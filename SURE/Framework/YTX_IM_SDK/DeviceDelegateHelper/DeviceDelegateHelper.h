//
//  DeviceDelegateHelper.h
//  SURE
//
//  Created by 王玉龙 on 16/11/21.
//  Copyright © 2016年 longlong. All rights reserved.
//



#define KNOTIFICATION_onConnected       @"KNOTIFICATION_onConnected"

#define KNOTIFICATION_onNetworkChanged    @"KNOTIFICATION_onNetworkChanged"

#define KNOTIFICATION_onSystemEvent    @"KNOTIFICATION_onSystemEvent"

#define KNOTIFICATION_onMesssageChanged    @"KNOTIFICATION_onMesssageChanged"

#define KNOTIFICATION_onRecordingAmplitude    @"KNOTIFICATION_onRecordingAmplitude"

#define KNOTIFICATION_onReceivedGroupNotice    @"KNOTIFICATION_onReceivedGroupNotice"

#define KNOTIFICATION_haveHistoryMessage @"KNOTIFICATION_haveHistoryMessage"
#define KNOTIFICATION_HistoryMessageCompletion @"KNOTIFICATION_HistoryMessageCompletion"

#define KNOTIFICATION_needInputName @"KNOTIFICATION_needInputName"

#define KNOTIFICATION_KickedOff @"KNOTIFICATION_KickedOff"

#define KNOTIFICATION_IsReadMessage    @"KNOTIFICATION_IsReadMessage"

extern NSString *const CellMessageReadCount;
extern NSString *const CellMessageUnReadCount;





#import <Foundation/Foundation.h>


#import "ECDeviceHeaders.h"
#import "AppDelegate.h"



@interface DeviceDelegateHelper : NSObject

/**

*@brief 获取DeviceDelegateHelper单例句柄

*/

+(DeviceDelegateHelper*)sharedInstance;


@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, strong) NSDate* preDate;
@property (nonatomic, assign) BOOL isB2F;
//如需使用IM功能，需实现ECChatDelegate类的回调函数。

//如需使用实时音视频功能，需实现ECVoIPCallDelegate类的回调函数。

//如需使用音视频会议功能，需实现ECMeetingDelegate类的回调函数。


@end
