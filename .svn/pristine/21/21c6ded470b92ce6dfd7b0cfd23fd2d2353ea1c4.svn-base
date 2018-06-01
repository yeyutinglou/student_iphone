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
//  MessageModel.m
//  Walker
//
//  Created by he chao on 14-4-29.
//    Copyright (c) 2014年 leon. All rights reserved.
//

#import "MessageModel.h"

#pragma mark -

@implementation MessageModel

DEF_SINGLETON(MessageModel)
//	    1;	//好友聊天
//		2;	//队伍聊天
//		3;	//用户申请加我为好友
//		4;	//用户同意加我为好友
//		5;	//管理员邀请加入队伍
//		6;	//用户同意加入队伍【暂时没有】
//		7;	//有新活动发布
//		8;  //有新步道发布
//		9;	//不需要验证的加好友信息  需要通知被添加的人]【参考字典表msgType】

#define DBNAME    @"message.sqlite"
#define TABLE_NAME @"message"

#define  ID @"id" //	字符串	消息id
#define  SENDDATE @"sendDate" //	字符串	发送时间
#define  MSGTYPE @"msgType" //	字符串	消息类型[
#define  CONTENTTYPE @"contentType" //	字符串	聊天内容类型
#define  CONTENT @"content" //	字符串	系统生成信息
#define  SENDUSERID @"sendUserId" //	字符串	发送人id
#define  SENDUSERNAME @"sendUserName" //	字符串	发送人名称
#define  SENDUSERPIC @"sendUserPic" //	字符串	发送人头像
#define  USERID @"userId" // 当前登录用户ID
#define  MARKING @"marking"	// 标识是用户发的还是好友发的0：好友；1：用户
#define  GROUPID @"groupId"	// 字符串	队伍id
#define  GROUPNAME @"groupName"	// 字符串	队伍名称
#define  GROUPPICURL @"groupPicUrl"	// 字符串	队伍头像
#define  ISISSUEGROUP @"isIssueGroup"	// 字符串	是否认证队伍(<#args#>)

- (void)load{
    [super load];
    arrayKey = @[@"id",@"sendDate",@"msgType",@"contentType",@"content",@"sendUserId",@"sendUserName",@"sendUserPic",@"userId",@"marking",@"groupId",@"groupName",@"groupPicUrl"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ INTEGER, %@ INTEGER, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT)",TABLE_NAME,ID,SENDDATE,MSGTYPE,CONTENTTYPE,CONTENT,SENDUSERID,SENDUSERNAME,SENDUSERPIC,USERID,MARKING,GROUPID,GROUPNAME,GROUPPICURL,ISISSUEGROUP];//[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT)",TABLE_NAME,MESSAGEID,SENDDATE];//@"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
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

- (void)insert:(NSMutableDictionary *)dictMessage{
    NSString *strReceiveId = kUserInfo[@"id"];
    if ([dictMessage valueForKey:@"receiveId"]) {
        strReceiveId = dictMessage[@"receiveId"];
    }
    //NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@')",TABLE_NAME,dictMessage[@"id"]];
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",TABLE_NAME,dictMessage[@"id"],dictMessage[@"sendDate"],dictMessage[@"msgType"],dictMessage[@"contentType"],dictMessage[@"content"],dictMessage[@"sendUserId"],dictMessage[@"sendUserName"],dictMessage[@"sendUserPic"],strReceiveId,@"1",dictMessage[@"groupId"],dictMessage[@"groupName"],dictMessage[@"groupPic"],@""];
    [self execSql:sqlInsert];
}

- (void)query{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_NAME];//@"SELECT * FROM PERSONINFO";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            NSLog(@"%@",nsNameStr);
//            int age = sqlite3_column_int(statement, 2);
//            
//            char *address = (char*)sqlite3_column_text(statement, 3);
//            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
//            
//            NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
        }
    }
    sqlite3_close(db);
}

- (void)delete:(NSMutableDictionary *)dictMessage{
}

- (NSMutableArray *)queryFriendMessage:(NSString *)strSenderId{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ( %@ = %@ AND %@ = %@ AND %@ = %@) OR ( %@ = %@ AND %@ = %@ AND %@ = %@) ORDER BY %@",TABLE_NAME,SENDUSERID,strSenderId,USERID,kUserInfo[@"id"],MSGTYPE,@"1",SENDUSERID,kUserInfo[@"id"],USERID,strSenderId,MSGTYPE,@"1",SENDDATE];
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

- (NSMutableArray *)queryTeamMessage:(NSString *)strTeamId{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ( %@ = %@ AND %@ = %@) ORDER BY %@",TABLE_NAME,GROUPID,strTeamId,MSGTYPE,@"2",SENDDATE];
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

@end
