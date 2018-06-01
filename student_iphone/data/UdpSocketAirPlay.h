//
//  UdpSocketAirPlay.h
//  teacher_ipad
//
//  Created by he chao on 15/1/30.
//  Copyright (c) 2015年 leon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALAirplayView.h"
#import "SamplePopupView.h"

@interface UdpSocketAirPlay : NSObject

@property (nonatomic, strong) ALAirplayView *airplayView;

@property (nonatomic, strong) UIWindow *extWindow;
@property (nonatomic, strong) UIScreen *extScreen;
@property (nonatomic, strong) NSString *ipAddress;

@property (nonatomic, strong) SamplePopupView *samplePopupView;

AS_SINGLETON(UdpSocketAirPlay)

- (void)setupSocketWithIp:(NSString *)ip;
- (void)showChooseView:(UIViewController *)ctrl;
- (void)stopScreen;
- (void)sureSendMsgWithIp:(NSString *)ip;
@end
