//
//  CountdownTimeLable.h
//  SURE
//
//  Created by 王玉龙 on 16/11/25.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    CountTimerLabelTypeStopWatch,
    CountTimerLabelTypeTimer
}CountTimerLabelType;


@class CountdownTimeLable;
@protocol MZTimerLabelDelegate <NSObject>
@optional
-(void)timerLabel:(CountdownTimeLable*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime;
-(void)timerLabel:(CountdownTimeLable*)timerlabel countingTo:(NSTimeInterval)time timertype:(CountTimerLabelType)timerType;
@end


@interface CountdownTimeLable : UILabel
{
    
#if NS_BLOCKS_AVAILABLE
    void (^endedBlock)(NSTimeInterval);
#endif
    
    NSTimeInterval timeUserValue;
    
    NSDate *startCountDate;
    NSDate *pausedTime;
    
    NSDate *date1970;
    NSDate *timeToCountOff;
}

/*Delegate for finish of countdown timer */
@property (strong) id<MZTimerLabelDelegate> delegate;

/*Time format wish to display in label*/
@property (nonatomic,strong) NSString *timeFormat;

/*Target label obejct, default self if you do not initWithLabel nor set*/
@property (strong) UILabel *timeLabel;

/*Type to choose from stopwatch or timer*/
@property (assign) CountTimerLabelType timerType;

/*is The Timer Running?*/
@property (assign,readonly) BOOL counting;

/*do you reset the Timer after countdown?*/
@property (assign) BOOL resetTimerAfterFinish;


/*--------Init method to choose*/
-(id)initWithTimerType:(CountTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel andTimerType:(CountTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel;


/*--------Timer control method to use*/
-(void)start;
#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(void(^)(NSTimeInterval countTime))end; //use it if you are not going to use delegate
#endif
-(void)pause;
-(void)reset;

/*--------Setter methods*/
-(void)setCountDownTime:(NSTimeInterval)time;
-(void)setStopWatchTime:(NSTimeInterval)time;


@end


