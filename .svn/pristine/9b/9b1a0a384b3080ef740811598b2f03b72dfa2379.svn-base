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
//  FindPasswordBoard.m
//  Walker
//
//  Created by he chao on 3/12/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "FindPasswordBoard.h"
//#import "FindPasswordSuccessBoard.h"
#import "EnterCodeBoard.h"

#pragma mark -

@implementation FindPasswordBoard
DEF_SIGNAL(COMMIT)

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
        self.title = @"找回密码";
        [self showNaviBar];
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

ON_SIGNAL2( FindPasswordBoard, signal )
{
    if ([signal is:FindPasswordBoard.COMMIT]) {
        if (fieldPhone.text.length!=11) {
            [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请输入正确的手机号码"];
            return;
        }
        EnterCodeBoard *board = [[EnterCodeBoard alloc] init];
        board.strPhone = fieldPhone.text;
        [self.stack pushBoard:board animated:YES];
    }
}

- (void)loadContent{
    fieldPhone = [BeeUITextField spawn];
    fieldPhone.frame = CGRectMake(25, 16, 271, 40);
    fieldPhone.backgroundImage = IMAGESTRING(@"find_password_input_bg");
    fieldPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    fieldPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    fieldPhone.maxLength = 11;
    fieldPhone.keyboardType = UIKeyboardTypeNumberPad;
    fieldPhone.leftViewMode = UITextFieldViewModeAlways;
    fieldPhone.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, 0)];
    fieldPhone.font = FONT(15);
    fieldPhone.text = self.strPhone;
    fieldPhone.userInteractionEnabled = NO;
    //fieldPhone.placeholder = @"手机号";
    [self.view addSubview:fieldPhone];
    
    BeeUIImageView *imgNote = [BeeUIImageView spawn];
    imgNote.frame = CGRectMake(fieldPhone.left, fieldPhone.bottom+15, fieldPhone.width, fieldPhone.height);
    imgNote.image = IMAGESTRING(@"find_password_note");
    [self.view addSubview:imgNote];

//    BeeUILabel *lb = [BeeUILabel spawn];
//    lb.frame = CGRectMake(25, fieldPhone.bottom+5, self.viewWidth-50, 0);
//    lb.numberOfLines = 2;
//    lb.font = FONT(12);
//    lb.textAlignment = NSTextAlignmentLeft;
//    lb.textColor = RGB(114, 114, 114);
//    lb.text = @"我们将您重置密码的链接以短信形式发送至此手机号码，打开链接修改后即可重新登录。";
//    CGSize sz = [lb.text sizeWithFont:lb.font byWidth:lb.width];
//    lb.frame = CGRectMake(lb.left, lb.top, lb.width, sz.height);
//    [self.view addSubview:lb];
    
    BaseButton *btnCommit = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"提 交" textColor:[UIColor whiteColor] font:FONT(24)];
    btnCommit.frame = CGRectMake(imgNote.left, imgNote.bottom+30, 270, 40);
    [btnCommit addSignal:FindPasswordBoard.COMMIT forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCommit];
}

@end
