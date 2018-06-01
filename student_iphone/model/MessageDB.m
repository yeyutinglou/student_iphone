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
//  MessageDB.m
//  Walker
//
//  Created by he chao on 4/30/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "MessageDB.h"

#pragma mark -

@implementation MessageDB
DEF_SINGLETON(MessageDB)

#define DBNAME    @"message.sqlite"
#define TABLE_NAME @"message"

#define ID @"id"
#define FRIENDID @"friendId"
#define SENDID @"sendId"
#define SENDNAME @"sendName"
#define SENDPIC @"sendPic"
#define UNREADCOUNT @"unReadCount"
#define NEWMESSAGE @"newMessage"
#define SENDDATE @"sendDate"
#define USERID @"userId"
#define MSGTYPE @"msgType"
#define MSGCONTENTTYPE @"msgContentType"
#define FRIENDNAME @"friendName"

- (void)load{
    [super load];
    arrayKey = @[@"id",@"sendId",@"sendName",@"sendPic",@"unReadCount",@"newMessage",@"sendDate",@"userId",@"friendId",@"msgContentType",@"friendName",@"msgType"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER)",TABLE_NAME,ID,SENDID,SENDNAME,SENDPIC,UNREADCOUNT,NEWMESSAGE,SENDDATE,USERID,FRIENDID,MSGCONTENTTYPE,FRIENDNAME,MSGTYPE];
    [self execSql:sqlCreateTable];
}

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
}

- (NSMutableDictionary *)hasMessage:(NSMutableDictionary *)dictMessage{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ( %@ = %@ OR %@ = %@ OR %@ = %@ OR %@ = %@ OR %@ = %@) AND ( %@ = %@ ) AND (%@ = %@)",TABLE_NAME,MSGTYPE,dictMessage[@"msgType"],MSGTYPE,@"-2",MSGTYPE,@"-3",MSGTYPE,@"2",MSGTYPE,@"3",USERID,kUserInfo[@"id"],FRIENDID,dictMessage[@"friendId"]];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            sqlite3_close(db);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < arrayKey.count; i++) {
                char *name = (char*)sqlite3_column_text(statement, i);
                NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
                [dict setObject:nsNameStr forKey:arrayKey[i]];
            }
            sqlite3_close(db);
            return dict;
        }
    }
    sqlite3_close(db);
    return nil;
}

- (void)insert:(NSMutableDictionary *)dictMessage{
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO %@ VALUES ('%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",TABLE_NAME,dictMessage[@"id"],dictMessage[@"sendId"],dictMessage[@"sendName"],dictMessage[@"sendPic"],dictMessage[@"unReadCount"],dictMessage[@"newMessage"],dictMessage[@"sendDate"],kUserInfo[@"id"],dictMessage[@"friendId"],dictMessage[@"contentType"],dictMessage[@"friendName"],dictMessage[@"msgType"]];
    [self execSql:sqlInsert];
}

- (void)update:(NSMutableDictionary *)dictMessage{
    int type = [dictMessage[@"msgType"] intValue];
    NSString *sqlUpdate;
    switch (type) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 9:
        {
            sqlUpdate = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@',%@ = '%@', %@ = '%@',%@ = '%@',%@ = '%@' WHERE %@ = %@ AND %@ = %@",TABLE_NAME,MSGTYPE,dictMessage[@"msgType"],UNREADCOUNT,dictMessage[@"unReadCount"],NEWMESSAGE,dictMessage[@"newMessage"],SENDDATE,dictMessage[@"sendMessage"],SENDID,dictMessage[@"sendId"],SENDNAME,dictMessage[@"sendName"],SENDPIC,dictMessage[@"sendPic"],SENDDATE,dictMessage[@"sendDate"],MSGCONTENTTYPE,dictMessage[@"contentType"],FRIENDNAME,dictMessage[@"friendName"],FRIENDID,dictMessage[@"friendId"],USERID,kUserInfo[@"id"]];
        }
            break;
        case 5:
            
        default:
            break;
    }
    
    [self execSql:sqlUpdate];
}


- (void)deleteFriendMessage:(NSMutableDictionary *)dictMessage{
    NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@ AND %@ = %@",TABLE_NAME,FRIENDID,dictMessage[@"friendId"],USERID,kUserInfo[@"id"]];
    [self execSql:sqlDelete];
}


- (NSMutableArray *)queryFriendMessage{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ( %@ = %@ OR %@ = %@ OR %@ = %@ OR %@ = %@ OR %@ = %@) AND ( %@ = %@ ) ORDER BY %@ DESC",TABLE_NAME,MSGTYPE,@"1",MSGTYPE,@"2",MSGTYPE,@"3",MSGTYPE,@"4",MSGTYPE,@"-2",USERID,kUserInfo[@"id"],SENDDATE];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < arrayKey.count; i++) {
                char *name = (char*)sqlite3_column_text(statement, i);
                NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
                [dict setObject:nsNameStr forKey:arrayKey[i]];
            }
            NSLog(@"%@",dict);
            [array addObject:dict];
        }
    }
    sqlite3_close(db);
    return array;
}

- (void)updateFriendCountClear:(NSString *)strFriendId{
    NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE %@ SET %@=0 WHERE %@ = %@ AND %@ = %@ AND (%@ = %@ OR %@ = %@ OR %@ = %@ OR %@ = %@)",TABLE_NAME,UNREADCOUNT,FRIENDID,strFriendId,USERID,kUserInfo[@"id"],MSGTYPE,@"1",MSGTYPE,@"3",MSGTYPE,@"4",MSGTYPE,@"2"];
    [self execSql:sqlUpdate];
}

- (void)acceptFriendRequest:(NSString *)strFriendId{
    NSString *strNow = [self getCurrentTime];
    
    NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE %@ SET %@=0, %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = %@ AND %@ = %@ AND (%@ = %@ OR %@ = %@)",TABLE_NAME,UNREADCOUNT,NEWMESSAGE,@"我们成为好友了，开始对话吧!",MSGTYPE,@"1",SENDDATE,strNow,FRIENDID,strFriendId,USERID,kUserInfo[@"id"],MSGTYPE,@"2",MSGTYPE,@"-2"];
    [self execSql:sqlUpdate];
}

//msgType -2 忽略
//msgType -1 接受
- (void)ignoreFriendRequest:(NSString *)strFriendId{
    NSString *strNow = [self getCurrentTime];
    
    NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE %@ SET %@=0, %@ = '%@', %@ = '%@' WHERE %@ = %@ AND %@ = %@ AND %@ = %@",TABLE_NAME,UNREADCOUNT,MSGTYPE,@"-2",SENDDATE,strNow,FRIENDID,strFriendId,USERID,kUserInfo[@"id"],MSGTYPE,@"2"];
    [self execSql:sqlUpdate];
}

- (NSString *)getCurrentTime{
    NSString *format = @"yyyyMMdd HH:mm:ss";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:[NSDate date]];
}
@end
