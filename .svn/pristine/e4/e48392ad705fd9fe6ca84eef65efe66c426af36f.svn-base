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
//  BaseBoard.m
//  Walker
//
//  Created by he chao on 3/10/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "BaseBoard.h"
#import "SettingBoard.h"
#import "MyCheckinBoard.h"
#import "MyClassNoteBoard.h"
#import "CurriculumBoard.h"
#import "UserInfoBoard.h"
#import "StudentHomePageBoard.h"
#import "CurriculumBoard.h"
#import "PersonalCenterViewController.h"
#import "UdpSocketAirPlay.h"
//#import "PKBoard.h"
//#import "RankBoard.h"
//#import "FeetsBoard.h"
#import "chooseBuildingAndFloor.h"
#import "SocketData.h"
#import "AppDelegate.h"
#import "SingalLetonButton.h"
#pragma mark -

@interface BaseBoard()<chooseBuildingAndFloorDeledate>
@end

@implementation BaseBoard
DEF_SIGNAL(NAVI_BTN)
DEF_SIGNAL(HIDE_POPUP)
DEF_SIGNAL(PANEL)
DEF_SIGNAL(MY_INFO)
DEF_SIGNAL(MY_CHECKIN)
DEF_SIGNAL(MY_NOTE)
DEF_SIGNAL(MY_CLASS)
DEF_SIGNAL(SETTING)
DEF_SIGNAL(MY_CENTER)
- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [popupView removeFromSuperview];
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    [popupView removeFromSuperview];
    popupView = nil;
    
    NSMutableDictionary *dictUser = kUserInfo;
    
    if (!popupView) {
        popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        if (IOS6_OR_LATER) {
            [popupView makeTappable:BaseBoard.HIDE_POPUP];
        }
        
        popupView.backgroundColor = [UIColor clearColor];
        
        BeeUIImageView *imgPopup = [BeeUIImageView spawn];
        imgPopup.frame = CGRectMake(305-130, 0, 130, 259);
        imgPopup.image = IMAGESTRING(@"popup_student");
        imgPopup.userInteractionEnabled = YES;
        if (IOS6_OR_LATER)
            [imgPopup makeTappable:BaseBoard.PANEL];
        [popupView addSubview:imgPopup];
        
//        if (isTeacher) {
//            for (int i = 0; i < 3; i++) {
//                BeeUIImageView *imgIcon = [BeeUIImageView spawn];
//                imgIcon.frame = CGRectMake(0, 6+50*i, 50, 50);
//                [imgPopup addSubview:imgIcon];
//                
//                BaseLabel *label = [BaseLabel initLabel:@"" font:BOLDFONT(16) color:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
//                label.frame = CGRectMake(imgIcon.right, imgIcon.top, imgPopup.width-imgIcon.right, imgIcon.height);
//                [imgPopup addSubview:label];
//                
//                BeeUIButton *btn = [BeeUIButton spawn];
//                btn.frame = CGRectMake(0, imgIcon.top, imgPopup.width, imgIcon.height);
//                
//                [imgPopup addSubview:btn];
//                
//                switch (i) {
//                    case 0:
//                    {
//                        imgIcon.frame = CGRectMake(8, 6+8, 50-16, 50-16);
//                        imgIcon.contentMode = UIViewContentModeScaleToFill;
//                        [imgIcon setImageWithURL:kImage100(dictUser[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
//                        //imgIcon.image = IMAGESTRING(@"demo_icon1");
//                        label.text = dictUser[@"nickName"];
//                        [btn addSignal:BaseBoard.MY_INFO forControlEvents:UIControlEventTouchUpInside];
//                    }
//                        break;
//                    case 1:
//                    {
//                        imgIcon.image = IMAGESTRING(@"popup_myclass");
//                        label.text = @"我的课堂";
//                        [btn addSignal:BaseBoard.MY_CLASS forControlEvents:UIControlEventTouchUpInside];
//                    }
//                        break;
//                    case 2:
//                    {
//                        imgIcon.image = IMAGESTRING(@"popup_setting");
//                        label.text = @"设置";
//                        [btn addSignal:BaseBoard.SETTING forControlEvents:UIControlEventTouchUpInside];
//                    }
//                        break;
//                        
//                    default:
//                        break;
//                }
//            }
//        }
//        else {
            for (int i = 0; i < 5; i++) {
                BeeUIImageView *imgIcon = [BeeUIImageView spawn];
                imgIcon.frame = CGRectMake(0, 6+50*i, 50, 50);
                [imgPopup addSubview:imgIcon];
                
                BaseLabel *label = [BaseLabel initLabel:@"" font:BOLDFONT(16) color:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
                label.frame = CGRectMake(imgIcon.right, imgIcon.top, imgPopup.width-imgIcon.right, imgIcon.height);
                [imgPopup addSubview:label];
                
                BeeUIButton *btn = [BeeUIButton spawn];
                btn.frame = CGRectMake(0, imgIcon.top, imgPopup.width, imgIcon.height);
                
                [imgPopup addSubview:btn];
                
                switch (i) {
                    case 0:
                    {
                        imgIcon.frame = CGRectMake(8, 6+8, 50-16, 50-16);
                        imgIcon.contentMode = UIViewContentModeScaleToFill;
                        [imgIcon setImageWithURL:kImage100(dictUser[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                        label.text = dictUser[@"nickName"];
                        [btn addSignal:BaseBoard.MY_INFO forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    case 1:
                    {
                        imgIcon.image = IMAGESTRING(@"popup_checkin");
                        label.text = @"我的签到";
                        [btn addSignal:BaseBoard.MY_CHECKIN forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    case 2:
                    {
                        imgIcon.image = IMAGESTRING(@"popup_note");
                        label.text = @"我的笔记";
                        [btn addSignal:BaseBoard.MY_NOTE forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    case 3:
                    {
                        imgIcon.image = IMAGESTRING(@"popup_setting");
                        label.text = @"设置";
                        [btn addSignal:BaseBoard.SETTING forControlEvents:UIControlEventTouchUpInside];
                    }
                        break;
                    case 4:
                    {
                        imgIcon.image = IMAGESTRING(@"btn_center");
                        label.text = @"个人中心";
                        [btn addSignal:BaseBoard.MY_CENTER forControlEvents:UIControlEventTouchUpInside];
                        
                    }
                        break;

                    default:
                        break;
                }
            }
//        }
        
    }
    [self.view addSubview:popupView];
}

ON_SIGNAL2( BaseBoard, signal )
{
    if ([signal is:BaseBoard.HIDE_POPUP]) {
        [popupView removeFromSuperview];
    }
    else if ([signal is:BaseBoard.MY_INFO]) {
        UserInfoBoard *board = [[UserInfoBoard alloc] init];
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:BaseBoard.MY_CHECKIN]) {
        MyCheckinBoard *board = [[MyCheckinBoard alloc] init];
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:BaseBoard.MY_NOTE]) {
//        MyClassNoteBoard *board = [[MyClassNoteBoard alloc] init];
        StudentHomePageBoard *board = [[StudentHomePageBoard alloc] init];
        board.dictUser = kUserInfo;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:BaseBoard.MY_CLASS]) {
        CurriculumBoard *board = [[CurriculumBoard alloc] init];
        board.dictUser = kUserInfo;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:BaseBoard.SETTING]) {
        SettingBoard *board = [[SettingBoard alloc] init];
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }else if ([signal is:BaseBoard.MY_CENTER]){
        PersonalCenterViewController *personalCenter = [[PersonalCenterViewController alloc] init];
        [[MainBoard sharedInstance].stack pushViewController:personalCenter animated:YES];
        
    }
}

- (void)showNaviBar
{
    if (IOS7_OR_LATER)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    self.view.backgroundColor = RGB(242, 242, 242);
    [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
    //[BeeUINavigationBar setBackgroundImage:[IMAGESTRING(@"navi_bar") stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    
    //2016-05-06
    [self showMenuBtn];
}

ON_NOTIFICATION(notification){
    if ([notification is:kBadge]) {
        [self setBadgeStatus];
    }
}

- (void)setBadgeStatus{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"pkBadge"] boolValue]) {
        imgPkBadge.hidden = NO;
    }
    else {
        imgPkBadge.hidden = YES;
    }
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pkBadge"];
}

- (void)showBackBtn{
    [self showBarButton:UINavigationBar.BARBUTTON_LEFT image:IMAGESTRING(@"navi_back")];
    
   

}

-(void)btnAirplay:(UIButton *)sender
{
    [self getSocketInfoJudgeTime];
}

- (void)showMenuBtn
{
    ///在keywindow上面加载投屏按钮
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"]) {
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
         if (appDelegate.btn == nil)
        {
            appDelegate.btn = [SingalLetonButton  shareInstance];
             self.btnAirPlay = appDelegate.btn;
            appDelegate.btn.backgroundColor = [UIColor clearColor];
            [appDelegate.btn setFrame:CGRectMake(kWidth- 80- 25, 30, 30, 28)];
            [appDelegate.btn setImage:[UIImage imageNamed:@"btnAirPlay"] forState: UIControlStateNormal];
            [appDelegate.btn setImage:[UIImage imageNamed:@"btnAirPlay_select"] forState: UIControlStateSelected];
            [self.btnAirPlay addTarget:self action:@selector(btnAirplay:) forControlEvents:UIControlEventTouchUpInside];
            [[UIApplication sharedApplication].keyWindow addSubview:appDelegate.btn];
        }
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:appDelegate.btn];
        
    }

    
}

- (void)showNaviBtns{
    [self observeNotification:kBadge];
    
    NSArray *arrayIcon = @[@"navi_chart",@"navi_rank",@"navi_pk"];
    for (int i = 0; i < 3; i++) {
        if (!btnNavi[i]) {
            btnNavi[i] = [BeeUIButton spawn];
            btnNavi[i].tag = i;
            btnNavi[i].frame = CGRectMake(168+48*i, 0, 44, 44);
            [btnNavi[i] setImage:IMAGESTRING(arrayIcon[i]) forState:UIControlStateNormal];
            [btnNavi[i] addSignal:BaseBoard.NAVI_BTN forControlEvents:UIControlEventTouchUpInside object:btnNavi[i]];

        }
        [self.navigationController.navigationBar addSubview:btnNavi[i]];
    }
    
    if (!imgPkBadge) {
        imgPkBadge= [BeeUIImageView spawn];
        imgPkBadge.frame = CGRectMake(32, 5, 8, 8);
        imgPkBadge.image = IMAGESTRING(@"friend_new");
    }
    [btnNavi[2] addSubview:imgPkBadge];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"pkBadge"] boolValue]) {
        imgPkBadge.hidden = NO;
    }
    else {
        imgPkBadge.hidden = YES;
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}


