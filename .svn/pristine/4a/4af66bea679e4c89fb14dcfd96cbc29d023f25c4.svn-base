//
//  chooseBtn.m
//  teacher_iphone
//
//  Created by jyd on 16/6/2.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "chooseBtn.h"

@implementation chooseBtn
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height ;
    return CGRectMake(0, 0, imageW, imageH);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(0, 0, 0, 0);
}
// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}


@end
