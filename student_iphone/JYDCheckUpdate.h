//
//  JYDCheckUpdate.h
//  JSmaster
//
//  Created by jyd on 16/4/12.
//  Copyright © 2016年 JYD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYDCheckUpdate : NSObject

/**
 *  检查更新接口
 *  @param schoolCode       学校ID
 *  @param appTypeParam     1领导      2老师端 3学生端
 *  @param systemTypeParam  1android  2ios
 *  @param machineTypeParam 1手机      2 pad
 */
+ (void)checkVerBySchoolCode:(NSString *)schoolCode
                     appType:(int)appTypeParam
                  systemType:(int)systemTypeParam
                 machineType:(int)machineTypeParam;
@end
