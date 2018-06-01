//
//  NewMessageBoard.m
//  student_iphone
//
//  Created by jyd on 16/1/14.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "NewMessageBoard.h"

@interface NewMessageBoard ()

@end

@implementation NewMessageBoard

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
        self.title = @"新消息提醒";
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
    [[NSUserDefaults standardUserDefaults] setBool:switchNotifition.on forKey:@"notifitionSwitch"];
    [[NSUserDefaults standardUserDefaults] setBool:switchMessage.on forKey:@"messageSwitch"];

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
    
    NSArray *arrayTitle = @[@"通知消息提醒",@"交流消息提醒"];
    for (int i = 0; i < 2; i++) {
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
                switchNotifition = switch1;
                switchNotifition.on =[[NSUserDefaults standardUserDefaults] boolForKey:@"notifitionSwitch"];
            }
                break;
            case 1:
            {
                switchMessage = switch1;
                switchMessage.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"messageSwitch"];
            }
                break;
                default:
                break;
        }
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
