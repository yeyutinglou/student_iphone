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
//  ChangePasswordBoard.m
//  Walker
//
//  Created by he chao on 14-6-10.
//  Copyright (c) 2014年 leon. All rights reserved.
//

#import "ChangePasswordBoard.h"

#pragma mark -

@interface ChangePasswordBoard()
{
	//<#@private var#>
}
@end

@implementation ChangePasswordBoard
DEF_SIGNAL(SET)

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
        self.title = @"修改密码";
        
        [self loadContent];
        [self showBackBtn];
        [self showNaviBar];
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

ON_SIGNAL2( ChangePasswordBoard, signal )
{
    if ([signal is:ChangePasswordBoard.SET]) {
        if (kStrTrim(field[0].text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请输入旧密码"];
            return;
        }
        if (kStrTrim(field[1].text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请输入新密码"];
            return;
        }
        else if (kStrTrim(field[2].text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请输入确认密码"];
            return;
        }
        else if (![kStrTrim(field[1].text) isEqualToString:kStrTrim(field[2].text)]){
            [[BeeUITipsCenter sharedInstance] presentFailureTips:@"两次密码输入不一致"];
            return;
        }
        
        [field[0] resignFirstResponder];
        [field[1] resignFirstResponder];
        [field[2] resignFirstResponder];
        
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/upd_user_pwd.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"oldPassword",kStrTrim(field[0].text)).PARAM(@"newPassword",kStrTrim(field[1].text)).PARAM(@"confirmPwd",kStrTrim(field[2].text));
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9527;
        //        return;
        //        ResetPasswordSuccessBoard *board = [[ResetPasswordSuccessBoard alloc] init];
        //        [self.stack pushBoard:board animated:YES];
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
                [self.stack popBoardAnimated:YES];
                [BeeUIAlertView showMessage:@"修改密码成功" cancelTitle:@"确定"];
//                ResetPasswordSuccessBoard *board = [[ResetPasswordSuccessBoard alloc] init];
//                [self.stack pushBoard:board animated:YES];
                //[[BeeUITipsCenter sharedInstance] presentMessageTips:@"修改密码成功"];
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
    [self.view addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)]];
    BeeUIImageView *imgBg = [BeeUIImageView spawn];
    imgBg.frame = CGRectMake(25, 20, 270, 122);
    imgBg.image = IMAGESTRING(@"change_pwd_bg");
    imgBg.userInteractionEnabled = YES;
    [self.view addSubview:imgBg];
    for (int i = 0; i < 3; i++) {
        field[i] = [BeeUITextField spawn];
        field[i].frame = CGRectMake(85, 40*i, 180, 40);
        field[i].contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field[i].clearButtonMode = UITextFieldViewModeWhileEditing;
        field[i].font = FONT(15);
        field[i].secureTextEntry = YES;
        [imgBg addSubview:field[i]];
    }
    
    BaseButton *btnOK = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"确 定" textColor:[UIColor whiteColor] font:FONT(24)];
    btnOK.frame = CGRectMake(imgBg.left, imgBg.bottom+30, 270, 40);
    [btnOK addSignal:ChangePasswordBoard.SET forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOK];
}

@end