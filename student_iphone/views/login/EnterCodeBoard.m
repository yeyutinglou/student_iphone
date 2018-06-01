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
//  EnterCodeBoard.m
//  Walker
//
//  Created by he chao on 14-5-11.
//    Copyright (c) 2014年 leon. All rights reserved.
//

#import "EnterCodeBoard.h"
#import "ResetPasswordBoard.h"

#pragma mark -

@implementation EnterCodeBoard
DEF_SIGNAL(NEXT)
DEF_SIGNAL(RESEND)

- (void)load
{
	[super load];
    count = 60;
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
        self.title = @"填写验证码";
        [self showNaviBar];
        [self showBackBtn];
        [self loadContent];
        
        [self sendCode];
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

ON_SIGNAL2( EnterCodeBoard, signal )
{
    if ([signal is:EnterCodeBoard.NEXT]) {
//        FindPasswordSuccessBoard *board = [[FindPasswordSuccessBoard alloc] init];
//        [self.stack pushBoard:board animated:YES];
        if (kStrTrim(field.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请输入验证码"];
            return;
        }
        [field resignFirstResponder];
        [self verifyCode];
    }
    else if ([signal is:EnterCodeBoard.RESEND]) {
        [field resignFirstResponder];
        [btnSend setTitle:@"60秒后点击重新发送验证码" forState:UIControlStateNormal];
        count = 60;
        [timer fire];
        
        [self sendCode];
    }
}

- (void)sendCode{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/send_sms.action"]].PARAM(@"phone",self.strPhone).PARAM(@"smsType",@"2").PARAM(@"sign",[[NSString stringWithFormat:@"%@%@",self.strPhone,kAppKey] MD5]);
    request.tag = 9527;
}

- (void)verifyCode{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/valid_sms.action"]].PARAM(@"phone",self.strPhone).PARAM(@"smsType",@"2").PARAM(@"validCode",kStrTrim(field.text));
    request.tag = 9528;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        //NETWORK_ERROR
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                if (request.tag == 9527) {
                    //[[BeeUITipsCenter sharedInstance] presentSuccessTips:@"发送验证码成功"];
                }
                else if (request.tag == 9528) {
                    ResetPasswordBoard *board = [[ResetPasswordBoard alloc] init];
                    board.strPhone = self.strPhone;
                    board.strCode = field.text;
                    [self.stack pushBoard:board animated:YES];
                }
                
            }
                break;
                
            default:
                [[BeeUITipsCenter sharedInstance] presentSuccessTips:json[@"ERRMSG"]];
                break;
        }
    }
}

- (void)loadContent{
    BeeUIImageView *note1 = [BeeUIImageView spawn];
    note1.frame = CGRectMake(32, 24, 256, 39);
    note1.image = IMAGESTRING(@"enter_code_note");
    [self.view addSubview:note1];
    
    field = [BeeUITextField spawn];
    field.frame = CGRectMake(32, note1.bottom+10, 245, 40);
    field.backgroundImage = IMAGESTRING(@"enter_code_input_bg");
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.maxLength = 11;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 68, 0)];
    field.font = FONT(15);
    //fieldPhone.placeholder = @"手机号";
    [self.view addSubview:field];
    
    BaseButton *btnCommit = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"下一步" textColor:[UIColor whiteColor] font:FONT(24)];
    btnCommit.frame = CGRectMake(field.left, field.bottom+20, 270, 40);
    [btnCommit addSignal:EnterCodeBoard.NEXT forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCommit];
    
    BeeUIImageView *note2 = [BeeUIImageView spawn];
    note2.frame = CGRectMake(32, btnCommit.bottom+20, 256, 32);
    note2.image = IMAGESTRING(@"enter_code_wait");
    [self.view addSubview:note2];
    
    btnSend = [BeeUIButton spawn];
    btnSend.frame = CGRectMake(77, note2.bottom+10, 167, 25);
    [btnSend setBackgroundImage:IMAGESTRING(@"resend_code_btn") forState:UIControlStateNormal];
    [btnSend setTitle:@"60秒后点击重新发送验证码" forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSend setTitleFont:FONT(12)];
    [btnSend addSignal:EnterCodeBoard.RESEND forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSend];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)countDown{
    count--;
    if (count==0) {
        [timer invalidate];
        [btnSend setTitle:@"点击重新发送验证码" forState:UIControlStateNormal];
        btnSend.userInteractionEnabled = YES;
    }
    else {
        [btnSend setTitle:[NSString stringWithFormat:@"%d秒后点击重新发送验证码",count] forState:UIControlStateNormal];
        btnSend.userInteractionEnabled = NO;
    }
}

@end
