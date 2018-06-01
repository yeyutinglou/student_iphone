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
//  MessageDB.h
//  Walker
//
//  Created by he chao on 4/30/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "Bee_Model.h"

#pragma mark -

@interface MessageDB : BeeModel{
    sqlite3 *db;
    NSArray *arrayKey;
}
AS_SINGLETON(MessageDB)

- (void)execSql:(NSString *)sql;
- (NSMutableDictionary *)hasMessage:(NSMutableDictionary *)dictMessage;
- (void)insert:(NSMutableDictionary *)dictMessage;
- (void)update:(NSMutableDictionary *)dictMessage;
//- (void)query;
- (void)delete:(NSMutableDictionary *)dictMessage;
- (NSMutableArray *)queryFriendMessage;
- (NSMutableArray *)queryTeamMessage;

- (void)updateFriendCountClear:(NSString *)strFriendId;
- (void)acceptFriendRequest:(NSString *)strFriendId;
- (void)ignoreFriendRequest:(NSString *)strFriendId;
- (void)deleteFriendMessage:(NSMutableDictionary *)dictMessage;



@end
