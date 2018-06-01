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
//  ClassRoomBoard.m
//  ClassRoom
//
//  Created by he chao on 6/17/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "ClassRoomBoard.h"
#import "CheckinBoard.h"
#import "StudentListBoard.h"
#import "ClassDetailBoard.h"
#import "ScheduleView.h"
#import "SocketData.h"

#pragma mark -

@interface ClassRoomBoard()
{
	//<#@private var#>
    NSMutableArray *arrayAutho;
}
@end

@implementation ClassRoomBoard
DEF_SIGNAL(WEEK)
DEF_SIGNAL(PRE)
DEF_SIGNAL(NEXT)

#define weekNormalColor RGB(181, 181, 181)
#define weekSelColor RGB(74, 174, 61)

- (void)load
{
    weeks = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    self.title = @"课堂";
    
    [self initDate];
    [self loadContent];
    

    [self getStudentCourseSchedule];

    [self observeNotification:@"checkinSuccess"];
    
    [self getSocketInfo];
    
    //2016-05-06
    [self showBarButton:BeeUINavigationBar.RIGHT image:IMAGESTRING(@"navi_list1")];
}

- (void)getSocketInfo{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/service/get_socket_info.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9529;
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
    [self getStudentCourseSchedule];
    
}
-(void)refreshOnClassStatus{
    [self performSelector:@selector(refreshOnClassStatus) withObject:nil afterDelay:60];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"hh:mm"];
    NSString *now = [dateFomatter stringFromDate:[NSDate date]];
    for (NSDictionary *dic in arrayCourse) {
        if ([dic[@"classBeginTime"] isEqualToString:now] || [dic[@"classEndTime"] isEqualToString:now]) {
            [self getStudentCourseSchedule];
            [[MainBoard sharedInstance] getSignTime];
        }
    }
}


ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [popupView removeFromSuperview];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}


ON_SIGNAL2(ClassRoomBoard, signal){
    if ([signal is:ClassRoomBoard.WEEK]) {
        BeeUIButton *source = signal.source;
        [self setSelDate:source.tag];
        
        pageCtrl.pageControl.currentPage = source.tag;
        [pageCtrl changePage:pageCtrl.pageControl];
    }
    else if ([signal is:ClassRoomBoard.PRE]) {
        dateIndex0 = [dateIndex0 dateByAddingTimeInterval:-5*24*3600];
        NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:dateIndex0];
        weekdayIndex0 = [componets weekday]-1;
        [self updateWeekView];
        
//        BOOL isTeacher = YES;
//        if (isTeacher) {
//            [self getTeacherCourseSchedule];
//        }
//        else {
//            [self getStudentCourseSchedule];
//        }
    }
    else if ([signal is:ClassRoomBoard.NEXT]) {
        dateIndex0 = [dateIndex0 dateByAddingTimeInterval:5*24*3600];
        NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:dateIndex0];
        weekdayIndex0 = [componets weekday]-1;
        [self updateWeekView];
        
//        BOOL isTeacher = YES;
//        if (isTeacher) {
//            [self getTeacherCourseSchedule];
//        }
//        else {
//            [self getStudentCourseSchedule];
//        }
    }
}

ON_NOTIFICATION(notification) {
    if ([notification is:@"checkinSuccess"]) {
        [self getStudentCourseSchedule];
    }
}

