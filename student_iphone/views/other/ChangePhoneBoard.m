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
//  ChangePhoneBoard.m
//  ClassRoom
//
//  Created by he chao on 14-7-17.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "ChangePhoneBoard.h"

#pragma mark -

@interface ChangePhoneBoard()
{
	//<#@private var#>
}
@end

@implementation ChangePhoneBoard
DEF_SIGNAL(DONE)
DEF_SIGNAL(CODE)
DEF_SIGNAL(HIDE)

- (void)load
{
    count = 60;
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    self.title = @"更换手机号";//@"更换📱";//
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

ON_SIGNAL2(ChangePhoneBoard, signal){
    if ([signal is:ChangePhoneBoard.DONE]) {
        if (field[0].text.length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入原密码"];
            return;
        }
        else if (field[1].text.length != 11) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入正确的手机号码"];
            return;
        }
        else if (field[2].text.length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入验证码"];
            return;
        }
        //[self.stack pushBoard:[MainBoard sharedInstance] animated:YES];
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/reset_phone.action"]].PARAM(@"phone",field[1].text).PARAM(@"id",kUserInfo[@"id"]).PARAM(@"password",field[0].text).PARAM(@"validCode",field[2].text);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9528;
        
        
    }
    else if ([signal is:ChangePhoneBoard.CODE]) {
        if (field[1].text.length != 11) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入正确的手机号码"];
            return;
        }
        if (count != 60) {
            return;
        }
        
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/send_sms.action"]].PARAM(@"phone",field[1].text).PARAM(@"smsType",@"3").PARAM(@"sign",[[NSString stringWithFormat:@"%@%@",field[1].text,kAppKey] MD5]);
        //request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9527;
    }
    else if ([signal is:ChangePhoneBoard.HIDE]){
        [field[0] resignFirstResponder];
        [field[1] resignFirstResponder];
        [field[2] resignFirstResponder];
    }
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
                switch (request.tag) {
                    case 9527:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"验证码发送成功"];
                        count = 60;
                        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
                    }
                        break;
                    case 9528:
                    {
                        NSMutableDictionary *dictUser = kUserInfo;
                        [dictUser setObject:field[1].text forKey:@"phone"];
                        [[NSUserDefaults standardUserDefaults] setObject:[dictUser JSONString] forKey:@"userInfo"];
                        
                        [BeeUIAlertView showMessage:@"更改手机号成功" cancelTitle:@"确定"];
                        
                        [self.stack popBoardAnimated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
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

//在平台中写入手机号
//add by dyw
-(void)creatPhoneNum{
    //    http://192.168.11.48:88/ve/qxktservices/qxkt.shtml?method=boundMobileStu&stuNo=1111&phone=15111112222
    BeeHTTPRequest *request = [self POST:@"http://192.168.11.48:88/ve/qxktservices/qxkt.shtml"].PARAM(@"method",@"boundMobileStu").PARAM(@"stuNo",kUserInfo[@"studentNo"]).PARAM(@"phone",field[0].text);
    request.tag = 625;
}
- (void)loadContent{
    [self.view makeTappable:ChangePhoneBoard.HIDE];
    //BOOL isTeacher = YES;
    NSArray *titles = @[@"原密码:",@"手机:",@"验证码:"];
    NSArray *widths = @[@"235",@"120",@"65"];
    for (int i = 0; i < 3; i++) {
        BaseLabel *lb = [BaseLabel initLabel:titles[i] font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        lb.frame = CGRectMake(20, 20+45*i, 100, 30);
        [self.view addSubview:lb];
        
        field[i] = [BeeUITextField spawn];//[[UITextField alloc] init];
        field[i].frame = CGRectMake(75, lb.top, [widths[i] floatValue], 30);
        field[i].layer.borderColor = [UIColor grayColor].CGColor;
        field[i].layer.cornerRadius = 3;
        field[i].layer.borderWidth = 0.5;
        //field[i].delegate = self;
        field[i].contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:field[i]];
    }
    
    field[0].secureTextEntry = YES;
    field[1].maxLength = 11;
    field[1].keyboardType = UIKeyboardTypeNumberPad;
    field[2].keyboardType = UIKeyboardTypeNumberPad;
    
    BaseButton *btnCode = [BaseButton spawn];
    btnCode.frame = CGRectMake(200, 63, 110, 35);
    btnCode.backgroundColor = RGB(58, 164, 40);
    btnCode.layer.cornerRadius = 3;
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnCode addSignal:ChangePhoneBoard.CODE forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCode];
    
    time = [BaseLabel initLabel:@"60" font:FONT(12) color:[UIColor redColor] textAlignment:NSTextAlignmentRight];
    time.frame = CGRectMake(145, 110, 25, 30);
    [self.view addSubview:time];
    
    BaseLabel *lb2 = [BaseLabel initLabel:@"秒后点击重新发送验证码" font:time.font color:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
    lb2.frame = CGRectMake(time.right+2, time.top, 200, time.height);
    [self.view addSubview:lb2];
    
    BaseButton *btnVerify = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"完 成" textColor:[UIColor whiteColor] font:FONT(24)];
    btnVerify.frame = CGRectMake(10, 180, 300, 40);
    [btnVerify addSignal:ChangePhoneBoard.DONE forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnVerify];
}

- (void)countDown{
    count--;
    if (count>=0) {
        time.text = [NSString stringWithFormat:@"%d",count];
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
    }
    else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(countDown) object:nil];
        count = 60;
        time.text = @"60";
    }
}

@end
