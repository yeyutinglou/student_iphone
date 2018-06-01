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
//  MessageModel.h
//  Walker
//
//  Created by he chao on 14-4-29.
//    Copyright (c) 2014年 leon. All rights reserved.
//

#import "Bee_Model.h"

#pragma mark -

@interface MessageModel : BeeModel{
    sqlite3 *db;
    NSArray *arrayKey;
}
AS_SINGLETON(MessageModel)

- (void)execSql:(NSString *)sql;
- (void)insert:(NSMutableDictionary *)dictMessage;
- (void)query;
- (void)delete:(NSMutableDictionary *)dictMessage;
- (NSMutableArray *)queryFriendMessage:(NSString *)strSenderId;
- (NSMutableArray *)queryTeamMessage:(NSString *)strTeamId;

@end
