//
//  UdpSocketAirPlay.m
//  teacher_ipad
//
//  Created by he chao on 15/1/30.
//  Copyright (c) 2015年 leon. All rights reserved.
//

#import "UdpSocketAirPlay.h"
#import "GCDAsyncUdpSocket.h"
#import "IPDetector.h"
#import "SocketData.h"

@interface UdpSocketAirPlay()<ALAirplayViewDelegate, SamplePopupViewDelete>{
    long tag;
    GCDAsyncUdpSocket *udpSocket;
    NSMutableString *log;
    int windowSubviews;
}
@property (strong, nonatomic) GCDAsyncUdpSocket *myGcdUdpSocket;
@property (copy, nonatomic) NSString *networkIP;

@end

@implementation UdpSocketAirPlay
DEF_SINGLETON(UdpSocketAirPlay)

- (void)setupSocketWithIp:(NSString *)ip{
    if (udpSocket) {
        return;
    }
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:0 error:&error])
    {
        return;
    }
    if (![udpSocket beginReceiving:&error])
    {
        return;
    }
    
//    [addrField setBackgroundColor:[UIColor blueColor]];
//    [addrField setTitle:@"选择教室" forState:UIControlStateNormal];
    
    //默认一教室
    //NSMutableDictionary *d = [SocketData sharedInstance].dictSocket;
//    self.networkIP = [SocketData sharedInstance].dictSocket[@"classRoomGateWay"];//@"192.168.11.9";
    self.networkIP = ip;
    JYDLog(@"classRoomGateWay: %@", self.networkIP);
    
    //[addrField addTarget:self action:@selector(selectRoom) forControlEvents:UIControlEventTouchUpInside];
    
    _samplePopupView = [[SamplePopupView alloc]initWithFrame:CGRectMake(20, 60, 280, 360)];
    _samplePopupView.hidden = YES;
    _samplePopupView.delegete = self;
//    [self.view addSubview:popupView];
    
    /**
     *  add by zhaojian
     *  组播地址默认是224.0.0.2，如果大于224.0.0.2的话，就要设置GCDAsyncUdpSocket的TTL
     */
    self.myGcdUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error2;
    NSLog(@"listenPort%d", 9998);
    [_myGcdUdpSocket bindToPort:9998 error:&error2];
    if (nil != error2)
    {
        NSLog(@"Failed%@", [error2 description]);
    }
    [_myGcdUdpSocket enableBroadcast:YES error:&error2];
    if (nil != error2)
    {
        NSLog(@"Failed%@", [error2 description]);
    }
    //组播
    [_myGcdUdpSocket joinMulticastGroup:@"224.0.0.2" error:&error2];
    if (nil != error2)
    {
        NSLog(@"Failed%@", [error2 description]);
    }
    [_myGcdUdpSocket beginReceiving:&error2];
    if (nil != error2)
    {
        NSLog(@"Failed%@", [error2 description]);
    }
    
    [self performSelector:@selector(refreshIPAddress:) withObject:nil afterDelay:0.0];
}

- (void)showChooseView:(UIViewController *)ctrl{
    [ctrl.view addSubview:_samplePopupView];
    _samplePopupView.hidden = NO;
    _samplePopupView.center = ctrl.view.center;
}

-(void)sureSendMsgWithIp:(NSString *)ip
{
//    self.networkIP = [SocketData sharedInstance].dictSocket[@"classRoomGateWay"];
    self.networkIP = ip;
    [self send:nil];
}

-(void)topSure:roomIP
{
    self.networkIP = roomIP;
//    self.networkIP = [SocketData sharedInstance].dictSocket[@"classRoomGateWay"];
    
    NSLog(@"topSure:%@", roomIP);
    [self send:nil];
}

-(void)bottomSure:roomIP
{
    self.networkIP = roomIP;
//    self.networkIP = [SocketData sharedInstance].dictSocket[@"classRoomGateWay"];
    NSLog(@"bottomSure:%@", roomIP);
    [self send:nil];
}

-(void)dealloc
{
    if (_myGcdUdpSocket)
    {
        [_myGcdUdpSocket close];
    }
}

