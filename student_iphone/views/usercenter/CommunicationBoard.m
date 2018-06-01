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
//  CommunicationBoard.m
//  ClassRoom
//
//  Created by he chao on 6/17/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "CommunicationBoard.h"

#pragma mark -

@interface CommunicationBoard()
{
	//<#@private var#>
}
@end

@implementation CommunicationBoard
DEF_SIGNAL(MESSAGE)
DEF_SIGNAL(MY_FRIEND)
DEF_SIGNAL(MY_TEACHER)
DEF_SIGNAL(MY_STUDENT)
DEF_SIGNAL(MY_COLLEAGUE)
DEF_SIGNAL(HIDE)

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    self.title = @"交流";
    [self loadContent];
    [self showMenuBtn];
    [self observeNotification:@"newMessage"];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [viewMessage loadMessage];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [popupView removeFromSuperview];
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL2(CommunicationBoard, signal) {
    if ([signal is:CommunicationBoard.MESSAGE]) {
        [self sendUISignal:CommunicationBoard.HIDE];
        if (!viewMessage) {
            viewMessage = [[MessageView alloc] initWithFrame:CGRectMake(0, 50, self.viewWidth, self.viewHeight-50-50-(IOS7_OR_LATER?64:44))];
            [viewMessage loadContent];
        }
        [viewMessage loadMessage];
        [self.view addSubview:viewMessage];
    }
    else if ([signal is:CommunicationBoard.MY_STUDENT]) {
        [self sendUISignal:CommunicationBoard.HIDE];
        if (!viewStudent) {
            viewStudent = [[StudentListView alloc] initWithFrame:CGRectMake(0, 50, self.viewWidth, self.viewHeight-50-50-(IOS7_OR_LATER?64:44))];
            [viewStudent loadContent];
        }
        else
            [viewStudent refresh];
        [self.view addSubview:viewStudent];
    }
    else if ([signal is:CommunicationBoard.MY_TEACHER]) {
        [self sendUISignal:CommunicationBoard.HIDE];
        if (!viewTeacher) {
            viewTeacher = [[TeacherListView alloc] initWithFrame:CGRectMake(0, 50, self.viewWidth, self.viewHeight-50-50-(IOS7_OR_LATER?64:44))];
            [viewTeacher loadContent];
        }
        else
            [viewTeacher refresh];
        [self.view addSubview:viewTeacher];
    }
    else if ([signal is:CommunicationBoard.HIDE]){
        if (viewStudent) {
            [viewStudent hideKeyboard];
        }
        if (viewTeacher) {
            [viewTeacher hideKeyboard];
        }
    }
}

ON_NOTIFICATION(notification){
    if ([notification is:@"newMessage"]) {
        [segment setSelectedSegmentIndex:0];
        [self sendUISignal:CommunicationBoard.MESSAGE];
        [viewMessage loadMessage];
    }
}

- (void)loadContent{
    segment = [BeeUISegmentedControl spawn];
    [segment addTitle:@"我的消息" signal:CommunicationBoard.MESSAGE];
//    if (!isTeacher) {
        [segment addTitle:@"我的好友" signal:CommunicationBoard.MY_STUDENT];
        [segment addTitle:@"我的老师" signal:CommunicationBoard.MY_TEACHER];
//    }
//    else {
//        [segment addTitle:@"我的学生" signal:CommunicationBoard.MY_STUDENT];
//        [segment addTitle:@"我的同事" signal:CommunicationBoard.MY_TEACHER];
//    }
    
    segment.tintColor = RGB(117, 213, 73);
    segment.frame = CGRectMake((self.viewWidth-260)/2.0, 10, 260, 30);
    [segment setSelectedSegmentIndex:0];
    [self.view addSubview:segment];
    
    [self sendUISignal:CommunicationBoard.MESSAGE];
    
    //[self.view makeTappable:CommunicationBoard.HIDE];
}

@end
