//
//  SingalLetonButton.m
//  teacher_iphone
//
//  Created by jyd on 16/6/16.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "SingalLetonButton.h"

@implementation SingalLetonButton

+(instancetype)shareInstance
{
    static SingalLetonButton *instance = nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    
    return instance;
}

/**
 * 单例对象
 */
static SingalLetonButton *_SingalLetonButton;

/**
 *  在IOS中，所有对象的内存空间的分配，最终都会调用allocWithZone方法
 *  如果需要做单例，需要重写此方法
 *  GCD提供了一个方法，专门用来创建单例的
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _SingalLetonButton = [super allocWithZone:zone];
    });
    
    return _SingalLetonButton;
}

+ (instancetype)shareSingalLetonButton
{
    
    return [[self alloc] init];
}


@end
