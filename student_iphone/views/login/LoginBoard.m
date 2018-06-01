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
//  LoginBoard.m
//  ClassRoom
//
//  Created by he chao on 7/5/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "LoginBoard.h"
#import "FindPasswordBoard.h"
#import "AppealBoard.h"

#pragma mark -

@interface LoginBoard()
{
	//<#@private var#>
}
@end

@implementation LoginBoard
DEF_SIGNAL(DONE)
DEF_SIGNAL(FORGET)
DEF_SIGNAL(APPEAL)

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
    self.title = @"登录";
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

ON_SIGNAL2(LoginBoard, signal){
    if ([signal is:LoginBoard.DONE]) {
        //[self.stack pushBoard:[MainBoard sharedInstance] animated:YES];
        //comment by zhaojian 2015-08-12
        //BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/login.action"]].PARAM(@"phone",field[0].text).PARAM(@"password",field[1].text);
        //request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        //request.tag = 9527;
        
        
        //add by zhaojian 2015-08-12
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@", self.dictSchool[@"schoolServiceURL"],@"app/user/login.action"]].PARAM(@"phone", field[0].text).PARAM(@"password",field[1].text).PARAM(@"verificationType", self.dictSchool[@"verificationType"]).PARAM(@"verificationUrl", self.dictSchool[@"verificationUrl"]).PARAM(@"userLevel", self.dictUser[@"userLevel"]);
        [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在登陆"];
        request.tag = 9527;
        
    }
    else if ([signal is:LoginBoard.FORGET]) {
        FindPasswordBoard *board = [[FindPasswordBoard alloc] init];
        board.strPhone = field[0].text;
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:LoginBoard.APPEAL]) {
        AppealBoard *board = [[AppealBoard alloc] init];
        board.strPhone = field[0].text;
        board.strUid = self.dictUser[@"id"];
        [self.stack pushBoard:board animated:YES];
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
                switch (request.tag) {
                    case 9527:
                    {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLogin"];
                        [[NSUserDefaults standardUserDefaults] setObject:[json[@"result"] JSONString] forKey:@"userInfo"];
                        [[NSUserDefaults standardUserDefaults] setObject:json[@"downloadType"] forKey:@"downloadType"];
                        [self.stack pushBoard:[MainBoard sharedInstance] animated:YES];
                        [[MainBoard sharedInstance] getSignTime];
                        [[MessageRequest sharedInstance] setModel:NO];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                break;
            case 2:
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
    for (int i = 0; i < 2; i++) {
        
        field[i] = [[UITextField alloc] init];
        field[i].frame = CGRectMake(20, 20+50*i, 280, 35);
        field[i].layer.borderColor = [UIColor grayColor].CGColor;
        field[i].layer.cornerRadius = 3;
        field[i].layer.borderWidth = 0.5;
        field[i].delegate = self;
        field[i].contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:field[i]];
        
        BeeUIImageView *icon = [BeeUIImageView spawn];
        icon.frame = CGRectMake(0, 0, 35, 35);
        icon.image = i==0?IMAGESTRING(@"login1"):IMAGESTRING(@"login2");
        field[i].leftView = icon;
        field[i].leftViewMode = UITextFieldViewModeAlways;
        
    }
    
    if ([self.dictUser[@"phone"] isKindOfClass:[NSString class]]) {
        field[0].text = self.dictUser[@"phone"];
        //field[0].userInteractionEnabled = NO;
    }
    
    //field[1].text = @"123456";
    field[1].secureTextEntry = YES;
    
    BaseButton *btnVerify = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"登录" textColor:[UIColor whiteColor] font:FONT(24)];
    btnVerify.frame = CGRectMake(10, field[1].bottom+40, 300, 40);
    [btnVerify addSignal:LoginBoard.DONE forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnVerify];
    
    BaseLabel *lb = [BaseLabel initLabel:@"忘记密码" font:FONT(16) color:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    lb.frame = CGRectMake(200, btnVerify.bottom+20, 120, 25);
    [lb makeTappable:LoginBoard.FORGET];
    [self.view addSubview:lb];
    
    BaseLabel *lbAppeal = [BaseLabel initLabel:@"手机号占用" font:FONT(16) color:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    lbAppeal.frame = CGRectMake(10, btnVerify.bottom+20, 120, 25);
    [lbAppeal makeTappable:LoginBoard.APPEAL];
    [self.view addSubview:lbAppeal];
}

@end
