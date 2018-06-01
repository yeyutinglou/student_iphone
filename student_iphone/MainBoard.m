//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  MainBoard.m
//  Walker
//
//  Created by he chao on 3/10/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "MainBoard.h"
#import "ClassRoomBoard.h"
#import "NotesBoard.h"
#import "PublicBoard.h"
#import "CommunicationBoard.h"
#import "MeBoard.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "SignInMessage.h"
#import "AppDelegate.h"
#import "JYDCheckUpdate.h"
#pragma mark -
#define TAB_HEIGHT	50.0f

@interface MainBoard(){
    //SocketIO *socketIO;
}

@end


@implementation MainBoard
DEF_SINGLETON(MainBoard)

DEF_SIGNAL( TAB_0 )
DEF_SIGNAL( TAB_1 )
DEF_SIGNAL( TAB_2 )
DEF_SIGNAL( TAB_3 )
DEF_SIGNAL( TAB_4 )

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        bee.ui.router[self.TAB_0] = [ClassRoomBoard class];
        bee.ui.router[self.TAB_1] = [NotesBoard class];
        bee.ui.router[self.TAB_2] = [PublicBoard class];
        bee.ui.router[self.TAB_3] = [CommunicationBoard class];
        bee.ui.router[self.TAB_4] = [MeBoard class];
        
        [self.view addSubview:bee.ui.router.view];
		//[self.view addSubview:bee.ui.tabbar];
        tabbar = [[AppTabbar_iPhone alloc] init];
        [self.view addSubview:tabbar];
        
        [bee.ui.router open:self.TAB_0 animated:YES];
        
        tabbarOriginY = self.viewBound.size.height - TAB_HEIGHT + 1;
        
        [self getSignTime];
        
        //[self connectSocket];
        NSDictionary *dictSchool = [[NSUserDefaults standardUserDefaults] objectForKey:@"school"];
        if (dictSchool) {
            
            //appStore版本需要注释掉
            //[JYDCheckUpdate checkVerBySchoolCode:dictSchool[@"schoolCode"] appType:3 systemType:2 machineType:1];
        }
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        tabbar.frame = CGRectMake( 0, tabbarOriginY, self.viewBound.size.width, TAB_HEIGHT );
        //bee.ui.tabbar.frame = CGRectMake( 0, tabbarOriginY, self.viewBound.size.width, TAB_HEIGHT );
		bee.ui.router.view.frame = CGRectMake( 0, 0, self.viewBound.size.width, self.viewBound.size.height );
        for (UIView *vi in tabbar.subviews){
            if (vi.top>=40) {
                vi.frame = CGRectMake(vi.left, vi.top-50, vi.width, vi.height);
            }
        }
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [self.navigationController setNavigationBarHidden:YES animated:!self.isFristEnter];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        self.isFristEnter = NO;
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

ON_SIGNAL3( AppTabbar_iPhone, btn_tab0, signal )
{
    [tabbar selectTab0];
    //[bee.ui.tabbar selectTab0];
    [bee.ui.router open:MainBoard.TAB_0 animated:YES];
	//[bee.ui.tabbar selectHome];
	//[bee.ui.router open:AppBoard_iPhone.TAB_HOME animated:YES];
}

ON_SIGNAL3( AppTabbar_iPhone, btn_tab1, signal )
{
    [tabbar selectTab1];
    [bee.ui.router open:MainBoard.TAB_1 animated:YES];
//	[bee.ui.tabbar selectSearch];
//	[bee.ui.router open:AppBoard_iPhone.TAB_SEARCH animated:YES];
}

ON_SIGNAL3( AppTabbar_iPhone, btn_tab2, signal )
{
    [tabbar selectTab2];
    [bee.ui.router open:MainBoard.TAB_2 animated:YES];
    //	[bee.ui.tabbar selectSearch];
    //	[bee.ui.router open:AppBoard_iPhone.TAB_SEARCH animated:YES];
}

ON_SIGNAL3( AppTabbar_iPhone, btn_tab3, signal )
{
    [tabbar selectTab3];
    [bee.ui.router open:MainBoard.TAB_3 animated:YES];
    //	[bee.ui.tabbar selectSearch];
    //	[bee.ui.router open:AppBoard_iPhone.TAB_SEARCH animated:YES];
}

ON_SIGNAL3( AppTabbar_iPhone, btn_tab4, signal )
{
    [tabbar selectTab4];
    [bee.ui.router open:MainBoard.TAB_4 animated:YES];
    //	[bee.ui.tabbar selectSearch];
    //	[bee.ui.router open:AppBoard_iPhone.TAB_SEARCH animated:YES];
}

