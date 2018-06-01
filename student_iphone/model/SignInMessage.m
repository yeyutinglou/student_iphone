//
//  SignInMessage.m
//  student_iphone
//
//  Created by jyd on 15/12/21.
//  Copyright © 2015年 he chao. All rights reserved.
//

#import "SignInMessage.h"

@implementation SignInMessage
DEF_SINGLETON(SignInMessage)

- (void)load{
    [super load];
    arrayKey = @[@"id",@"date",@"userId",@"courseId",@"message"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"errorMessage.sqlite"];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS errorMessage ( id integer PRIMARY KEY, date text NOT NULL, userId text NOT NULL, courseId text NOT NULL, message text Not NULL)"];
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

- (void)insertErrorMessage:(NSString *)message courseId:(NSString *)courseId{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd hh:mm:ss"];
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO errorMessage (date, userId, courseId, message) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",[formatter stringFromDate:[NSDate date]],kUserId,courseId,message];
    [self execSql:sqlInsert];
}

- (NSMutableArray *)queryAllErrorMessage{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM errorMessage"];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 1);
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
