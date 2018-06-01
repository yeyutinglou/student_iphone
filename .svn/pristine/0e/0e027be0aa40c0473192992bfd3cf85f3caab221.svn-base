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
//  ChatDB.h
//  Walker
//
//  Created by he chao on 4/30/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "Bee_Model.h"

#pragma mark -

@interface ChatDB : BeeModel{
    sqlite3 *db;
    NSArray *arrayKey;
}
AS_SINGLETON(ChatDB)

- (void)execSql:(NSString *)sql;
- (void)insert:(NSMutableDictionary *)dictMessage;
- (void)query;
- (void)delete:(NSMutableDictionary *)dictMessage;
- (NSMutableArray *)queryFriendMessage:(NSString *)strSenderId;
- (NSMutableArray *)queryTeamMessage:(NSString *)strTeamId;

- (void)deleteTeamMessage:(NSMutableDictionary *)dictMessage;
- (void)deleteFriendMessage:(NSMutableDictionary *)dictMessage;

@end
