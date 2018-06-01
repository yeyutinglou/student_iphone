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
//  FeedbackBoard.m
//  Walker
//
//  Created by he chao on 3/25/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "FeedbackBoard.h"

#pragma mark -

@implementation FeedbackBoard
DEF_SIGNAL(HIDE)

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
        isHide = NO;
        [self showNaviBar];
        [self loadContent];
        [self showBackBtn];
        self.title = @"意见反馈";
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
    if (kStrTrim(myTextView.text).length==0) {
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请您输入意见反馈"];
        return;
    }
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"/app/user/add_feed_back.action"]].PARAM(@"content",myTextView.text).PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

ON_SIGNAL2(FeedbackBoard, signal){
    if ([signal is:FeedbackBoard.HIDE]) {
        if (isHide) {
            isHide = NO;
            [myTextView becomeFirstResponder];
        }
        else {
            isHide = YES;
            [myTextView resignFirstResponder];
        }
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
                [[BeeUITipsCenter sharedInstance] presentSuccessTips:@"提交成功,感谢您的支持"];
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
//                switch ([json[@"ERRCODE"] intValue]) {
//                    case 110:
//                    {
//                        [[LoginBoard sharedInstance] autoLogin];
//                    }
//                        break;
//                        
//                    default:
//                    {
//                        [[BeeUITipsCenter sharedInstance] presentFailureTips:json[@"ERRMSG"]];
//                    }
//                        break;
//                }
            }
                break;
        }
    }
}


- (void)loadContent{
    myTextView = [BeeUITextView spawn];
    myTextView.placeholder = @"您的宝贵意见是对我们最大的支持";
    myTextView.frame = self.viewBound;
    myTextView.font = FONT(15);
    [myTextView makeTappable:FeedbackBoard.HIDE];
    [self.view addSubview:myTextView];
    
    [myTextView becomeFirstResponder];
}

@end
