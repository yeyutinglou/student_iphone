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
//  ResetPasswordSuccessBoard.m
//  Walker
//
//  Created by he chao on 3/12/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "ResetPasswordSuccessBoard.h"

#pragma mark -

@implementation ResetPasswordSuccessBoard
DEF_SIGNAL(LOGIN)

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
        self.view.backgroundColor = RGB(242, 242, 242);
        self.title = @"重置密码";
        [self showBackBtn];
        
        [self loadContent];
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
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( ResetPasswordSuccessBoard, signal )
{
    if ([signal is:ResetPasswordSuccessBoard.LOGIN]) {
        //[self.stack popToBoard:self.stack.boards[2] animated:YES];
        //self.stack.boards
        //[self.stack popToFirstBoardAnimated:YES];
        [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在登录"];
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/login.action"]].PARAM(@"phone",_strPhone).PARAM(@"password",_strPassword);
        //request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9527;
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
                        BeeUIBoard *b = self.stack.boards[0];
                        [self.stack popToFirstBoardAnimated:NO];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLogin"];
                        [[NSUserDefaults standardUserDefaults] setObject:[json[@"result"] JSONString] forKey:@"userInfo"];
                        [b.stack pushBoard:[MainBoard sharedInstance] animated:YES];
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
    BaseLabel *lb = [BaseLabel initLabel:@"重置密码成功!" font:BOLDFONT(30) color:RGB(241, 67, 40) textAlignment:NSTextAlignmentCenter];
    lb.frame = CGRectMake(0, 64+35, self.viewWidth, 30);
    [self.view addSubview:lb];
    
    BaseButton *btnLogin = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"直接登录" textColor:[UIColor whiteColor] font:FONT(24)];
    btnLogin.frame = CGRectMake(30, lb.bottom+30, 270, 40);
    [btnLogin addSignal:ResetPasswordSuccessBoard.LOGIN forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
}
@end
