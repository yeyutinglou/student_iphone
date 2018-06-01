//
//  AvatarView.m
//  Walker
//
//  Created by he chao on 14-3-29.
//  Copyright (c) 2014年 leon. All rights reserved.
//

#import "AvatarView.h"

@implementation AvatarView

+ (id)initFrame:(CGRect)frame image:(UIImage *)image borderColor:(UIColor *)color{
    BeeUIImageView *imgAvatar = [BeeUIImageView spawn];
    imgAvatar.frame = frame;
    imgAvatar.image = image;
    imgAvatar.contentMode = UIViewContentModeScaleToFill;
    imgAvatar.layer.borderWidth = 1.0;
    imgAvatar.layer.borderColor = color.CGColor;
    imgAvatar.layer.masksToBounds = YES;
    imgAvatar.layer.cornerRadius = frame.size.width/2.0;
    return imgAvatar;
}

@end