- (IBAction)send:(id)sender
{
    NSString *host = self.networkIP;
    
    JYDLog(@"---send--To---Host:%@", host);
    
    if ([host length] == 0)
    {
        return;
    }
    
    int port = 9999;
    if (port <= 0 || port > 65535)
    {
        NSLog(@"Valid port required");
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"IOS:[%@]",self.ipAddress];
    if ([msg length] == 0)
    {
        NSLog(@"Message required");
        return;
    }
    
    /**
     *  投屏验证为、ax + 数据长度 + 数据内容 + 11校验位
     *  目前校验位写的固定数值
     *  若想了解校验位计算方法、请联系研发中心
     */
    //数据长度byte类型
    int datalength = (int)msg.length;
    Byte b = (Byte)0xff&datalength;
    NSLog(@"dataLength:%x", b);
    
    //0x61对应a、0x78对应x、datalength是长度的16进制表示
    unsigned char byte[] = {0x61, 0x78, b};
    
    NSData *dataHead = [NSData dataWithBytes:byte length:sizeof(byte)];
    
    //数据体
    NSData *dataBody = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    //校验位
    unsigned char byteCheck[] = {0x12, 0x23, 0x34, 0x12, 0x23, 0x67, 0x34, 0x01, 0x02, 0x35, 0xd9};
    NSData *dataCheck = [NSData dataWithBytes:byteCheck length:sizeof(byteCheck)];
    //NSLog(@"%s", byteCheck);
    
    NSMutableData *totalData = [[NSMutableData alloc]init];
    [totalData appendData:dataHead];
    [totalData appendData:dataBody];
    [totalData appendData:dataCheck];
    
    
    NSData *data = [totalData mutableCopy];
    Byte *sendByte = (Byte *)[data bytes];
    
    NSString *hexStr = @"";
    for (int i=0; i<[data length]; i++)
    {
        //16进制数
        NSString *newHexStr = [NSString stringWithFormat:@"%x", sendByte[i]&0xff];
        if ([newHexStr length] == 1)
        {
            hexStr = [NSString stringWithFormat:@"%@ 0%@",hexStr, newHexStr];
        }
        else
        {
            hexStr = [NSString stringWithFormat:@"%@ %@",hexStr, newHexStr];
        }
    }
    NSLog(@"sendByte的16进制数为:%@", hexStr);
    
    
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
   JYDLog(@"已发送 (%i): %@  目标互动网关IP为: %@ ", (int)tag, msg, host);
    
    tag++;
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"---upSocketDidClose--%@", [error description]);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
    NSLog(@"---didSendDataWithTag--");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
    NSLog(@"---didNotSendDataWithTag--");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSLog(@"-----didReceiveData-----");
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        JYDLog(@"已经接收: %@", msg);
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    }
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    [self performSelector:@selector(refreshIPAddress:) withObject:nil afterDelay:0.0];
//}

#pragma mark - Actions
- (IBAction)refreshIPAddress:(UIButton *)sender
{
    [IPDetector getLANIPAddressWithCompletion:^(NSString *IPAddress) {
        
        self.ipAddress = IPAddress;
        JYDLog(@"获取本地IP成功后发送投屏验证, add by zhaojian IP:--->:%@", self.ipAddress);
        
        //获取本地IP成功后发送投屏验证, add by zhaojian
        [self send:nil];
    }];
}

/**
 *  停止投屏幕
 */
- (void)stopScreen
{
    NSString *host = self.networkIP;
    if ([host length] == 0)
    {
        return;
    }
    
    int port = 9999;
    if (port <= 0 || port > 65535)
    {
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"IOS:[%@]",self.ipAddress];
    if ([msg length] == 0)
    {
        return;
    }
    
    //0x62对应b、0x78对应x
    //停止投屏。pad端给互动教学网关（主控板）发送"bx" + 11字节校验
    //停止成功的时候，返回字符串OK。
    unsigned char byteStop[] = {0x62, 0x78, 0x12, 0x23, 0x34, 0x12, 0x23, 0x67, 0x34, 0x01, 0x02, 0x35, 0xda};
    NSLog(@"%s", byteStop);
    NSData *dataStop = [NSData dataWithBytes:byteStop length:sizeof(byteStop)];
    
    Byte *stopByte = (Byte *)[dataStop bytes];
    
    NSString *hexStr = @"";
    for (int i=0; i<[dataStop length]; i++)
    {
        //16进制数
        NSString *newHexStr = [NSString stringWithFormat:@"%x", stopByte[i]&0xff];
        if ([newHexStr length] == 1)
        {
            hexStr = [NSString stringWithFormat:@"%@ 0%@",hexStr, newHexStr];
        }
        else
        {
            hexStr = [NSString stringWithFormat:@"%@ %@",hexStr, newHexStr];
        }
    }
    NSLog(@"stopByte的16进制数为:%@", hexStr);
    
    
    [udpSocket sendData:dataStop toHost:host port:port withTimeout:-1 tag:tag];
    
    tag++;
}

@end
