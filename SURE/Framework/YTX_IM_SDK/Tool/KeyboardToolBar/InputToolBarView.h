//
//  InputToolBarView.h
//  ECSDKDemo_OC
//
//  Created by huangjue on 16/6/27.
//  Copyright © 2016年 ronglian. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "MoreView.h"
#import "ECDeviceVoiceRecordView.h"



@class InputToolBarView;

@protocol InputToolBarViewDelegate <NSObject>

@required
- (void)inputTooBarView:(InputToolBarView*)inputToolBarView growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height;
- (BOOL)inputTooBarView:(InputToolBarView*)inputToolBarView growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)inputTooBarView:(InputToolBarView*)inputToolBarView growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
- (void)inputTooBarView:(InputToolBarView*)inputToolBarView growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;
- (void)inputTooBarView:(InputToolBarView*)inputToolBarView growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;

- (void)toolBarWillChangeFame:(CGRect)toobarFrame completion:(void(^)())completion;

@optional
- (void)onclickedMoreView:(InputToolBarView*)inputToolBarView moreview:(MoreView*)moreView btnTitle:(NSString *)title;

- (void)recordButtonTouchDown:(ECDeviceVoiceRecordView*)voiceRecordView;
- (void)recordButtonTouchUpInside:(ECDeviceVoiceRecordView*)voiceRecordView;
- (void)recordButtonTouchUpOutside:(ECDeviceVoiceRecordView*)voiceRecordView;
- (void)recordDragOutside:(ECDeviceVoiceRecordView*)voiceRecordView;
- (void)recordDragInside:(ECDeviceVoiceRecordView*)voiceRecordView;

@end

typedef enum {
    ToolbarDisplay_None=0,
    ToolbarDisplay_Record=1,
    ToolbarDisplay_More=2,
}ToolbarDisplay;

@interface InputToolBarView : UIView<HPGrowingTextViewDelegate,MoreViewDelegate,ECDeviceVoiceRecordViewDelegate>

@property (nonatomic, weak) id<InputToolBarViewDelegate> delegate;

@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) HPGrowingTextView *inputTextView;

@property (nonatomic, assign) ToolbarDisplay btnType;

- (void)resetToolBarToBottom;
@end
