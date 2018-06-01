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
//  DataUtils.h
//  Walker
//
//  Created by he chao on 14-4-20.
//    Copyright (c) 2014年 leon. All rights reserved.
//

#import "Bee_Model.h"

#pragma mark -

@interface DataUtils : BeeModel{
    NSString *strActivityId;  //此id，判断是否已经参加活动
}
AS_SINGLETON(DataUtils)


+ (NSString *)getTodayDate;
+ (NSString *)formatDate:(NSString *)date;

+ (BOOL)isValidPhone:(NSString *)strPhone;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (NSString *)getMessageTime:(NSString *)strTime;
+ (NSString *)getChatTime:(NSString *)strTime;
+ (NSString *)getFormatTime:(NSString *)strTime;

- (void)setJoinActivity:(NSString *)strId;
- (NSString *)getJoinId;

- (NSMutableArray *)getMessageArray:(NSString *)strMessage;
- (CGFloat)getContentSize:(NSMutableArray *)arrayContent width:(CGFloat)width;


@end
