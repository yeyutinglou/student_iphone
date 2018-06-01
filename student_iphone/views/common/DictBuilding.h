//
//  DictBuilding.h
//  teacher_iphone
//
//  Created by jyd on 16/6/3.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictBuilding : NSObject


@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)buildingWithDict:(NSDictionary*)dict;

@end
