//
//  MojiView.m
//  Walker
//
//  Created by he chao on 3/26/14.
//  Copyright (c) 2014 leon. All rights reserved.
//

#import "MojiView.h"
#import "AppDelegate.h"

@implementation MojiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
//#define MAX_WIDTH 150

- (void)setContent:(NSString *)message maxWidth:(CGFloat)width{
    //self.backgroundColor = [UIColor redColor];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *dictFace = delegate.dictFace;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    
    for (int i = 0; i < array.count; i++) {
        NSString *str=[array objectAtIndex:i];
        if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG]){
            if (upX >= width)
            {
                upY = upY + KFacialSizeHeight;
                upX = 0;
                X = 150;
                Y = upY;
            }
            
                
            //NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
            UIImage *tempImage = [UIImage imageNamed:dictFace[str]];
            UIImageView *img=[[UIImageView alloc]initWithImage:tempImage];
            img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
            [self addSubview:img];
            upX=KFacialSizeWidth+upX;
            if (X<150) X = upX;
        }
        else {
            for (int j = 0; j < [str length]; j++) {
                NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                if (upX >= width)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 150;
                    Y =upY;
                }
                CGSize size=[temp sizeWithFont:FONT(14) constrainedToSize:CGSizeMake(150, 40)];
                UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                la.font = FONT(14);
                la.textColor = [UIColor blackColor];
                la.text = temp;
                la.backgroundColor = [UIColor clearColor];
                [self addSubview:la];
                upX=upX+size.width;
                if (X<150) {
                    X = upX;
                }
            }
        }
    }
    
    self.frame = CGRectMake(0, 0, X, Y+KFacialSizeHeight);
}

- (void)setCommentContent:(NSString *)content maxWidth:(CGFloat)width userLength:(CGFloat)length{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *dictFace = delegate.dictFace;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:content :array];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    
    for (int i = 0; i < array.count; i++) {
        NSString *str=[array objectAtIndex:i];
        if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG]){
            if (upX >= width)
            {
                upY = upY + KFacialSizeHeight;
                upX = 0;
                X = 150;
                Y = upY;
            }
            
            
            //NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
            UIImage *tempImage = [UIImage imageNamed:dictFace[str]];
            UIImageView *img=[[UIImageView alloc]initWithImage:tempImage];
            img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
            [self addSubview:img];
            upX=KFacialSizeWidth+upX;
            if (X<150) X = upX;
        }
        else {
            for (int j = 0; j < [str length]; j++) {
                NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                if (upX >= width)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 150;
                    Y =upY;
                }
                CGSize size=[temp sizeWithFont:FONT(14) constrainedToSize:CGSizeMake(150, 40)];
                UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                la.font = FONT(14);
                la.textColor = [UIColor blackColor];
                la.text = temp;
                la.backgroundColor = [UIColor clearColor];
                [self addSubview:la];
                upX=upX+size.width;
                if (X<150) {
                    X = upX;
                }
            }
        }
    }
    
    self.frame = CGRectMake(0, 0, X, Y+KFacialSizeHeight);
}

- (void)getImageRange:(NSString *)message : (NSMutableArray *)array{
    NSRange range = [message rangeOfString:BEGIN_FLAG];
    NSRange range1 = [message rangeOfString:END_FLAG];
    
    if (range.length>0 && range1.length>0) {
        if (range.location>0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str = [message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        } else {
            NSString *nextstr = [message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str = [message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }
            else {
                return;
            }
        }
    } else if (message != nil) {
        [array addObject:message];
    }
}

@end
