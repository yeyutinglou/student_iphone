//
//  MessageRequest.h
//  Walker
//
//  Created by he chao on 14-4-19.
//  Copyright (c) 2014年 leon. All rights reserved.
//

#import "Bee_Model.h"
#import "ChatBoard.h"
//#import "FriendBoard.h"
//#import "TeamBoard.h"

typedef enum {
	MessageTypeFriendChat = 1,
    MessageTypeTeamChat,
    MessageTypeFriendRequest,
    MessageTypeFriendAgree,
    MessageTypeAdminInviteToTeam,
    MessageTypeAdminAgreeToTeam,
    MessageTypeNewActivity,
    MessageTypeNewRoad,
    MessageTypeFirendNoVerify
} MessageType;

@interface MessageRequest : BeeModel{
    NSTimer *timer;
    BOOL isRequest;
}
AS_SINGLETON(MessageRequest)
@property (nonatomic, strong) ChatBoard *chatBoard;
//@property (nonatomic, strong) FriendBoard *friendBoard;
//@property (nonatomic, strong) TeamBoard *teamBoard;

- (void)getAllMessage;
- (void)setModel:(BOOL)isChatMode;
@end
