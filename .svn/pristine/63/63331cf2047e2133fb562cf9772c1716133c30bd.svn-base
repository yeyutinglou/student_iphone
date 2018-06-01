//
//  PaintView.h
//  student_ipad
//
//  Created by nsc on 15/1/18.
//  Copyright (c) 2015年 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView
{
    float x;
    float y;
    //-------------------------
    int             Intsegmentcolor;
    float           Intsegmentwidth;
    CGColorRef      segmentColor;
    //-------------------------
    NSMutableArray* myallpoint;
    NSMutableArray* myallline;
    NSMutableArray* myallColor;
    NSMutableArray* myallwidth;
    
    NSMutableArray* allDeletePoint;
    NSMutableArray* allDeleteLine;
    NSMutableArray* allDeleteColor;
    NSMutableArray* allDeleteWidth;
    BOOL allline;
    
    
}
@property float x;
@property float y;

-(void)Introductionpoint1;
-(void)Introductionpoint2;
-(void)Introductionpoint3:(CGPoint)sender;
-(void)Introductionpoint4:(int)sender;
-(void)Introductionpoint5:(int)sender;

//=====================================
-(void)myalllineclear;
-(void)myLineFinallyRemove;
- (void)recoveryFinallyLine;

- (void)addImage:(UIImage *)image;


@end