- (void)closeAnimating{
    [[BeeUITipsCenter sharedInstance] dismissTips];
    if (myTableView) {
//        [myTableView.pullToRefreshView stopAnimating];
//        [myTableView.infiniteScrollingView stopAnimating];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)getSocketInfoJudgeTime
{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/service/get_socket_info.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 1;
    
    JYDLog(@"%@/app/service/get_socket_info.action&id?%@", kSchoolUrl, kUserInfo[@"id"]);
    
    [[BeeUITipsCenter sharedInstance] presentMessageTips:@"已发送"];
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        if (request.tag == 1)
        {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"未能成功发送认证信息!"];   
        }
    }
    else if (request.succeed)
    {
        id json = [request.responseString mutableObjectFromJSONString];
        JYDLog(@"BaseBoard----%@",json);
        switch ([json[@"STATUS"] intValue])
        {
            case 0:
            {
                switch (request.tag)
                {
                    case 1:
                    {
                        NSLog(@"%@",json[@"result"][@"courseSchedId"]);
                        if ([json[@"result"][@"courseSchedId"] intValue]==0) {
                           ///add by liuhui
                            if (self.btnAirPlay.selected)
                            {
                                [[UdpSocketAirPlay sharedInstance] stopScreen];
                                self.btnAirPlay.selected = NO;
                                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"取消认证信息发送成功"];
                                return;
                            }
                            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                            appDelegate.coverView = [[UIView alloc] init];
                            appDelegate.coverView.frame = self.bounds;
                            appDelegate.coverView.backgroundColor = RGB(193, 193, 193);
                            appDelegate.coverView.alpha = 0.7;
                            appDelegate.coverView.userInteractionEnabled = YES;
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBegin:)];
                            [appDelegate.coverView addGestureRecognizer:tap];
                            [[UIApplication sharedApplication].keyWindow addSubview:appDelegate.coverView];
                            
                            
                            appDelegate.chooseView = [[chooseBuildingAndFloor alloc]init];
                            appDelegate.chooseView.deledate = self;
                            appDelegate.chooseView.view.backgroundColor = [UIColor whiteColor];
                            appDelegate.chooseView.view.frame = CGRectMake(30, 100, 260, 320);
                            appDelegate.chooseView.view.layer.cornerRadius = 10;
                            appDelegate.chooseView.view.clipsToBounds = YES;
                            [[UIApplication sharedApplication].keyWindow addSubview:appDelegate.chooseView.view];
                            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:appDelegate.chooseView.view];
//                            [BeeUIAlertView showMessage:@"您现在不在上课时间" cancelTitle:@"确定"];
                            return;
                    }
                else{
                        if (self.btnAirPlay.selected)
                        {
                            [[UdpSocketAirPlay sharedInstance] stopScreen];
                            self.btnAirPlay.selected = NO;
                            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"取消认证信息发送成功"];
                        }
                        else
                        {
                            [[UdpSocketAirPlay sharedInstance] setupSocketWithIp:[SocketData sharedInstance].dictSocket[@"classRoomGateWay"]];
                            [[UdpSocketAirPlay sharedInstance] sureSendMsgWithIp:[SocketData sharedInstance].dictSocket[@"classRoomGateWay"]];
                            self.btnAirPlay.selected = YES;
                            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"投屏认证信息发送成功"];
                        }
                    }
                }
                        break;
                        ////add by liuhui
                    case 2:
                    {
                        //// 根据classroomId获取互动网关信息
                        NSString *ip = json[@"result"][@"deviceIp"];
                        [[UdpSocketAirPlay sharedInstance] setupSocketWithIp:ip];
                        [[UdpSocketAirPlay sharedInstance] sureSendMsgWithIp:ip];
                        self.btnAirPlay.selected = YES;
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"投屏认证信息发送成功"];
                    }
                        break;

                    default:
                        break;
                }
            }
                break;
        }
    }
}

////chooseBuildingAndFloorDeledate的代理方法
-(void)sureBtnClickWithClassroomId:(NSString *)classroomId{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.coverView removeFromSuperview];
    [appDelegate.chooseView.view removeFromSuperview];
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/zhijiao/get_gateway_by_room_id.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"roomId",classroomId);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 2;
    [self handleRequest:request];
}
///点击cover退出选择界面
-(void)tapBegin:(UITapGestureRecognizer *)tap{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.coverView) {
        [appDelegate.coverView removeFromSuperview];
        appDelegate.coverView = nil;
    }
    if (appDelegate.chooseView.view) {
        [appDelegate.chooseView.view removeFromSuperview];
        appDelegate.chooseView.view = nil;
    }
}

@end
