//
//  DictClassroom.h
//  teacher_iphone
//
//  Created by jyd on 16/6/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictClassroom : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)classWithDict:(NSDictionary*)dict;

@end
