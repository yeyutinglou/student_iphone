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
//  MeBoard.m
//  student_iphone
//
//  Created by he chao on 14/11/15.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "MeBoard.h"
#import "TestAnalysisBoard.h"
#import "CurriculumCell.h"
#import "WrongListBoard.h"
#import "MyClassBoard.h"

#pragma mark -

@interface MeBoard()
{
	BeeUISegmentedControl *segment;
    UIView *contentView;
    
    WrongListBoard *wrongCtrl;
    TestAnalysisBoard *testCtrl;
    MyClassBoard *classCtrl;
}
AS_SIGNAL(SEG_ONE)
AS_SIGNAL(SEG_TWO)
AS_SIGNAL(SEG_THREE)
@end

@implementation MeBoard
DEF_SIGNAL(SEG_ONE)
DEF_SIGNAL(SEG_TWO)
DEF_SIGNAL(SEG_THREE)

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
    self.title = @"我的";
    [self loadContent];
    [self showMenuBtn];
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

ON_SIGNAL2(MeBoard, signal) {
    if ([signal is:MeBoard.SEG_ONE]) {
        classCtrl.view.hidden = NO;
        [contentView bringSubviewToFront:classCtrl.view];
    }
    else if ([signal is:MeBoard.SEG_TWO]) {
        if (!wrongCtrl) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            wrongCtrl = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WrongListBoard"];
            [contentView addSubview:wrongCtrl.view];
            wrongCtrl.myTable.frame = contentView.bounds;
        }
        wrongCtrl.view.hidden = NO;
        [contentView bringSubviewToFront:wrongCtrl.view];
    }
    else if ([signal is:MeBoard.SEG_THREE]) {
        if (!testCtrl) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            testCtrl = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TestAnalysisBoard"];
            [contentView addSubview:testCtrl.view];
            testCtrl.myTable.frame = contentView.bounds;
        }
        testCtrl.view.hidden = NO;
        [contentView bringSubviewToFront:testCtrl.view];
    }
}

- (void)loadContent{
    segment = [BeeUISegmentedControl spawn];
    [segment addTitle:@"我的课程" signal:MeBoard.SEG_ONE];
    [segment addTitle:@"我的错题" signal:MeBoard.SEG_TWO];
    [segment addTitle:@"测验统计" signal:MeBoard.SEG_THREE];

    
    segment.tintColor = RGB(117, 213, 73);
    segment.frame = CGRectMake((self.viewWidth-260)/2.0, 10, 260, 30);
    [segment setSelectedSegmentIndex:0];
    [self.view addSubview:segment];
    
    [self sendUISignal:MeBoard.SEG_ONE];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, segment.bottom+10, self.viewWidth, self.viewHeight-64-segment.height-20-50)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    TestAnalysisBoard *controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TestAnalysisBoard"];
//    [contentView addSubview:controller.view];
//    controller.myTableView.frame = contentView.bounds;
    
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    wrongCtrl = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WrongListBoard"];
//    [contentView addSubview:wrongCtrl.view];
//    wrongCtrl.myTable.frame = contentView.bounds;
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    classCtrl = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MyClassBoard"];
    [contentView addSubview:classCtrl.view];
    classCtrl.view.frame = contentView.bounds;
    [classCtrl viewWillAppear:YES];
    
}

@end
