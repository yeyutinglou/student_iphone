//
//  CVPageControlView.m
//  CapitalValDemo
//
//  Created by leon on 10-8-23.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVPageControlView.h"

@interface CVPageControlView()

- (void)changeIconImage:(NSInteger)page;

@end


@implementation CVPageControlView

@synthesize pageControlStyle;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		pageControlStyle = 0;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	if (1 == pageControlStyle) {
		[self changeIconImage:0];
	}
}

- (void)changeIconImage:(NSInteger)page {
	for (int i=0; i<self.numberOfPages; i++) {
		UIImageView *pageIcon = [self.subviews objectAtIndex:i];
        CGRect frame = pageIcon.frame;
        frame.size.width = 8;
        frame.size.height = 8;
        [pageIcon setFrame:frame];
        //NSLog(@"%f",frame.size.width);
		if ([pageIcon isKindOfClass:[UIImageView class]]) {
			if (i == page) {
				pageIcon.image = [UIImage imageNamed:@"page_select"];
			}
			else {
				pageIcon.image = [UIImage imageNamed:@"page_normal"];
			}
			
		}
	}
}

- (void)setCurrentPage:(NSInteger)page {
	[super setCurrentPage:page];
	if (1 == pageControlStyle) {
		[self changeIconImage:page];
	}
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	NSLog(@"gbgbgb");
//}




@end