- (void)getStudentCourseSchedule{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    //[[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在加载"];
    
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_stu_course_sched.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"dateStr",[formatter stringFromDate:dateSel]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9528;
    NSLog(@"%@,%@,%@",kUserInfo[@"id"],[formatter stringFromDate:dateSel],kUserInfo[@"sessionId"]);
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        NETWORK_ERROR
        [[BeeUITipsCenter sharedInstance] dismissTips];
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9528:
                    {
                        arrayCourse = json[@"result"];
                        [self saveCache:arrayCourse];
                        [self showAutho:arrayCourse];
                        [self showScheduleView:arrayCourse];
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                        [self performSelector:@selector(refreshOnClassStatus) withObject:nil afterDelay:60];
                    }
                        break;
                    case 9529:
                    {
                        [SocketData sharedInstance].dictSocket = json[@"result"];
                        
                        //add by zhaojian 2015-12-29调试跟屏使用
                        //[SocketData sharedInstance].dictSocket[@"courseSchedId"] = @"182744";
                        
                        [[SocketData sharedInstance] connect];
                    }
                        break;
                    case 10005:
                    {
                        [arrayAutho addObject:json[@"result"]];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                [self showScheduleView:nil];
            }
                break;
                
        }
    }
    
    //2016-05-06
    [super handleRequest:request];
    
}

-(void)showAutho:(NSMutableArray *)arr{
    for (int i = 0; i < [arr count]; i++) {
        NSMutableDictionary *dic = arr[i];
        

    }
}

- (void)saveCache:(id)data{
}

- (void)showScheduleView:(NSMutableArray *)array{
    if (!schedule) {
        schedule = [[ScheduleView alloc] initWithFrame:CGRectMake(0, 46, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44)-50-46)];
    }
    
    schedule.arrayCourse = array;
    schedule.selDate = dateSel;
    [schedule loadContent];
    [self.view addSubview:schedule];

}

- (void)btn{
    //CheckinBoard *board = [[CheckinBoard alloc] init];
    StudentListBoard *board = [[StudentListBoard alloc] init];
    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
}

- (void)btn2{
    //CheckinBoard *board = [[CheckinBoard alloc] init];
    ClassDetailBoard *board = [[ClassDetailBoard alloc] init];
    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
}

- (void)initDate{
    NSDate *now = [NSDate date];
    dateIndex0 = [now dateByAddingTimeInterval:-2*24*3600];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:dateIndex0];
    weekdayIndex0 = [componets weekday]-1;
}

- (void)loadContent{
    arrayAutho = [[NSMutableArray alloc] init];
    UIView *viewWeek = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 46)];
    viewWeek.backgroundColor = RGB(236, 236, 236);
    [self.view addSubview:viewWeek];
    NSArray *arrayWeek = @[@"周一",@"周二",@"周三",@"周四",@"周五"];
    for (int i = 0; i < 5; i++) {
        lbWeek[i] = [BaseLabel initLabel:weeks[(weekdayIndex0+i)%7] font:FONT(14) color:weekNormalColor textAlignment:NSTextAlignmentCenter];
        lbWeek[i].frame = CGRectMake(20+i*(self.viewWidth-40)/5, 0, (self.viewWidth-40)/5, 36);
        if (i == 2) {
            lbWeek[i].text = @"今天";
        }
        [viewWeek addSubview:lbWeek[i]];
        
        
        NSDate *dt = [dateIndex0 dateByAddingTimeInterval:24*3600*i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM.dd"];
        
        lbDate[i] = [BaseLabel initLabel:[formatter stringFromDate:dt] font:FONT(11) color:weekSelColor textAlignment:NSTextAlignmentCenter];
        lbDate[i].frame = CGRectMake(lbWeek[i].left, 27, lbWeek[i].width, 13);
        [viewWeek addSubview:lbDate[i]];
        
        line[i] = [[UIView alloc] initWithFrame:CGRectMake(lbWeek[i].left, viewWeek.height-3, lbWeek[i].width, 3)];
        line[i].backgroundColor = weekSelColor;
        [viewWeek addSubview:line[i]];
        
        btn[i] = [BeeUIButton spawn];
        btn[i].tag = i;
        [btn[i] addSignal:ClassRoomBoard.WEEK forControlEvents:UIControlEventTouchUpInside];
        btn[i].frame = CGRectMake(i*self.viewWidth/arrayWeek.count, 0, self.viewWidth/arrayWeek.count, viewWeek.height);
        [viewWeek addSubview:btn[i]];
    }
    
    BaseButton *btnLeft = [BaseButton initBaseBtn:IMAGESTRING(@"left") highlight:nil];
    btnLeft.frame = CGRectMake(0, 0, 18, 46);
    [btnLeft addSignal:ClassRoomBoard.PRE forControlEvents:UIControlEventTouchUpInside];
    [viewWeek addSubview:btnLeft];
    
    BaseButton *btnRight = [BaseButton initBaseBtn:IMAGESTRING(@"right") highlight:nil];
    [btnRight addSignal:ClassRoomBoard.NEXT forControlEvents:UIControlEventTouchUpInside];
    btnRight.frame = CGRectMake(self.viewWidth-18, 0, 18, 46);
    [viewWeek addSubview:btnRight];
    
    if (!pageCtrl) {
        pageCtrl = [[CVScrollPageViewController alloc] init];
    }
    pageCtrl.frame = CGRectMake(0, viewWeek.bottom, self.viewWidth, self.viewHeight-viewWeek.height-50-(IOS7_OR_LATER?64:44));
    pageCtrl.view.hidden = NO;
    pageCtrl.view.backgroundColor = [UIColor whiteColor];//RGB(239, 239, 239);
    [pageCtrl setDelegate:self];
    pageCtrl.pageCount = 5;
    
    
    pageCtrl.pageControlFrame = CGRectMake(0, 1140, self.viewWidth, 20);
    
    [pageCtrl reloadData];
    
    
    pageCtrl.pageControl.currentPage = 2;
    [pageCtrl changePage:pageCtrl.pageControl];
    [self.view addSubview:pageCtrl.view];
    
//    ScheduleView *view = [[ScheduleView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44)-50)];
//    [view loadContent];
//    [self.view addSubview:view];
    
}


