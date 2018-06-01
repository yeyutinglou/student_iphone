//
//  DictFloor.m
//  teacher_iphone
//
//  Created by jyd on 16/6/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "DictFloor.h"

@implementation DictFloor
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ID = dict[@"id"];
        self.name = dict[@"name"];
    }
    
    return self;
}

+(instancetype)floorWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDict:dict];
}

@end
