//
//  DictClassroom.m
//  teacher_iphone
//
//  Created by jyd on 16/6/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "DictClassroom.h"

@implementation DictClassroom
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.name = dict[@"name"];
    }
    
    return self;
}

+(instancetype)classWithDict:(NSDictionary*)dict{
 return [[self alloc] initWithDict:dict];
}

@end
