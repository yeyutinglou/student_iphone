//
//  SocketData.m
//  teacher_ipad
//
//  Created by he chao on 1/9/15.
//  Copyright (c) 2015 leon. All rights reserved.
//

#import "SocketData.h"
#import "AsyncSocket.h"
#import "AppDelegate.h"
#import "OnListenBoard.h"
#import "TeacherAskBoard.h"
#import "OnlineTestBoard.h"
#import "QuestionBoard.h"
@interface SocketData()<AsyncSocketDelegate>{
    AsyncSocket *socket;
    OnListenBoard *onListen;
    TeacherAskBoard *teacherAsk;
    OnlineTestBoard *onlineTest;
    QuestionBoard *question;
    NSMutableData* socketData;
    BOOL isReadPicData;
}

@end

@implementation SocketData
DEF_SINGLETON(SocketData)

#define kStrEnd @"abcdefghijklmnopqrstuvwxyz\n"//@" \r\n"

- (void)connectSocket:(NSString *)strHost port:(NSString *)strPort
{
//    if (!socket) {
//        socket = [[AsyncSocket alloc] initWithDelegate:self];
//    }
//    if ([socket isConnected]) {
//        [socket disconnect];
//    }
//    strGid = @"0010";
//    [socket connectToHost:@"210.14.140.60" onPort:8868 error:nil];
//    [socket readDataWithTimeout:-1 tag:-1];
}

- (void)connect
{
    if (!socket)
    {
        socket = [[AsyncSocket alloc] initWithDelegate:self];
    }
   
    //add by zhaojian 2015-01-15
    [self getSocketInfoBeforeConnect];
    
//    _strGid = [NSString stringWithFormat:@"%@",_dictSocket[@"courseSchedId"]];
//    
//    if ([socket isConnected])
//    {
//        // 在连接前先进行手动断开
//        socket.userData = SocketOfflineByUser;
//        [self.connectTimer invalidate];
//        self.connectTimer = nil;
//        [socket disconnect];
//    }
//    
//    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
//    socket.userData = SocketOfflineByServer;
//    [socket connectToHost:_dictSocket[@"host"] onPort:[_dictSocket[@"port"] intValue] error:nil];
//    
//    [socket readDataWithTimeout:-1 tag:-1];
    if ([socket isConnected]) {
        // 在连接前先进行手动断开
        socket.userData = SocketOfflineByUser;
        [self.connectTimer invalidate];
        self.connectTimer = nil;
        [socket disconnect];
        
        //[socket disconnect];
        //[self performSelector:@selector(connect) withObject:nil afterDelay:1];
        //[socket readDataWithTimeout:-1 tag:-1];
        //return;
    }
    
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    JYDLog(@"did connect to host");
    NSDictionary *dict = @{@"FLAG":@"0",@"GID":_strGid,@"SUBJECT":kUserId,@"INFO":@""};
    NSString *strContent = [dict JSONString];
    NSData *dt = [[NSString stringWithFormat:@"%@%@",strContent,kStrEnd] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    JYDLog(@"didConnectToHost*******%@", [NSString stringWithFormat:@"%@%@",strContent,kStrEnd]);
                  
    [socket writeData:dt withTimeout:-1 tag:1000];
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(keeplive) object:nil];
    //[self performSelector:@selector(keeplive) withObject:nil afterDelay:60];
    
    // 每隔30s像服务器发送心跳包
    if (self.connectTimer == nil) {
        self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(keeplive) userInfo:nil repeats:YES];// 在keeplive方法中进行长连接需要向服务器发送的讯息
        
        [self.connectTimer fire];
    }
}

