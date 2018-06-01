//
//  DictFloor.h
//  teacher_iphone
//
//  Created by jyd on 16/6/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictFloor : NSObject


@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)floorWithDict:(NSDictionary*)dict;

@end
