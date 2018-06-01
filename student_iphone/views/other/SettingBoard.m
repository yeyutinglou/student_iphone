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
//  SettingBoard.m
//  ClassRoom
//
//  Created by he chao on 14-6-25.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "SettingBoard.h"
#import "FeedbackBoard.h"
#import "PrivacySettingBoard.h"
#import "AccountSafeBoard.h"
#import "AboutBoard.h"
#import "NewMessageBoard.h"
#pragma mark -

@interface SettingBoard()
{
	//<#@private var#>
}
@end

@implementation SettingBoard
DEF_SIGNAL(SAFE)
DEF_SIGNAL(PRIVACY)
DEF_SIGNAL(FEEDBACK)
DEF_SIGNAL(LOGOUT)
DEF_SIGNAL(ALERT)
DEF_SIGNAL(MESSAGE)
DEF_SIGNAL(ABOUT)
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
    [self showBackBtn];
    self.title = @"设置";
    [self loadContent];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //不显示帐号与安全
    if ([kSchoolVerificationType isEqualToString:@"1"]) {
        btnAccount.hidden = YES;
        [myScrollView setContentOffset:CGPointMake(0, btnAccount.height)];
        myScrollView.scrollEnabled = NO;
    }
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
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    
}

ON_SIGNAL2( SettingBoard, signal )
{
    if ([signal is:SettingBoard.SAFE]) {
        AccountSafeBoard *board = [[AccountSafeBoard alloc] init];
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:SettingBoard.PRIVACY]) {
        PrivacySettingBoard *board = [[PrivacySettingBoard alloc] init];
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:SettingBoard.FEEDBACK]) {
        FeedbackBoard *board = [[FeedbackBoard alloc] init];
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:SettingBoard.MESSAGE]) {
        NewMessageBoard *board = [[NewMessageBoard alloc] init];
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:SettingBoard.ABOUT]){
        AboutBoard *board = [[AboutBoard alloc] init];
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:SettingBoard.ALERT]) {
        BeeUIAlertView *alertView = [BeeUIAlertView spawn];
        alertView.title = @"您确定要退出登录？";
        [alertView addCancelTitle:@"取消"];
        [alertView addButtonTitle:@"退出" signal:SettingBoard.LOGOUT];
        [alertView showInViewController:self];
    }
    else if ([signal is:SettingBoard.LOGOUT]) {
        [self.stack popToFirstBoardAnimated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasLogin"];
        return;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kBaseUrl,@"app/user/logout.action"]].PARAM(@"id",kUserInfo[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9527;
        [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在注销"];
    }
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        NETWORK_ERROR
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
                [self.stack popToFirstBoardAnimated:YES];
            }
                break;
            case 110:
            {
                //[[LoginBoard sharedInstance] autoLogin];
            }
                break;
            default:
            {
                switch ([json[@"ERRCODE"] intValue]) {
                    case 110:
                    {
                        //[[LoginBoard sharedInstance] autoLogin];
                    }
                        break;
                        
                    default:
                    {
                        [[BeeUITipsCenter sharedInstance] presentFailureTips:json[@"ERRMSG"]];
                    }
                        break;
                }
            }
                break;
        }
    }
}


- (void)loadContent{
    myScrollView = [BeeUIScrollView spawn];
    myScrollView.frame = self.viewBound;//CGRectMake(0, 0, self.viewWidth, self.viewHeight-44);
    [self.view addSubview:myScrollView];
    
    NSArray *arrayTitle = @[@"账号与安全",@"隐私",@"意见反馈",@"新消息提醒",@"关于轻新课堂"];
    for (int i = 0; i < 5; i++) {
        BaseButton *btn = [BaseButton initBaseBtn:IMAGESTRING(@"setting_btn") highlight:IMAGESTRING(@"setting_btn_pre")];
        btn.frame = CGRectMake(10, 0, 300, 60);
        [myScrollView addSubview:btn];
        
        BaseLabel *label = [BaseLabel initLabel:arrayTitle[i] font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(20, 0, 200, 60);
        [btn addSubview:label];
        
        switch (i) {
            case 0:
            {
                btnAccount = btn;
                btnAccount.frame = CGRectMake(btn.left, 10, btn.width, btn.height);
                [btnAccount addSignal:SettingBoard.SAFE forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 1:
            {
                btnPrivacy = btn;
                btnPrivacy.frame = CGRectMake(btn.left, btnAccount.bottom+20, btn.width, btn.height);
                [btnPrivacy addSignal:SettingBoard.PRIVACY forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 2:
            {
                btnFeedback = btn;
                btnFeedback.frame = CGRectMake(btn.left, btnPrivacy.bottom, btn.width, btn.height);
                [btnFeedback addSignal:SettingBoard.FEEDBACK forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 3:
            {
                btnMessageNote = btn;
                btnMessageNote.frame = CGRectMake(btn.left, btnFeedback.bottom, btn.width, btn.height);
                [btnMessageNote addSignal:SettingBoard.MESSAGE forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                case 4:
            {
                btnAbout = btn;
                btnAbout.frame = CGRectMake(btn.left, btnMessageNote.bottom, btn.width, btn.height);
                [btnAbout addSignal:SettingBoard.ABOUT forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
        
        BeeUIImageView *imgArrow = [BeeUIImageView spawn];
        imgArrow.frame = CGRectMake(btn.width-25, 0, 25, 60);
        imgArrow.image = IMAGESTRING(@"arrow");
        [btn addSubview:imgArrow];
    }
    
    btnLogout = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"退出登录" textColor:[UIColor whiteColor] font:FONT(24)];
    btnLogout.hidden = YES;
    btnLogout.frame = CGRectMake(10, btnMessageNote.bottom+20, 300, 40);
    [btnLogout addSignal:SettingBoard.ALERT forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:btnLogout];
}


@end
