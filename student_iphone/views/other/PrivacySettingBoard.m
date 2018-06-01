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
//  PrivacySettingBoard.m
//  Walker
//
//  Created by he chao on 3/25/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "PrivacySettingBoard.h"

#pragma mark -

@implementation PrivacySettingBoard

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
        [self showNaviBar];
        [self loadContent];
        [self showBackBtn];
        self.title = @"隐私";
        [self showBarButton:UINavigationBar.BARBUTTON_RIGHT title:@"完成"];
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
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/upd_user_auth.action"]].PARAM(@"friendAuth",switchFriend.on?@"1":@"0").PARAM(@"searchAuth",switchSearch.on?@"1":@"0").PARAM(@"noteAuth",switchNote.on?@"1":@"0").PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
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
                [[BeeUITipsCenter sharedInstance] presentSuccessTips:@"操作成功"];
                NSMutableDictionary *dictUser = kUserInfo;
                [dictUser setObject:switchSearch.on?@"1":@"0" forKey:@"searchAuth"];
                [dictUser setObject:switchFriend.on?@"1":@"0" forKey:@"friendAuth"];
                [dictUser setObject:switchNote.on?@"1":@"0" forKey:@"noteAuth"];
                [[NSUserDefaults standardUserDefaults] setObject:[dictUser JSONString] forKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.stack popBoardAnimated:YES];
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


ON_SIGNAL2( PrivacySettingBoard, signal )
{
//    if ([signal is:AccountSafeBoard.RESET]) {
//        ResetPasswordBoard *board = [[ResetPasswordBoard alloc] init];
//        [self.stack pushBoard:board animated:YES];
//    }
}

- (void)loadContent{
    myScrollView = [BeeUIScrollView spawn];
    myScrollView.frame = self.viewBound;//CGRectMake(0, 0, self.viewWidth, self.viewHeight-44);
    myScrollView.scrollEnabled = NO;
    [self.view addSubview:myScrollView];
    
    NSArray *arrayTitle = @[@"加我为朋友时需要验证",@"可通过手机号搜索到我",@"笔记是否公开"];
    for (int i = 0; i < 3; i++) {
        BaseButton *btn = [BaseButton initBaseBtn:IMAGESTRING(@"setting_btn") highlight:IMAGESTRING(@"setting_btn_pre")];
        btn.frame = CGRectMake(10, 10+80*i, 300, 60);
        [myScrollView addSubview:btn];
        
        BaseLabel *label = [BaseLabel initLabel:arrayTitle[i] font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(20, 0, 200, 60);
        [btn addSubview:label];
        
        btn.userInteractionEnabled = YES;
        
        BeeUISwitch *switch1 = [BeeUISwitch spawn];
        switch1.frame = CGRectMake(290-switch1.width, (60-switch1.height)/2.0, switch1.width, switch1.height);
        switch1.on = YES;
        [btn addSubview:switch1];
        
        switch (i) {
            case 0:
            {
                switchFriend = switch1;
                switchFriend.on = [kUserInfo[@"friendAuth"] boolValue];
                //btn.frame = CGRectMake(10, label1.height, 300, 60);
            }
                break;
            case 1:
            {
                switchSearch = switch1;
                switchSearch.on = [kUserInfo[@"searchAuth"] boolValue];
                //btn.frame = CGRectMake(btn.left, 80+label1.height, btn.width, btn.height);
            }
                break;
            case 2:
            {
                switchNote = switch1;
                switchNote.on = [kUserInfo[@"noteAuth"] boolValue];
            }
                break;
                
            default:
                break;
        }
    }

}

@end
