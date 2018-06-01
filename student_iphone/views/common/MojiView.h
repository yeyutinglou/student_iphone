//
//  MojiView.h
//  Walker
//
//  Created by he chao on 3/26/14.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MojiView : UIView

- (void)setContent:(NSString *)message maxWidth:(CGFloat)width;

- (void)setCommentContent:(NSString *)content maxWidth:(CGFloat)width userLength:(CGFloat)length;
@end
