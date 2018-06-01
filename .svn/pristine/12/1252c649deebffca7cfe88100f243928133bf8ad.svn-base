//
//  PaintView.m
//  student_ipad
//
//  Created by nsc on 15/1/18.
//  Copyright (c) 2015年 leon. All rights reserved.
//

#import "PaintView.h"
#import "NSObject+Extension.h"

@implementation PaintView



- (id)initWithFrame:(CGRect)frame {
    
    JYDLog(@"initwithframe");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        allline=NO;
    }
    return self;
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        allline=NO;
    }
    return self;
}
-(void)IntsegmentColor
{
    switch (Intsegmentcolor)
    {
        case 0:
            segmentColor=[[UIColor orangeColor] CGColor];
            break;
        case 1:
            segmentColor=[[UIColor magentaColor]CGColor];
            break;
        case 2:
            segmentColor=[[UIColor blueColor] CGColor];
            break;
        case 3:
            segmentColor=[[UIColor blackColor] CGColor];
            break;
        case 4:
            segmentColor=[[UIColor greenColor] CGColor];
            break;
        case 5:
            segmentColor=[[UIColor redColor] CGColor];
            break;
        case 6:
            segmentColor=[[UIColor clearColor]CGColor];
            //            segmentColor=[[UIColor whiteColor]CGColor];
            break;
        default:
            break;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //JYDLog(@"Thes is drawRect ");
    //获取上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //设置笔冒
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置画线的连接处　拐点圆滑
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //第一次时候个myallline开辟空间
    if (allline==NO)
    {
        myallline=[[NSMutableArray alloc] initWithCapacity:10];
        myallColor=[[NSMutableArray alloc] initWithCapacity:10];
        myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
        allline=YES;
    }
    //画之前线
    if ([myallline count]>0)
    {
        for (int i=0; i<[myallline count]; i++)
        {
            if ([myallline[i] isKindOfClass:[UIImage class]]) {
                UIImage *image = myallline[i];
                NSString *strRect = image.userInfo[@"frame"];
                CGRect rc =  CGRectFromString(strRect);
                [image drawInRect:rc];
            }
            else {
                NSArray* tempArray=[NSArray arrayWithArray:[myallline objectAtIndex:i]];
                //----------------------------------------------------------------
                if ([myallColor count]>0)
                {
                    Intsegmentcolor=[[myallColor objectAtIndex:i] intValue];
                    Intsegmentwidth=[[myallwidth objectAtIndex:i]floatValue]+1;
                }
                //-----------------------------------------------------------------
                if ([tempArray count]>1)
                {
                    if (Intsegmentcolor != 6) {
                        CGContextBeginPath(context);
                        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
                        CGPoint myStartPoint=[[tempArray objectAtIndex:0] CGPointValue];
                        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
                        for (int j=0; j<[tempArray count]-1; j++)
                        {
                            CGPoint myEndPoint=[[tempArray objectAtIndex:j+1] CGPointValue];
                            //--------------------------------------------------------
                            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                        }
                        [self IntsegmentColor];
                        CGContextSetStrokeColorWithColor(context, segmentColor);
                        //-------------------------------------------------------
                        CGContextSetLineWidth(context, Intsegmentwidth);
                        CGContextStrokePath(context);
                    }
                    else {
                        CGContextBeginPath(context);
                        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
                        
                        CGPoint myStartPoint=[[tempArray objectAtIndex:0] CGPointValue];
                        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
                        for (int j=0; j<[tempArray count]-1; j++)
                        {
                            CGPoint myEndPoint=[[tempArray objectAtIndex:j+1] CGPointValue];
                            //--------------------------------------------------------
                            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                        }
                        [self IntsegmentColor];
                        CGContextSetStrokeColorWithColor(context, segmentColor);
                        //-------------------------------------------------------
                        CGContextSetLineWidth(context, Intsegmentwidth);
                        CGContextStrokePath(context);
                    }
                }
            }
        }
    }
    //画当前的线
    if ([myallpoint count]>1)
    {
        CGContextBeginPath(context);
        //-------------------------
        //起点
        //------------------------
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        CGPoint myStartPoint=[[myallpoint objectAtIndex:0]   CGPointValue];
        CGContextMoveToPoint(context,    myStartPoint.x, myStartPoint.y);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        //把move的点全部加入　数组
        for (int i=0; i<[myallpoint count]-1; i++)
        {
            CGPoint myEndPoint=  [[myallpoint objectAtIndex:i+1] CGPointValue];
            CGContextAddLineToPoint(context, myEndPoint.x,   myEndPoint.y);
        }
        //在颜色和画笔大小数组里面取不相应的值
        Intsegmentcolor=[[myallColor lastObject] intValue];
        Intsegmentwidth=[[myallwidth lastObject]floatValue]+1;
        
        //-------------------------------------------
        //绘制画笔颜色
        [self IntsegmentColor];
        CGContextSetStrokeColorWithColor(context, segmentColor);
        CGContextSetFillColorWithColor (context,  segmentColor);
        //-------------------------------------------
        //绘制画笔宽度
        CGContextSetLineWidth(context, Intsegmentwidth);
        //把数组里面的点全部画出来
        CGContextStrokePath(context);
    }
}
//===========================================================
//初始化
//===========================================================
-(void)Introductionpoint1
{
    JYDLog(@"in init allPoint");
    myallpoint=[[NSMutableArray alloc] initWithCapacity:100];
    allDeletePoint = [[NSMutableArray alloc] init];
    allDeleteWidth = [[NSMutableArray alloc] init];
    allDeleteLine = [[NSMutableArray alloc] init];
    allDeleteColor = [[NSMutableArray alloc] init];
}
//===========================================================
//把画过的当前线放入　存放线的数组
//===========================================================
-(void)Introductionpoint2
{
    [myallline addObject:[myallpoint copy]];
    JYDLog(@"line = %@",myallline);
}
//leon changed
- (void)addImage:(UIImage *)image{
    [myallline addObject:image];
    [myallColor addObject:[NSNull null]];
    [myallwidth addObject:[NSNull null]];
    [myallpoint removeAllObjects];
    [self setNeedsDisplay];
    //UIImage *image = myallline[i];
    //[image drawInRect:CGRectMake(40, 200, 400, 400*image.size.height/image.size.width)];
}

-(void)Introductionpoint3:(CGPoint)sender
{
    NSValue* pointvalue=[NSValue valueWithCGPoint:sender];
    [myallpoint addObject:[pointvalue copy]];
    JYDLog(@"point = %@",myallpoint);
}
//===========================================================
//接收颜色segement反过来的值
//===========================================================
-(void)Introductionpoint4:(int)sender
{
    JYDLog(@"Palette sender:%i", sender);
    NSNumber* Numbersender= [NSNumber numberWithInt:sender];
    [myallColor addObject:Numbersender];
}
//===========================================================
//接收线条宽度按钮反回来的值
//===========================================================
-(void)Introductionpoint5:(int)sender
{
    JYDLog(@"Palette sender:%i", sender);
    NSNumber* Numbersender= [NSNumber numberWithInt:sender];
    [myallwidth addObject:Numbersender];
}
//===========================================================
//清屏按钮
//===========================================================
-(void)myalllineclear
{
    if ([myallline count]>0)
    {
        [myallline removeAllObjects];
        [myallColor removeAllObjects];
        [myallwidth removeAllObjects];
        [myallpoint removeAllObjects];
        myallline=[[NSMutableArray alloc] initWithCapacity:100];
        myallColor=[[NSMutableArray alloc] initWithCapacity:10];
        myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
        [self setNeedsDisplay];
    }
}
//===========================================================
//撤销
//===========================================================
-(void)myLineFinallyRemove
{
    if ([myallline count]>0)
    {
        [allDeleteLine addObject:[myallline lastObject]];
        [myallline  removeLastObject];
        [allDeleteColor addObject:[myallColor lastObject]];
        [myallColor removeLastObject];
        [allDeleteWidth addObject:[myallwidth lastObject]];
        [myallwidth removeLastObject];
        [allDeletePoint addObject:myallpoint];
        [myallpoint removeAllObjects];
        
    }
    [self setNeedsDisplay];
}
- (void)recoveryFinallyLine
{
    if ([allDeleteLine count] > 0) {
        [myallline addObject:[allDeleteLine lastObject]];
        [allDeleteLine removeLastObject];
        [myallColor addObject:[allDeleteColor lastObject]];
        [allDeleteColor removeLastObject];
        [myallwidth addObject:[allDeleteWidth lastObject]];
        [allDeleteWidth removeLastObject];
        
    }
    [self setNeedsDisplay];
}
//===========================================================
//橡皮擦　segmentColor=[[UIColor whiteColor]CGColor];
//===========================================================
//-(void)myrubberseraser
//{
//	segmentColor=[[UIColor whiteColor]CGColor];
//}
-(void)button
{
    JYDLog(@"button");
    
    //[self setNeedsDisplay];
}
@end
