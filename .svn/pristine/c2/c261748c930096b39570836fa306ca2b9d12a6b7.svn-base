//
//  PersonalCenterHeadView.m
//  student_iphone
//
//  Created by jyd on 15/8/19.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "PersonalCenterHeadView.h"

@implementation PersonalCenterHeadView

- (IBAction)btnRanking:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookRankingHistory:)]) {
        [self.delegate lookRankingHistory:YES];
    }
}
- (IBAction)btnClubGlod:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookRankingHistory:)]) {
        [self.delegate lookRankingHistory:NO];
    }
}
- (IBAction)btnLottery:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goLottery)]) {
        [self.delegate goLottery];
    }

}

- (IBAction)btnExchange:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goExchange)]) {
        [self.delegate goExchange];
    }
}
- (IBAction)btnGoldRule:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookGlodRule)]) {
        [self.delegate lookGlodRule];
    }
}

@end
