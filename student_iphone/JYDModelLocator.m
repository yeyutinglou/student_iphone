//
//  JYDModelLocator.m
//  student_iphone
//
//  Created by jyd on 16/5/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "JYDModelLocator.h"

@implementation JYDModelLocator

+(instancetype)shareInstance
{
    static JYDModelLocator *instance = nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    
    return instance;
}

/**
 * 单例对象
 */
static JYDModelLocator *_sharedModelLocator;

/**
 *  在IOS中，所有对象的内存空间的分配，最终都会调用allocWithZone方法
 *  如果需要做单例，需要重写此方法
 *  GCD提供了一个方法，专门用来创建单例的
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedModelLocator = [super allocWithZone:zone];
    });
    
    return _sharedModelLocator;
}

+ (instancetype)shareModelLocator
{
    //如果有两个线程实例化，很可能创建出两个实例
    //    if (_sharedInstance == nil) {
    //        _sharedInstance = [[JSModelLocator alloc] init];
    //    }
    //
    //    return _sharedInstance;
    
    return [[self alloc]init];
}

@end
