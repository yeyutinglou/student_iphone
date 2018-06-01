//
//  BaseLabel.m
//  Walker
//
//  Created by he chao on 3/12/14.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel

+ (id)initLabel:(NSString *)str font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment{
    BeeUILabel *lb = [BeeUILabel spawn];
    lb.text = str;
    lb.font = font;
    lb.textColor = color;
    lb.textAlignment = textAlignment;
    lb.numberOfLines = 0;
    return lb;
}

@end