- (void)keeplive{
    //[socket writeData:[[NSString stringWithFormat:@"%@",@"ios student_iphone keep socket alive\r\n"] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:MAXFLOAT tag:1080];
    
    [socket writeData:[[NSString stringWithFormat:@"iOS ### student_iphone keep socket alive, host:%@, classRoomName:%@, userID:%@, GID:%@.%@", _dictSocket[@"host"] ,_dictSocket[@"classRoomName"], _dictSocket[@"id"],_strGid, @"\r\n"] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:MAXFLOAT tag:1080];
    
    //[self performSelector:@selector(keeplive) withObject:nil afterDelay:60];
}


- (void)sendSocketData:(NSMutableDictionary *)dict{
    if (![socket isConnected]) {
        [self connectSocket:@"" port:@""];
    }
    [dict setObject:_strGid forKey:@"GID"];
    NSString *strContent = [dict JSONString];
    NSData *dt = [[NSString stringWithFormat:@"%@%@",strContent,kStrEnd] dataUsingEncoding:NSUTF8StringEncoding];
    [socket writeData:dt withTimeout:-1 tag:1000];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    JYDLog(@"student_iphone did read data\r\n");
    NSString* message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([message rangeOfString:@"bitmapBase64"].location != NSNotFound)
    {
        isReadPicData = YES;
        if ([message hasSuffix:kStrEnd])
        {
            message = [message stringByReplacingOccurrencesOfString:kStrEnd withString:@""];
            [self handleReceiveMessage:message];
            isReadPicData = NO;
        }
        else
        {
            socketData = [[NSMutableData alloc] initWithData:data];
        }
    }
    else
    {
        if (isReadPicData)
        {
            if ([message hasSuffix:kStrEnd])
            {
                message = [message stringByReplacingOccurrencesOfString:kStrEnd withString:@""];
                NSString* Premessage = [[NSString alloc] initWithData:socketData encoding:NSUTF8StringEncoding];
                [self handleReceiveMessage:[NSString stringWithFormat:@"%@%@",Premessage,message]];
                isReadPicData = NO;
            }
            else
            {
                [socketData appendData:data];
            }
        }
        else
        {
            message = [message stringByReplacingOccurrencesOfString:kStrEnd withString:@""];
            [self handleReceiveMessage:message];
        }
    }
    
    [socket readDataWithTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    JYDLog(@"zzz");
    [socket readDataWithTimeout:-1 tag:1];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    JYDLog(@"socket did disconnect");
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connect) object:nil];
    //[self connect];
    //[self performSelector:@selector(connect) withObject:nil afterDelay:3];
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connect) object:nil];
        [self performSelector:@selector(connect) withObject:nil afterDelay:3];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
}

