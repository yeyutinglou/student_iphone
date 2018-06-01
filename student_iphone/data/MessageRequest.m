//
//  MessageRequest.m
//  Walker
//
//  Created by he chao on 14-4-19.
//  Copyright (c) 2014年 leon. All rights reserved.
//

#import "MessageRequest.h"
#import "MessageStatusBar.h"


@implementation MessageRequest
DEF_SINGLETON(MessageRequest)

- (void)load{
    [super load];
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"hasLogin"] boolValue]) {
        return;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:kMessageTime target:self selector:@selector(checkMessage) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)setModel:(BOOL)isChatMode{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"hasLogin"] boolValue]) {
        return;
    }
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:isChatMode?kGetChatTime:kMessageTime target:self selector:@selector(checkMessage) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)checkMessage{
    if (!isRequest) {
        [self getAllMessage];
    }
}

- (void)getAllMessage{
    //return;
    NSLog(@"%@",kUserInfo[@"sessionId"]);
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/common/get_all_msg.action"]];
    if (kUserInfo[@"id"]) {
        request.PARAM(@"id",kUserInfo[@"id"]);
    }
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
    isRequest = YES;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        //[[BeeUITipsCenter sharedInstance] dismissTips];
        //NETWORK_ERROR
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
        isRequest = NO;
    }
    else if (request.succeed)
    {
        isRequest = NO;
        //[[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                
                //[self playSound];
                [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2];
                [self saveChat:json[@"result"]];
                [self saveMessage:json[@"result"]];
                
//                NSMutableArray *arrayMessage = [[NSMutableArray alloc] init];
//                id value = [[BeeFileCache sharedInstance] objectForKey:@"message"];
//                if (value) {
//                    //NSLog(@"%@",[(NSData *)value objectFromJSONData]);
//                    [arrayMessage addObjectsFromArray:[(NSData *)value objectFromJSONData]];
//                }
//                
//                [arrayMessage addObjectsFromArray:json[@"result"]];
                if (self.chatBoard) {
                    [self.chatBoard performSelector:@selector(loadCache)];
                }
            }
                break;
            case 2:
            {
                
            }
                break;
            default:
            {
                //[[BeeUITipsCenter sharedInstance] presentFailureTips:json[@"ERRMSG"]];
            }
                break;
        }
    }
}

- (void)hideMessage{
    [[MessageStatusBar sharedInstance] hide];
}

- (void)playSound{
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    SystemSoundID ID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &ID);
    AudioServicesPlaySystemSound(ID);
    //AudioServicesDisposeSystemSoundID(ID);
}

- (void)saveChat:(id)json{
    for (int i = 0; i < [json count]; i++) {
        [[ChatDB sharedInstance] insert:json[i]];
    }
}

/*1;	//好友聊天
 2;	//用户申请加我为好友
 3;	//用户同意加我为好友
 4;	//不需要验证的加好友信息  需要通知被添加的人;申请加某人为好友，该用户同意后，会生成一条提示信息提示发起申请的人。
 5;	//我所关注的所有公众号的新动态数量。
 6;	//新通知消息。
*/
- (void)saveMessage:(id)json{
    for (int i = [json count]-1; i >= 0; i--) {
        NSMutableDictionary *dictMessage = json[i];
        int msgType = [dictMessage[@"msgType"] integerValue];
        switch (msgType) {
            case 1:
            case 3:
            case 4:
                //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"friendBadge"];
                break;
            case 2:
                break;
            case 5:
            {
                [[NSUserDefaults standardUserDefaults] setObject:dictMessage[@"content"] forKey:@"publicBadgeNum"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"publicBadge"];
            }
                break;
            case 6:
            {
                [[NSUserDefaults standardUserDefaults] setObject:dictMessage[@"content"] forKey:@"messageBadgeNum"];
                //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"messageBadge"];
                [[NSUserDefaults standardUserDefaults] setBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"notifitionSwitch"] forKey:@"messageBadge"];
            }
                break;
                
            default:
                break;
        }
        
        
        if (msgType !=5 && msgType!=6) {
            //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"friendBadge"];
            [[NSUserDefaults standardUserDefaults] setBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"messageSwitch"] forKey:@"friendBadge"];
            [[MessageStatusBar sharedInstance] showStatusMessage:@"您有新消息"];
            
            NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
            [dictTemp setObject:dictMessage[@"id"] forKey:@"id"];
            [dictTemp setObject:dictMessage[@"sendUserId"] forKey:@"sendId"];
            [dictTemp setObject:dictMessage[@"sendUserName"] forKey:@"sendName"];
            [dictTemp setObject:dictMessage[@"sendUserPic"] forKey:@"sendPic"];
            [dictTemp setObject:@"0" forKey:@"unReadCount"];
            [dictTemp setObject:dictMessage[@"content"] forKey:@"newMessage"];
            [dictTemp setObject:dictMessage[@"sendDate"] forKey:@"sendDate"];
            [dictTemp setObject:dictMessage[@"msgType"] forKey:@"msgType"];
            [dictTemp setObject:dictMessage[@"contentType"] forKey:@"contentType"];
            [dictTemp setObject:dictMessage[@"sendUserId"] forKey:@"friendId"];
            [dictTemp setObject:dictMessage[@"sendUserName"] forKey:@"friendName"];
            
            
            NSMutableDictionary *dictOld = [[MessageDB sharedInstance] hasMessage:dictTemp];
            if (dictOld) {
                if (!self.chatBoard) {
                    int unread = [dictOld[@"unReadCount"] intValue]+1;
                    [dictTemp setObject:[NSString stringWithFormat:@"%d",unread] forKey:@"unReadCount"];
                }
                
                [[MessageDB sharedInstance] update:dictTemp];
            }
            else {
                if (!self.chatBoard) {
                    [dictTemp setObject:@"1" forKey:@"unReadCount"];
                }
                [[MessageDB sharedInstance] insert:dictTemp];
            }
        }

    }

//    if (self.friendBoard) {
//        [self.friendBoard refreshMessage];
//    }
//    if (self.teamBoard) {
//        [self.teamBoard refreshMessage];
//    }
    
    [self postNotification:kBadge];
}

@end
