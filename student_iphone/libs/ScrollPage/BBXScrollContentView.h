//
//  BBXScrollContentView.h
//  Baobaoxiu
//
//  Created by He leon on 12-6-8.
//  Copyright (c) 2012年 Wodache. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBXScrollContentView : UIView{
    NSInteger selIndex;
    CGRect rectImage;
    id mainSender;
}

@property (nonatomic) CGRect rectImage;

- (void)setIndex:(NSInteger)index;
- (void)setSender:(id)sender;

@end
