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
//  AppealBoard.m
//  ClassRoom
//
//  Created by he chao on 14-7-17.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "AppealBoard.h"

#pragma mark -

@interface AppealBoard()
{
	//<#@private var#>
}
@end

@implementation AppealBoard
DEF_SIGNAL(DONE)
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
    [self showBackBtn];
    self.title = @"申诉";
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

ON_SIGNAL2(AppealBoard, signal) {
    if ([signal is:AppealBoard.DONE]) {
        if (kStrTrim(textView[1].text).length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请填写申诉内容"];
            return;
        }
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/add_appeal.action"]].PARAM(@"phone",_strPhone).PARAM(@"userId",_strUid).PARAM(@"content",textView[1].text);
        //request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9527;
    }
    else if ([signal is:AppealBoard.HIDE]){
        [textView[1] resignFirstResponder];
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
                        [BeeUIAlertView showMessage:@"您的申诉内容已提交成功，等待管理员审核" cancelTitle:@"确定"];
                        [self.stack popBoardAnimated:YES];
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
        BaseLabel *lb = [BaseLabel initLabel:i==0?@"手机号:":@"申诉理由:" font:FONT(15) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        lb.frame = CGRectMake(20, 20+46*i, 80, 36);
        [self.view addSubview:lb];
        
        textView[i] = [BeeUITextView spawn];
        textView[i].frame = CGRectMake(105, i==0?21:70, 195, i==0?40:100);
        textView[i].font = FONT(15);
        textView[i].layer.borderWidth = 0.5;
        textView[i].layer.cornerRadius = 4;
        [self.view addSubview:textView[i]];
    }
    
    textView[0].text = self.strPhone;
    textView[0].userInteractionEnabled = NO;
    
    BaseLabel *content = [BaseLabel initLabel:@"请正确填写自己的手机号和申诉理由，以供管理员审核。理由越充分，越能帮助管理员审核哦。审核成功，管理员将及时与您联系。" font:FONT(13) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    content.frame = CGRectMake(20, textView[1].bottom, 280, 80);
    [self.view addSubview:content];
    
    BaseButton *btnVerify = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"确定申诉" textColor:[UIColor whiteColor] font:FONT(24)];
    btnVerify.frame = CGRectMake(10, content.bottom, 300, 40);
    [btnVerify addSignal:AppealBoard.DONE forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnVerify];
    
    [self.view makeTappable:AppealBoard.HIDE];
}

@end
