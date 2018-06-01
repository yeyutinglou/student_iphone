//
//  NSObject+Extension.m
//  Oxyzen
//
//  Created by he chao on 14-10-1.
//  Copyright (c) 2014年 liucheng. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject(Extension)

-(void)setUserInfo:(NSMutableDictionary *)newUserInfo{
    objc_setAssociatedObject(self, @"userInfo", newUserInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userInfo{
    return objc_getAssociatedObject(self, @"userInfo");
}

@end
