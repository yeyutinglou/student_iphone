//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "AttributedLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface AttributedLabel(){

}
@property (nonatomic,retain)NSMutableAttributedString          *attString;
@end

@implementation AttributedLabel
@synthesize attString = _attString;

- (void)dealloc{
    //[_attString release];
    //[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self setClearsContextBeforeDrawing:YES];
    
    CGRect rc = [_attString boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);
    // added 3 pixels at the top of the frame so that the text is not cuted
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y - 3, rect.size.width, rect.size.height);
    CGPathAddRect(path, NULL, newRect);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    CGPathRelease(path);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CTFrameDraw(frameRef, context);
    CFRelease(frameRef);
    
    
//    CGRect rc = [_attString boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
//    [textLayer removeFromSuperlayer];
//    textLayer = [CATextLayer layer];
//    textLayer.string = _attString;
//    textLayer.transform = CATransform3DMakeScale(0.5,0.5,1);
//    //textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, rc.size.height);
//    [self.layer addSublayer:textLayer];
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);//前面定义的NSMutableAttributedString字符串
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, rect);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//    CFRelease(path);
//    CFRelease(framesetter);
//    CTFrameDraw(frame, ctx);
//    CFRelease(frame);
}

- (void)setText:(NSString *)text{
    [super setText:text];
    self.numberOfLines = 0;
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = nil;
        self.attString = [[NSMutableAttributedString alloc] initWithString:text];//[[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)color.CGColor
                        range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                       font.pointSize*2,
                                                       NULL))
                        range:NSMakeRange(location, length)];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:style]
                        range:NSMakeRange(location, length)];
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
