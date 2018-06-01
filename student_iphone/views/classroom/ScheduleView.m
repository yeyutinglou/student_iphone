//
//  ScheduleView.m
//  ClassRoom
//
//  Created by he chao on 7/4/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "ScheduleView.h"
#import "CheckinBoard.h"
#import "StudentListBoard.h"
#import "ClassDetailBoard.h"
#import "PublishMediaBoard.h"
#import "SelfStudyRoomBoard.h"
#import "ClassRoomMapBoard.h"
@implementation ScheduleView{
    BaseLabel *indexLabel[100];
    BeeUIButton *button;
    NSMutableDictionary *dic;
}
DEF_SIGNAL(DETAIL)
DEF_SIGNAL(WRITE)
DEF_SIGNAL(CHECKIN)
DEF_SIGNAL(SEARCH)
DEF_SIGNAL(LOCATION)
DEF_SIGNAL(SIGNIN)
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

ON_SIGNAL2(ScheduleView, signal){
    if ([signal is:ScheduleView.DETAIL]) {
        ClassDetailBoard *board = [[ClassDetailBoard alloc] init];
        board.dictCourse = signal.object;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:ScheduleView.WRITE]) {
        PublishMediaBoard *board = [[PublishMediaBoard alloc] init];
        board.dictCourse = signal.object;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:ScheduleView.CHECKIN]) {
        CheckinBoard *board = [[CheckinBoard alloc] init];
        board.dictCourse = signal.object;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:ScheduleView.SEARCH]) {
//        SelfStudyRoomBoard *board = [[SelfStudyRoomBoard alloc] init];
//        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SelfStudyRoomBoard *controller = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SelfStudyRoomBoard"];
        controller.strDate = [formatter stringFromDate:_selDate];
        [[MainBoard sharedInstance].navigationController pushViewController:controller animated:YES];
    }
    else if ([signal is:ScheduleView.LOCATION]) {
        NSMutableDictionary *dict = signal.object;
        
        ClassRoomMapBoard *board = [[ClassRoomMapBoard alloc] init];
        board.classRoomDict = signal.object;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        NSLog(@"%@",dict);
    }else if ([signal is:ScheduleView.SIGNIN]){
        NSMutableDictionary *dict = signal.object;
        BOOL isCheckin = [dict[@"signStatus"] boolValue];
          NSMutableDictionary *dictLast = [self.arrayCourse lastObject];
        NSString *strDay = dictLast[@"teachTime"];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"HH:mm"];
        NSString *currentTime = [dateFormatter2 stringFromDate:[NSDate date]];
         NSArray * arraySignList = kGetCache(@"todaySignList");
        NSString *beginSign, *endSign;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        if ([strDay isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
            if (arraySignList.count > 0) {
                for (NSDictionary  *sign in arraySignList ) {
                    if ([sign[@"id"] isEqualToString:dict[@"id"]] ) {
                        beginSign = sign[@"signBeginTime"];
                        endSign = sign[@"signEndTime"];
                    }
                }
            }
            NSString *sing1 = [beginSign componentsSeparatedByString:@" "][1];
            NSString *sing2 = [endSign componentsSeparatedByString:@" "][1];
            
            NSString *strBegin = dict[@"classBeginTime"];
            NSString *strEnd = dict[@"classEndTime"];
            int currentMin = [[currentTime substringToIndex:2] intValue]*60+[[currentTime substringFromIndex:3] intValue];
            int beingMin = [[strBegin substringToIndex:2] intValue]*60+[[strBegin substringFromIndex:3] intValue];
            int endMin = [[strEnd substringToIndex:2] intValue]*60+[[strEnd substringFromIndex:3] intValue];
            int signBegin = [[sing1 substringToIndex:2] intValue]*60+[[sing1 substringFromIndex:3] intValue];
            int signEnd = [[sing2 substringToIndex:2] intValue]*60+[[sing2 substringFromIndex:3] intValue];
            if (isCheckin) {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"已签到成功"];
                return;
            }
            if (beingMin<=currentMin && currentMin<=endMin) {
                if (signBegin <= currentMin && currentMin <= signEnd) {
                    [[MainBoard sharedInstance] autoCheckin:dict];
                }else{
                    [[BeeUITipsCenter sharedInstance] presentMessageTips:@"签到时间已过"];
                }
                
            }else{
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"不在上课时间"];
            }
            
        }else{
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"不是上课日期"];
        }

    }
}

