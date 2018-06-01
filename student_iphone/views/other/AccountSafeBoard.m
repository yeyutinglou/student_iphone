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
//  AccountSafeBoard.m
//  Walker
//
//  Created by he chao on 3/25/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "AccountSafeBoard.h"
#import "ChangePasswordBoard.h"
#import "ChangePhoneBoard.h"

#pragma mark -

@implementation AccountSafeBoard
DEF_SIGNAL(RESET)
DEF_SIGNAL(CHANGE)

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
        self.title = @"账号与安全";
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
        phone.text = kUserInfo[@"phone"];
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

ON_SIGNAL2( AccountSafeBoard, signal )
{
    if ([signal is:AccountSafeBoard.RESET]) {
        ChangePasswordBoard *board = [[ChangePasswordBoard alloc] init];
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:AccountSafeBoard.CHANGE]) {
        ChangePhoneBoard *board = [[ChangePhoneBoard alloc] init];
        [self.stack pushBoard:board animated:YES];
    }
}

- (void)loadContent{
    myScrollView = [BeeUIScrollView spawn];
    myScrollView.frame = self.viewBound;//CGRectMake(0, 0, self.viewWidth, self.viewHeight-44);
    [self.view addSubview:myScrollView];
    
    NSArray *arrayTitle = @[@"手机号",@"更改手机号",@"修改密码"];
    int count;
    if ([kSchoolVerificationType isEqualToString:@"1"]) {
        count = 2;
    }else{
        count = 3;
    }
    for (int i = 0; i < count; i++) {
        BaseButton *btn = [BaseButton initBaseBtn:IMAGESTRING(@"setting_btn") highlight:IMAGESTRING(@"setting_btn_pre")];
        btn.frame = CGRectMake(10, 0, 300, 60);
        [myScrollView addSubview:btn];
        
        BaseLabel *label = [BaseLabel initLabel:arrayTitle[i] font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(20, 0, 200, 60);
        [btn addSubview:label];
        
        switch (i) {
            case 0:
            {
                btn.userInteractionEnabled = NO;
                btn.frame = CGRectMake(10, 10, 300, 60);
                
                phone = [BaseLabel initLabel:kUserInfo[@"phone"] font:BOLDFONT(16) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
                phone.frame = CGRectMake(96, 0, 200, 60);
                [btn addSubview:phone];
            }
                break;
            case 1:
            {
                btn.frame = CGRectMake(btn.left, 90, btn.width, btn.height);
                [btn addSignal:AccountSafeBoard.CHANGE forControlEvents:UIControlEventTouchUpInside];
                
                BeeUIImageView *imgArrow = [BeeUIImageView spawn];
                imgArrow.frame = CGRectMake(btn.width-25, 0, 25, 60);
                imgArrow.image = IMAGESTRING(@"arrow");
                [btn addSubview:imgArrow];
            }
                break;
            case 2:
            {
               
                
                btn.frame = CGRectMake(btn.left, 170, btn.width, btn.height);
                [btn addSignal:AccountSafeBoard.RESET forControlEvents:UIControlEventTouchUpInside];
                
                BeeUIImageView *imgArrow = [BeeUIImageView spawn];
                imgArrow.frame = CGRectMake(btn.width-25, 0, 25, 60);
                imgArrow.image = IMAGESTRING(@"arrow");
                [btn addSubview:imgArrow];
            }
                break;
                
            default:
                break;
        }
    }

}

@end
