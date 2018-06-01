//
//  StarView.m
//  ClassRoom
//
//  Created by he chao on 8/2/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //70 13
        // Initialization code
        for (int i = 0; i < 5; i++) {
            star[i] = [BeeUIImageView spawn];
            star[i].frame = CGRectMake(12*i, 0, 12, 13);
            [self addSubview:star[i]];
        }
    }
    return self;
}

- (void)loadContent:(NSString *)score{
    CGFloat s = [score floatValue];
    if (s == 0.0) {
        self.hidden = YES;
    }
    self.hidden = NO;
    for (int i = 0; i < 5; i++) {
        star[i].image = IMAGESTRING(@"star");
        if (i<s) {
            star[i].image = IMAGESTRING(@"star_y");
        }
        else if (s>i-1 && s < i){
            star[i].image = IMAGESTRING(@"star_half");
        }
    }
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
