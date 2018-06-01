//
//  BaseButton.m
//  Walker
//
//  Created by he chao on 14-3-11.
//  Copyright (c) 2014年 leon. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton

+ (id)initBaseBtn:(UIImage *)imgNormal highlight:(UIImage *)imgHighlight text:(NSString *)strText textColor:(UIColor *)color font:(UIFont *)font{
    id btn = [self spawn];
    [btn setBackgroundImage:imgNormal forState:UIControlStateNormal];
    [btn setBackgroundImage:imgHighlight forState:UIControlStateHighlighted];
    [btn setTitle:strText forState:UIControlStateNormal];
    [btn setTitleFont:font];
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}

+ (id)initBaseBtn:(UIImage *)imgNormal highlight:(UIImage *)imgHighlight{
    id btn = [self spawn];
    [btn setImage:imgNormal forState:UIControlStateNormal];
    [btn setImage:imgHighlight forState:UIControlStateHighlighted];
    return btn;
}

@end