- (void)updateWeekView{
    for (int i = 0; i < 5; i++) {
        [UIView animateWithDuration:0.15 animations:^{
            lbWeek[i].text = weeks[(weekdayIndex0+i)%7];
        }];
        lbWeek[i].textColor = weekNormalColor;
        //lbDate[i].hidden = YES;
        NSDate *dt = [dateIndex0 dateByAddingTimeInterval:24*3600*i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM.dd"];
        lbDate[i].text = [formatter stringFromDate:dt];
        line[i].hidden = YES;
        
        if ([[formatter stringFromDate:[NSDate date]] isEqualToString:lbDate[i].text]) {
            lbWeek[i].text = @"今天";
        }
        
        if ([[formatter stringFromDate:dt] isEqualToString:[formatter stringFromDate:dateSel]]) {
            lbWeek[i].textColor = weekSelColor;
            lbDate[i].hidden = NO;
            line[i].hidden = NO;
        }
    }
}

- (void)setSelDate:(NSInteger)index{
    for (int i = 0; i < 5; i++) {
        lbWeek[i].textColor = weekNormalColor;
        lbDate[i].textColor = weekNormalColor;
        lbDate[i].hidden = NO;//YES;
        line[i].hidden = YES;
        if (i == index) {
            lbWeek[i].textColor = weekSelColor;
            lbDate[i].textColor = weekSelColor;
            line[i].backgroundColor = weekSelColor;
            lbDate[i].hidden = NO;
            line[i].hidden = NO;
            
            dateSel = [dateIndex0 dateByAddingTimeInterval:index*24*3600];
        }
    }
    
//    if (isTeacher) {
//        [self getTeacherCourseSchedule];
//    }
//    else {
        [self getStudentCourseSchedule];
//    }
}

- (void)didScrollToPageAtIndex:(NSUInteger)index {
    [self setSelDate:index];
}

- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
    UIView *pageView;
    pageView = (UIView *)[scrollPageView dequeueReusablePage:index];
    if (nil == pageView) {
        pageView = [[UIView alloc] initWithFrame:pageCtrl.view.bounds];
    }
    for (id element in pageView.subviews) {
        [element removeFromSuperview];
    }
    return pageView;
}

@end