- (void)selectIndexPage:(int)index{
    switch (index) {
        case 0:
        {
            [tabbar selectTab0];
            [bee.ui.router open:MainBoard.TAB_0 animated:NO];
        }
            break;
        case 1:
        {
            [tabbar selectTab1];
            [bee.ui.router open:MainBoard.TAB_1 animated:NO];
        }
            break;
        case 2:
        {
            [tabbar selectTab2];
            [bee.ui.router open:MainBoard.TAB_2 animated:NO];
        }
            break;
        case 3:
        {
            [tabbar selectTab3];
            [bee.ui.router open:MainBoard.TAB_3 animated:NO];
        }
            break;
        case 4:
        {
            [tabbar selectTab4];
            [bee.ui.router open:MainBoard.TAB_4 animated:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)getSignTime{
    [[SignInMessage sharedInstance] insertErrorMessage:@"getSignTime" courseId:@"0"];
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"hasLogin"] boolValue]) {
        return;
    }
    if (!kSchoolUrl || [kSchoolUrl length]==0) {
        return;
    }
    NSString *strLongitude = [[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"];
    NSString *strLatitude = [[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"];
    
//    if (!strLongitude || strLongitude.length==0 || [strLongitude floatValue]<2) {
//        strLongitude = @"116.338022";
//    }
//    if (!strLatitude || strLatitude.length==0 || [strLatitude floatValue]<2) {
//        strLatitude = @"39.99942";
//    }
    
    if (!isTeacher) {
        arraySignList = kGetCache(@"todaySignList");
        if (arraySignList.count>0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd"];
            NSString *strToday = [formatter stringFromDate:[NSDate date]];
            NSString *strTaskDate = [arraySignList[0][@"signBeginTime"] substringToIndex:8];
            if ([strTaskDate isEqualToString:strToday]) {
                [[SignInMessage sharedInstance] insertErrorMessage:@"setTask" courseId:@"0"];
                [self setTask];
                
                
            }
            else {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"不是当天日期"];
                BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/common/get_stu_sign_time.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"routerInfo",[self getMacAddress]).PARAM(@"longitude",strLongitude).PARAM(@"latitude",strLatitude);
                request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
                request.tag = 9527;
            }
        }
        else {
            BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/common/get_stu_sign_time.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"routerInfo",[self getMacAddress]).PARAM(@"longitude",strLongitude).PARAM(@"latitude",strLatitude);
            request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
            request.tag = 9527;
        }
    }
}

- (void)autoCheckin:(NSMutableDictionary *)dict{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLocation];
    [[SignInMessage sharedInstance] insertErrorMessage:@"autoCheckIn" courseId:dict[@"id"]];
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    if (!carrier.mobileNetworkCode  || carrier.mobileNetworkCode.length==0 || carrier.carrierName.length==0) {
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"无手机卡!"];
        return;
    }
    
    NSString *strDevice = [BeeSystemInfo deviceModel];
    if (![strDevice isEqualToString:@"iPhone"]) {
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"不是iPhone!"];
        return;
    }
    
    NSString *strLongitude = [[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"];
    NSString *strLatitude = [[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"];
    
//    if (!strLongitude || strLongitude.length==0 || [strLongitude floatValue]<2) {
//        strLongitude = @"116.338022";
//    }
//    if (!strLatitude || strLatitude.length==0 || [strLatitude floatValue]<2) {
//        strLatitude = @"39.99942";
//    }
    
    
    if (!isTeacher) {
        dictSel = dict;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/stu_auto_sign.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"routerInfo",[self getMacAddress]).PARAM(@"longitude",strLongitude).PARAM(@"latitude",strLatitude).PARAM(@"courseSchedId",dict[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9528;
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd HH:mm"];
        for (NSMutableDictionary *dict in arraySignList) {
            if (![dict[@"finish"] boolValue]) {
                return;
                NSDate *dateBegin = [formatter dateFromString:dict[@"signBeginTime"]];
                NSDate *dateEnd = [formatter dateFromString:dict[@"signEndTime"]];
                
                NSTimeInterval secondBegin = [dateBegin timeIntervalSinceNow];
                NSTimeInterval secondEnd = [dateEnd timeIntervalSinceNow];
                
                if (secondBegin<= 0 && secondEnd>=0) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"测试注意!!!!" message:[NSString stringWithFormat:@"遇到这个，表示调用了自动签到接口，调用时间%@",[formatter stringFromDate:[NSDate date]]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [myAlertView show];
                }
            }
        }
    }
}

- (NSString *)getMacAddress{
    NSString *macIp = @"00:B0:C6:1C:FB:19";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            macIp = [dict valueForKey:@"BSSID"];
            NSArray *ips = [macIp componentsSeparatedByString:@":"];
            NSMutableString *macaddress = [[NSMutableString alloc] init];
            for (int i = 0; i < ips.count; i++) {
                NSString *str = ips[i];
                if (str.length==1) {
                    [macaddress appendFormat:@"0%@",str];
                }
                else {
                    [macaddress appendString:str];
                }
                if (i < ips.count-1) {
                    [macaddress appendString:@":"];
                }
            }
            return macaddress;
        }
    }
    return macIp;
}

- (void)setTask{
    for (NSMutableDictionary *dict in arraySignList) {
        if (![dict[@"finish"] boolValue]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd HH:mm"];
            
            NSDate *dateBegin = [formatter dateFromString:dict[@"signBeginTime"]];
            NSDate *dateEnd = [formatter dateFromString:dict[@"signEndTime"]];
            
            NSTimeInterval secondBegin = [dateBegin timeIntervalSinceNow];
            NSTimeInterval secondEnd = [dateEnd timeIntervalSinceNow];
            long long beginTime = [[NSNumber numberWithDouble:secondBegin] longLongValue];
            long long endTime = [[NSNumber numberWithDouble:secondEnd] longLongValue];
            NSLog(@" ------------%llu ------%llu",beginTime,endTime);
            
            if (secondBegin<0 && secondEnd<0) {
                [dict setObject:@YES forKey:@"finish"];
            }
            else if (secondBegin>0) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoCheckin:) object:dict];
                [self performSelector:@selector(autoCheckin:) withObject:dict afterDelay:secondBegin];
                [self performSelector:@selector(autoCheckin:) withObject:dict afterDelay:secondEnd];
                [self performSelector:@selector(autoCheckin:) withObject:dict afterDelay:secondBegin+(secondEnd-secondBegin)/2];
            }
            else {
                [self autoCheckin:dict];
                [self performSelector:@selector(autoCheckin:) withObject:dict afterDelay:secondEnd];
            }
        }
    }
    kSaveCache(arraySignList, @"todaySignList");
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        NETWORK_ERROR
        [[BeeUITipsCenter sharedInstance] dismissTips];
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"签到失败,没连接校内网!"];
        if (request.tag == 9528) {
            [[SignInMessage sharedInstance] insertErrorMessage:@"签到失败,没连接校内网!" courseId:dictSel[@"id"]];
        }
    }
    else if (request.succeed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        /*result =     (
         {
         courseId = 13;
         id = 216;
         signBeginTime = "20140807 08:00";
         signEndTime = "20140807 08:10";
         },
         {
         courseId = 12;
         id = 192;
         signBeginTime = "20140807 10:00";
         signEndTime = "20140807 10:10";
         },
         {
         courseId = 14;
         id = 235;
         signBeginTime = "20140807 13:00";
         signEndTime = "20140807 13:10";
         }
         );*/
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        arraySignList = json[@"result"];
                        kSaveCache(arraySignList, @"todaySignList");
                        //[self autoCheckin:arraySignList[0]];
                        [self setTask];
                    }
                        break;
                    case 9528:
                    {
                        
                        if ([json[@"result"][@"stuSignStatus"] boolValue]) {
                            [[SignInMessage sharedInstance] insertErrorMessage:@"签到成功!" courseId:dictSel[@"id"]];
                            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"签到成功"];
                            [dictSel setObject:@YES forKey:@"finish"];
                            kSaveCache(arraySignList, @"todaySignList");
                            
                            [self postNotification:@"checkinSuccess"];
                        }else{
                            [[SignInMessage sharedInstance] insertErrorMessage:@"接口走通，签到失败!" courseId:dictSel[@"id"]];
                            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"定位有误!"];
                        }
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                break;
            case 1:{
                switch (request.tag) {
                    case 9528:
                    {
                        [[SignInMessage sharedInstance] insertErrorMessage:json[@"ERRMSG"] courseId:dictSel[@"id"]];
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:json[@"ERRMSG"]];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            default:
                switch (request.tag) {
                    case 9528:
                    {
                        NSLog(@"dddd");
                    }
                        break;
                        
                    default:
                        break;
                }
                break;
        }
    }
}

//
//#pragma mark - socket
//- (void)connectSocket{
//    socketIO = [[SocketIO alloc] initWithDelegate:self];
//    [socketIO connectToHost:kSocketServer onPort:8868];
//}
//
//#pragma mark - socket delegate
//- (void) socketIODidConnect:(SocketIO *)socket{
//    NSLog(@"%@",socket);
//    BOOL status = [socket sendingMessage:@"hello world"];
//    if (status) {
//        NSLog(@"send success");
//    }
//    else {
//        NSLog(@"send failed");
//    }
//}
//
//- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error{
//    NSLog(@"%@",error);
//}
//
//- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet{
//    NSLog(@"didReceiveMessage >>> data: %@", packet.data);
//}
//
//- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet{
//}
//
//- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet{
//}
//
//- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet{
//}
//
//- (void) socketIO:(SocketIO *)socket onError:(NSError *)error{
//    NSLog(@"%@",error);
//}

@end