- (void)handleReceiveMessage:(NSString *)strMessage{
    
    JYDLog(@"*******%@", strMessage);
    
    NSMutableDictionary *dict = [strMessage mutableObjectFromJSONString];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    JYDLog(@"########%@", dict);
    
    switch ([dict[@"FLAG"] intValue]) {
        case 0:
        {
            //add by zhaojian 2015--07-29 老师点击上课的时候、学生的GID更新为老师GID
            if (dict[@"GID"] != nil && ![dict[@"GID"]  isEqual: @"0"]) {
                _strGid = dict[@"GID"];
                _dictSocket[@"courseSchedId"] = _strGid;
                JYDLog(@"-----------------------");
            }
        }
            break;
        case 1:
        {
//            if (!delegate.isWhiteBoardMode) {
//                delegate.isWhiteBoardMode = YES;
//                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                OnListenBoard* controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OnListenBoard"];
//                if ([dict[@"INFO"] isKindOfClass:[NSString class]]&&[dict[@"INFO"] isEqualToString:@""]) {
//                    controller.subDic = dict[@"SUBJECT"];
//                    [delegate.viCtrl.navigationController pushViewController:controller animated:YES];
//                }
//            }else{
//                NSMutableDictionary* infoDic = dict[@"INFO"];
//                if ([infoDic isKindOfClass:[NSString class]]){
//                    infoDic = [(NSString *)infoDic mutableObjectFromJSONString];
//                }
//                [self postNotification:@"whiteBoard" withObject:infoDic];
//            }
//            break;
            
        }
            break;
        case 2:
        {
            if (!delegate.isScreenShots)
            {
                if (!delegate.isOnClassMode)
                {
                    delegate.isOnClassMode = YES;
                    
        
                    onListen = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OnListenBoard"];

                    //comment by zhaojian 2015-12-28
                    //onListen.dictMessage = dict[@"SUBJECT"];
                    
                    //add by zhaojian 2015-12-28
                    NSMutableDictionary *dict2 = dict[@"SUBJECT"];
                    if ([dict2 isKindOfClass:[NSString class]]) {
                        dict2 = [(NSString *)dict2 mutableObjectFromJSONString];
                    }
                    if (dict[@"INFO"]) {
                        [dict2 setObject:dict[@"INFO"] forKeyedSubscript:@"INFO"];
                    }
                    onListen.dictMessage = dict2;
                    
                    NSArray *controllers = [MainBoard sharedInstance].navigationController.viewControllers;
                    for (UIViewController *c in controllers)
                    {
                        if ([c isKindOfClass:[OnListenBoard class]])
                        {
                            [[MainBoard sharedInstance].navigationController popToViewController:c animated:YES];
                            return;
                        }
                    }

                    [[MainBoard sharedInstance].navigationController pushViewController:onListen animated:YES];
                   
                }else
                {
                    //comment by zhaojian 2015-12-28
                    //[self postNotification:@"resource" withObject:dict[@"SUBJECT"]];
                    
                    //add by zhaojian 2015-12-28
                    NSMutableDictionary *dict2 = dict[@"SUBJECT"];
                    if ([dict2 isKindOfClass:[NSString class]]) {
                        dict2 = [(NSString *)dict2 mutableObjectFromJSONString];
                    }
                    if (dict[@"INFO"]) {
                        [dict2 setObject:dict[@"INFO"] forKeyedSubscript:@"INFO"];
                    }
                    [self postNotification:@"resource" withObject:dict2];
                }

            }
        }
            break;
        case 3:
        {
            NSString *newID = [[NSUserDefaults standardUserDefaults] objectForKey:@"examRecordId"];
            if (!delegate.isTestMode && ![newID isEqualToString:dict[@"SUBJECT"][@"examRecordId"] ]) {
//                if (self.isTestResultShow) {
//                    //self.isTestResultShow = NO;
//                    return;
//                }
                delegate.isTestMode = YES;
               // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
               // OnlineTestBoard *controller = [storyboard instantiateViewControllerWithIdentifier:@"OnlineTestBoard"];
            
                    onlineTest = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OnlineTestBoard"];
        
                NSMutableDictionary *dict2 = dict[@"SUBJECT"];
                if ([dict2 isKindOfClass:[NSString class]]) {
                    dict2 = [(NSString *)dict2 mutableObjectFromJSONString];
                }
                onlineTest.dictExam = dict2;
                NSArray *controllers = [MainBoard sharedInstance].navigationController.viewControllers;
//                for (UIViewController *c in controllers){
//                    if ([c isKindOfClass:[OnlineTestBoard class]]) {
//                        [[MainBoard sharedInstance].navigationController popToViewController:c animated:YES];
//                        return;
//                    }
//                }
                [[MainBoard sharedInstance].navigationController pushViewController:onlineTest animated:YES];
            }
            else {
                NSMutableDictionary *dict2 = dict[@"SUBJECT"];
                if ([dict2 isKindOfClass:[NSString class]]) {
                    dict2 = [(NSString *)dict2 mutableObjectFromJSONString];
                }
                [self postNotification:@"exam" withObject:dict2];
            }
        }
            break;
        case 4:
        {
            if (!delegate.isQuestionMode) {
                delegate.isQuestionMode = YES;
                //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                //TeacherAskBoard *controller = [storyboard instantiateViewControllerWithIdentifier:@"TeacherAskBoard"];
                if (!teacherAsk) {
                    teacherAsk = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TeacherAskBoard"];
                }
                NSMutableDictionary *dict2 = dict[@"SUBJECT"];
                if ([dict2 isKindOfClass:[NSString class]]) {
                    dict2 = [(NSString *)dict2 mutableObjectFromJSONString];
                }
                teacherAsk.dictQuestion = dict2;
                NSArray *controllers = [MainBoard sharedInstance].navigationController.viewControllers;
                for (UIViewController *c in controllers){
                    if ([c isKindOfClass:[TeacherAskBoard class]]) {
                        [[MainBoard sharedInstance].navigationController popToViewController:c animated:YES];
                        return;
                    }
                }

                [[MainBoard sharedInstance].navigationController pushViewController: teacherAsk animated:YES];
            }
            else {
                NSMutableDictionary *dict2 = dict[@"SUBJECT"];
                if ([dict2 isKindOfClass:[NSString class]]) {
                    dict2 = [(NSString *)dict2 mutableObjectFromJSONString];
                }
                [self postNotification:@"question" withObject:dict2];
            }
        }
            break;
        case 8:
        {
            if (!delegate.isQuestion && ![dict[@"SUBJECT"][@"questionCode"]  isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"questionCode"]]) {
                delegate.isQuestion = YES;
                //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                //TeacherAskBoard *controller = [storyboard instantiateViewControllerWithIdentifier:@"TeacherAskBoard"];
                question = [[QuestionBoard alloc] init];
                NSMutableDictionary *dict2 = dict[@"SUBJECT"];
                if ([dict2 isKindOfClass:[NSString class]]) {
                    dict2 = [(NSString *)dict2 mutableObjectFromJSONString];
                }
                question.dicQuestion = dict2;
//                NSArray *controllers = [MainBoard sharedInstance].navigationController.viewControllers;
//                for (UIViewController *c in controllers){
//                    if ([c isKindOfClass:[QuestionBoard class]]) {
//                        [[MainBoard sharedInstance].navigationController popToViewController:c animated:YES];
//                        return;
//                    }
//                }
                
                [[MainBoard sharedInstance].navigationController pushViewController: question animated:YES];
            }
            else {
                NSMutableDictionary *dict2 = dict[@"SUBJECT"];
                if ([dict2 isKindOfClass:[NSString class]]) {
                    dict2 = [(NSString *)dict2 mutableObjectFromJSONString];
                }
                [self postNotification:@"PPTquestion" withObject:dict2];
            }
        }
            break;
            
        //2016-05-11 接收老师发送过来的GID 讲GID 更新学生自己的GID
        case 9:
        {
            
            if (dict[@"GID"] != nil && ![dict[@"GID"]  isEqual: @"0"])
            {
                _strGid = dict[@"GID"];
                _dictSocket[@"courseSchedId"] = _strGid;
                JYDLog(@"-----------------------");
            }
        }
            break;

        case 99:
        {
            [[MainBoard sharedInstance].navigationController popToViewController:[MainBoard sharedInstance] animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//add by zhaojian 2016-01-15
- (void)getSocketInfoBeforeConnect
{
    JYDLog(@"getSocketInfoBeforeConnect---");
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/service/get_socket_info.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    
    request.tag = 9528;
}

//add by zhaojian 2016-01-15
- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        //NETWORK_ERROR
        [[BeeUITipsCenter sharedInstance] dismissTips];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connect) object:nil];
        [self performSelector:@selector(connect) withObject:nil afterDelay:3];
    }
    else if (request.succeed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9528:
                    {
                        //[SocketData sharedInstance].dictSocket = json[@"result"];
                        //[[SocketData sharedInstance] connect];
                        
                        self.dictSocket = json[@"result"];
                        
                        JYDLog(@"#######get_socket_info.action: %@", self.dictSocket);
                        
                        NSString *tmpGID = [NSString stringWithFormat:@"%@",_dictSocket[@"courseSchedId"]];
                        
                        if (tmpGID != nil && ![tmpGID isEqualToString: @"0"])
                        {
                            _strGid = tmpGID;
                        }
                        
                        _strGid = [NSString stringWithFormat:@"%@",_dictSocket[@"courseSchedId"]];
                        
                        if ([socket isConnected]) {
                            // 在连接前先进行手动断开
                            socket.userData = SocketOfflineByUser;
                            [self.connectTimer invalidate];
                            self.connectTimer = nil;
                            [socket disconnect];
                        }
                        
                        // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
                        socket.userData = SocketOfflineByServer;
                        [socket connectToHost:_dictSocket[@"host"] onPort:[_dictSocket[@"port"] intValue] error:nil];
                        [socket readDataWithTimeout:-1 tag:-1];
                        
                    }
                        break;
                }
                break;
            }
        }
    }
}

@end
