//
//  BBXScrollContentView.m
//  Baobaoxiu
//
//  Created by He leon on 12-6-8.
//  Copyright (c) 2012年 Wodache. All rights reserved.
//

#import "BBXScrollContentView.h"

@implementation BBXScrollContentView
@synthesize rectImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    selIndex = index;
}

- (void)setSender:(id)sender{
    mainSender = sender;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(rectImage, location)) {
        if ([mainSender respondsToSelector:@selector(clickContentPage:)]) {
            [mainSender performSelector:@selector(clickContentPage:) withObject:[NSNumber numberWithInteger:selIndex]];
        }
    }  
}

- (void)clickContentPage:(id)sender{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
