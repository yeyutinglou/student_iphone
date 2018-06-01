//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  ChooseRulerBoard.m
//  ClassRoom
//
//  Created by he chao on 7/4/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "ChooseRulerBoard.h"
#import "VerifyBoard.h"

#pragma mark -

@interface ChooseRulerBoard()
{
	//<#@private var#>
}
@end

@implementation ChooseRulerBoard
DEF_SIGNAL(TEACHER)
DEF_SIGNAL(STUDENT)

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    BeeUIImageView *img = [BeeUIImageView spawn];
    img.frame = self.viewBound;
    img.image = [IMAGESTRING(@"choose_bg") stretchableImageWithLeftCapWidth:0 topCapHeight:286];
    img.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:img];
    
    if (IOS7_OR_LATER) {
        BeeUIImageView *status = [BeeUIImageView spawn];
        status.frame = CGRectMake(0, 0, self.viewWidth, 20);
        status.backgroundColor = [UIColor blackColor];
        [self.view addSubview:status];
    }
    
    BaseButton *btnTeacher = [BaseButton initBaseBtn:IMAGESTRING(@"ruler_teacher") highlight:nil];
    btnTeacher.frame = CGRectMake(35, 190, 111, 111);
    [btnTeacher addSignal:ChooseRulerBoard.TEACHER forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTeacher];
    
    
    BaseButton *btnStudent = [BaseButton initBaseBtn:IMAGESTRING(@"ruler_student") highlight:nil];
    btnStudent.frame = CGRectMake(175, 190, 111, 111);
    [btnStudent addSignal:ChooseRulerBoard.STUDENT forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStudent];
    
    [self sendUISignal:ChooseRulerBoard.STUDENT];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL2(ChooseRulerBoard, signal) {
    if ([signal is:ChooseRulerBoard.TEACHER]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"teacher"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VerifyBoard *board = [[VerifyBoard alloc] init];
        [self.stack pushBoard:board animated:NO];
        
    }
    else if ([signal is:ChooseRulerBoard.STUDENT]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"teacher"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VerifyBoard *board = [[VerifyBoard alloc] init];
        [self.stack pushBoard:board animated:NO];
    }
}

@end
