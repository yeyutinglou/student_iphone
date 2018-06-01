//
//  SignInMessage.h
//  student_iphone
//
//  Created by jyd on 15/12/21.
//  Copyright © 2015年 he chao. All rights reserved.
//

#import "Bee_Model.h"

@interface SignInMessage : BeeModel{
    sqlite3 *db;
    NSArray *arrayKey;
    
}
AS_SINGLETON(SignInMessage)

- (void)execSql:(NSString *)sql;
- (void)insertErrorMessage:(NSString *)message courseId:(NSString *)courseId;
- (NSMutableArray *)queryAllErrorMessage;

@end
