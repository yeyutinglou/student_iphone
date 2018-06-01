//
//  MessageStatusBar.m
//  Walker
//
//  Created by he chao on 14-5-13.
//  Copyright (c) 2014年 leon. All rights reserved.
//

#import "MessageStatusBar.h"

@implementation MessageStatusBar
DEF_SINGLETON(MessageStatusBar)

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = [UIColor blackColor];
        //self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        
        messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
        //messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 140, 20)];
        //messageLabel.backgroundColor = [UICo];
        [messageLabel setTextColor:[UIColor whiteColor]];
        [messageLabel setTextAlignment:NSTextAlignmentRight];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:messageLabel];

    }
    return self;
}

- (void)load{
    [super load];
}


- (void)showStatusMessage:(NSString *)message{
    self.hidden = NO;
    self.alpha = 1.0f;
    messageLabel.text = @"";
    
    CGSize totalSize = self.frame.size;
    self.frame = (CGRect){ self.frame.origin, 0, totalSize.height };
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = (CGRect){self.frame.origin, totalSize };
    } completion:^(BOOL finished){
        messageLabel.text = message;
    }];
    
}


- (void)hide{
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        messageLabel.text = @"";
        self.hidden = YES;
    }];
}


@end
