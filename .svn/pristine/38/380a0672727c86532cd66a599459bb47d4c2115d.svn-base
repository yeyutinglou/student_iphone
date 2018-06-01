//
//  MojiFaceView.m
//  ClassRoom
//
//  Created by he chao on 7/16/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "MojiFaceView.h"
#import "AppDelegate.h"

@implementation MojiFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
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

- (void)showMessage:(NSMutableArray *)message  width:(CGFloat)width{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    dictFace = delegate.dictFace;
    
    viewWidth = width;
    self.data = message;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    
	if ( self.data ) {
        
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        
        isLineReturn = NO;
        
        upX = 0;
        upY = 0;
        
		for (int index = 0; index < [self.data count]; index++) {
            
			NSString *str = [self.data objectAtIndex:index];
			if ( [str hasPrefix:FACE_NAME_HEAD]&&[str hasSuffix:FACE_NAME_END] ) {
                
				//NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                
                NSString *imageName = [dictFace valueForKey:str];
                
                UIImage *image = [UIImage imageNamed:imageName];
                
                if ( image ) {
                    
                    //                    if ( upX > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) ) {
                    if ( upX > ( viewWidth-kFaceWidth ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = 0;
                        upY += VIEW_LINE_HEIGHT;
                    }
                    
                    [image drawInRect:CGRectMake(upX, upY, kFaceWidth, kFaceHeight)];
                    
                    upX += kFaceWidth;
                    
                    lastPlusSize = kFaceWidth;
                }
                else {
                    
                    [self drawText:str withFont:font];
                }
			}
            else {
                
                [self drawText:str withFont:font];
			}
        }
	}
}

- (void)drawText:(NSString *)string withFont:(UIFont *)font{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for ( int index = 0; index < string.length; index++) {
        
        NSString *character = [string substringWithRange:NSMakeRange( index, 1 )];
        
        CGSize size = [character sizeWithFont:font
                            constrainedToSize:CGSizeMake(viewWidth, VIEW_LINE_HEIGHT * 1.5)];
        
        if ( upX > ( viewWidth - kFaceWidth ) ) {
            
            isLineReturn = YES;
            
            upX = 0;
            upY += VIEW_LINE_HEIGHT;
        }
        if ([self.commentName isEqualToString:string]) {
            CGContextSetFillColorWithColor(context, RGB(69, 108, 151).CGColor);
        }
        else {
            CGContextSetFillColorWithColor(context, RGB(137, 137, 137).CGColor);
        }
        [character drawInRect:CGRectMake(upX, upY, size.width, self.bounds.size.height) withFont:font];
        
        upX += size.width;
        
        lastPlusSize = size.width;
    }
}


@end
