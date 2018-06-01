//
//  StarPopupView.m
//  ClassRoom
//
//  Created by he chao on 8/2/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "StarPopupView.h"
#import "ClassDetailBoard.h"

@implementation StarPopupView
DEF_SIGNAL(CLOSE)
DEF_SIGNAL(STAR)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

ON_SIGNAL2(StarPopupView, signal){
    if ([signal is:StarPopupView.CLOSE]) {
        [self removeFromSuperview];
    }
    else if ([signal is:StarPopupView.STAR]){
        BaseButton *btn = signal.object;
        int tag = btn.tag;
        for (int i = 0; i < 5; i++) {
            [btnStar[i] setImage:IMAGESTRING(@"star1") forState:UIControlStateNormal];
            if (i<=tag) {
                [btnStar[i] setImage:IMAGESTRING(@"star2") forState:UIControlStateNormal];
            }
        }
        _score = [NSNumber numberWithInt:(tag+1)];
    }
}

- (void)loadContent{
    BeeUIImageView *popup = [BeeUIImageView spawn];
    popup.frame = CGRectMake(38, (self.height-173)/2.0, 243, 173);
    popup.image = IMAGESTRING(@"star_popup");
    popup.userInteractionEnabled = YES;
    [self addSubview:popup];
    
    BaseLabel *title = [BaseLabel initLabel:@"给老师评分" font:FONT(16) color:RGB(80, 80, 80) textAlignment:NSTextAlignmentLeft];
    title.frame = CGRectMake(25, 2, 200, 35);
    [popup addSubview:title];
    
    BaseButton *close = [BaseButton initBaseBtn:IMAGESTRING(@"close") highlight:nil];
    close.frame = CGRectMake(popup.width-35, 0, 35, 35);
    [close addSignal:StarPopupView.CLOSE forControlEvents:UIControlEventTouchUpInside];
    [popup addSubview:close];
    
    for (int i = 0; i < 5; i++) {
        btnStar[i] = [BaseButton initBaseBtn:IMAGESTRING(@"star1") highlight:nil];
        btnStar[i].frame = CGRectMake(16+42*i, 52, 42, 42);
        btnStar[i].tag = i;
        [btnStar[i] addSignal:StarPopupView.STAR forControlEvents:UIControlEventTouchUpInside object:btnStar[i]];
        [popup addSubview:btnStar[i]];
    }
    
    BaseLabel *description = [BaseLabel initLabel:@"请点亮星星，给老师的这节课评个分吧" font:FONT(12) color:title.textColor textAlignment:NSTextAlignmentLeft];
    description.frame = CGRectMake(btnStar[0].left, btnStar[0].bottom+5, 220, 20);
    [popup addSubview:description];
    
    BaseButton *btnDone = [BaseButton initBaseBtn:IMAGESTRING(@"star_btn") highlight:nil text:@"确  定" textColor:[UIColor whiteColor] font:FONT(18)];
    btnDone.frame = CGRectMake(19, description.bottom+5, 205, 35);
    [btnDone  addSignal:ClassDetailBoard.EVALUATE forControlEvents:UIControlEventTouchUpInside object:self];
    [popup addSubview:btnDone];
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