- (void)loadContent{
    [myScrollView removeFromSuperview];
    for (id element in myScrollView.subviews) {
        [element removeFromSuperview];
    }
    
    if (!myScrollView) {
        myScrollView = [BeeUIScrollView spawn];
        myScrollView.frame = self.bounds;
    }
    
    [self addSubview:myScrollView];
    
    int countLession = 12;
    NSMutableDictionary *dictLast = [self.arrayCourse lastObject];
    int lastLession = [dictLast[@"classNumEnd"] integerValue];
    if (lastLession>countLession) {
        countLession = lastLession;
    }
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString *currentTime = [dateFormatter2 stringFromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (int i = 0; i < countLession; i++) {
        int indexLesson = i+1;
        NSString *strIndex = indexLesson<10?[NSString stringWithFormat:@"0%d",indexLesson]:[NSString stringWithFormat:@"%d",indexLesson];
        indexLabel[i] = [BaseLabel initLabel:strIndex font:FONT(15) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        indexLabel[i].frame = CGRectMake(0, 60*i, 35, 60);
        indexLabel[i].backgroundColor = RGB(186, 186, 186);
        [myScrollView addSubview:indexLabel[i]];
        
        
    }
    
    for (int j = 0; j < _arrayCourse.count; j++) {
        NSMutableDictionary *dictSchedData = _arrayCourse[j];
        dic = [NSMutableDictionary dictionaryWithDictionary:dictSchedData];
        int begin = [dictSchedData[@"classNumBegin"] intValue]-1;
        int num = [dictSchedData[@"classNumEnd"] intValue]-begin;
        
        NSString *strDay = dictLast[@"teachTime"];
        
        if ([strDay isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
            NSString *strBegin = dictSchedData[@"classBeginTime"];
            NSString *strEnd = dictSchedData[@"classEndTime"];
            int currentMin = [[currentTime substringToIndex:2] intValue]*60+[[currentTime substringFromIndex:3] intValue];
            int beingMin = [[strBegin substringToIndex:2] intValue]*60+[[strBegin substringFromIndex:3] intValue];
            int endMin = [[strEnd substringToIndex:2] intValue]*60+[[strEnd substringFromIndex:3] intValue];
            
            if (beingMin<=currentMin && currentMin<=endMin) {
                
                for (int i = 0; i < countLession; i++) {
                    indexLabel[i].backgroundColor = RGB(186, 186, 186);
                    if (i >= begin && i < begin+num) {
                        indexLabel[i].backgroundColor = HEX_RGB(0x4caf3f);
                    }
                }
            }
            
        }
    }
    
    if (_arrayCourse.count==0) {
        [self showRestView:CGRectMake(35, 0, self.width-35, 35*countLession)];
    }
    int index = 0;
    for (int i = 0; i < [self.arrayCourse count]; i++) {
        NSMutableDictionary *dictCourse = self.arrayCourse[i];
        int begin = [dictCourse[@"classNumBegin"] intValue];
        int end = [dictCourse[@"classNumEnd"] intValue];
        int num = [dictCourse[@"classNumEnd"] intValue]-begin;
        if (begin>index+1) {
            [self showRestView:CGRectMake(35, 60*index, self.width-35, 60*(begin-index-1))];
        }
        index = end;
        
        if (i == [_arrayCourse count]-1 && index<countLession) {
            [self showRestView:CGRectMake(35, 60*index, self.width-35, 60*(countLession-index))];
        }
        
        
        BeeUIButton *btn = [BeeUIButton spawn];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = RGB(166, 166, 166).CGColor;
        btn.frame = CGRectMake(35, 60*(begin-1), self.width-35, 60*(end-begin+1));
        [btn addSignal:ScheduleView.DETAIL forControlEvents:UIControlEventTouchUpInside object:dictCourse];
        [myScrollView addSubview:btn];
        

        BeeUIButton *imgCheckin = [BeeUIButton spawn];
        imgCheckin.frame = CGRectMake(5, btn.height/2-11, 30, 23);
        BOOL isCheckin = [dictCourse[@"signStatus"] boolValue];
        if (isCheckin) {
            imgCheckin.selected = YES;
        }
        [imgCheckin setImage:[UIImage imageNamed:@"btn_signIn"] forState:UIControlStateNormal];
        [imgCheckin setImage:[UIImage imageNamed:@"btn_signIn_sel"] forState:UIControlStateSelected];
       // imgCheckin.image = isCheckin?IMAGESTRING(@"btn_signIn_sel"):IMAGESTRING(@"btn_signIn");
        [imgCheckin addSignal:ScheduleView.SIGNIN forControlEvents:UIControlEventTouchUpInside object:dictCourse];
        [btn addSubview:imgCheckin];
        
        
        

        
        BeeUIButton *btnWrite = [BeeUIButton spawn];
        btnWrite.frame = CGRectMake(btn.width-90, btn.height/2.0-30, 40, 40);
        [btnWrite setImage:IMAGESTRING(@"write1") forState:UIControlStateNormal];
        [btnWrite addSignal:ScheduleView.WRITE forControlEvents:UIControlEventTouchUpInside object:dictCourse];
        [btn addSubview:btnWrite];
        BaseLabel *write = [BaseLabel initLabel:@"写笔记" font:FONT(12) color: RGBCOLOR(184, 212, 68)textAlignment:NSTextAlignmentLeft];
        write.frame = CGRectMake(btn.width-90+2, btn.height/2.0+7, btn.width- 25- 75, 20);
        [btn addSubview:write];
        
        BaseLabel *title = [BaseLabel initLabel:dictCourse[@"courseName"] font:FONT(15) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        title.frame = CGRectMake(40, btn.height/2.0-20, btn.width- 50- 75, 20);
        [btn addSubview:title];
        
        NSString *strDescription = [NSString stringWithFormat:@"%@老师",dictCourse[@"teacherName"]];//[NSString stringWithFormat:@"%@ %@ %@",dictCourse[@"teacherName"],dictCourse[@"classroomName"],dictCourse[@"courseType"]];
        BaseLabel *description = [BaseLabel initLabel:strDescription font:FONT(12) color:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
        description.frame = CGRectMake(title.left, btn.height/2.0, 60, 20);
        [btn addSubview:description];
        
        //CGFloat width = kStrWidth(dictCourse[@"classroomName"], .font, 20);
        BaseLabel *local = [BaseLabel initLabel:dictCourse[@"classroomName"] font:FONT(12) color:HEX_RGB(0x45b035) textAlignment:NSTextAlignmentLeft];
         CGFloat width = kStrWidth(dictCourse[@"classroomName"], local.font, 20);
        if (width <= 70) {
            local.frame = CGRectMake(description.right+5, description.top, width, 20);
        }else{
            local.frame = CGRectMake(description.right+5, description.top, 70, 20);
        }
        
        //local.frame = CGRectMake(local.left, local.top, kStrWidth(local.text, local.font, local.height), 20);
        [btn addSubview:local];
        
        BeeUIImageView *localIcon = [BeeUIImageView spawn];
        localIcon.frame = CGRectMake(local.right -10, local.top, 30, local.height);
        localIcon.image = IMAGESTRING(@"dibiao");
        [btn addSubview:localIcon];
        [local makeTappable:ScheduleView.LOCATION withObject:dictCourse];
        [localIcon makeTappable:ScheduleView.LOCATION withObject:dictCourse];
        
        
        [myScrollView setContentSize:CGSizeMake(self.width, btn.bottom)];
        
// 是否被授权点名
        if (dictCourse[@"signAssistantId"] && [dictCourse[@"signAssistantId"] isEqualToString:kUserInfo[@"id"]]) {
            BeeUIButton *btnAuth = [BeeUIButton spawn];
            btnAuth.frame = CGRectMake(btnWrite.right, 0, 40, 40);
            [btnAuth setImage:IMAGESTRING(@"teacher_checkin") forState:UIControlStateNormal];
            [btnAuth addSignal:ScheduleView.CHECKIN forControlEvents:UIControlEventTouchUpInside object:dictCourse];
            [btn addSubview:btnAuth];
            BaseLabel *checkIn = [BaseLabel initLabel:@"点名" font:FONT(12) color: RGBCOLOR(91, 138, 195)textAlignment:NSTextAlignmentLeft];
            checkIn.frame = CGRectMake(btnAuth.x+7, btn.height/2.0+7, btn.width- 25- 75, 20);
            [btn addSubview:checkIn];
           

        }
        
        
        
        
    }
    
    
//    int count = 2;
//    
//    BOOL isCurrent = YES;
//    BOOL isCheckin = YES;
//    
//    for (int i = 0; i < count; i++) {
//        BaseLabel *index = [BaseLabel initLabel:@"01" font:FONT(15) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
//        index.frame = CGRectMake(0, 35*i, 35, 35);
//        index.backgroundColor = isCurrent?RGB(58, 165, 40):RGB(186, 186, 186);
//        [myScrollView addSubview:index];
//    }
//    
//    
//    BeeUIButton *btn = [BeeUIButton spawn];
//    btn.frame = CGRectMake(35, 0, self.width-35, 35*count);
//    [btn addSignal:ScheduleView.DETAIL forControlEvents:UIControlEventTouchUpInside];
//    [myScrollView addSubview:btn];
    
    
    
    
}

- (void)showRestView:(CGRect)frame{
    NSTimeInterval t1 = [_selDate timeIntervalSinceNow];
    if (t1<-3600) {
        return;
    }

    
    UIView  *viFind = [[UIView alloc] initWithFrame:frame];
    viFind.backgroundColor = HEX_RGB(0xececec);
    [myScrollView addSubview:viFind];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:IMAGESTRING(@"fangzi")];
    icon.frame = CGRectMake(28, (viFind.height-icon.height)/2.0, icon.width, icon.height);
    [viFind addSubview:icon];
    
    BaseLabel *t = [BaseLabel initLabel:@"空挡啦！找个自习室去！" font:FONT(14) color:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
    t.frame = CGRectMake(icon.right+5, 0, 200, viFind.height);
    [viFind addSubview:t];
    
    BeeUIButton *btnSearch = [BeeUIButton spawn];
    btnSearch.frame = CGRectMake(viFind.width-90, 0, 40, viFind.height);
    [btnSearch setImage:IMAGESTRING(@"home_search") forState:UIControlStateNormal];
    [btnSearch addSignal:ScheduleView.SEARCH forControlEvents:UIControlEventTouchUpInside object:nil];
    [viFind addSubview:btnSearch];
}

@end
