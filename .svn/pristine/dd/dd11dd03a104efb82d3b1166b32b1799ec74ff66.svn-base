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
//  TeacherAskBoard.m
//  student_iphone
//
//  Created by he chao on 14/11/18.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "TeacherAskBoard.h"
#import "AppDelegate.h"
#import "HPGrowingTextView.h"
#pragma mark -

@interface TeacherAskBoard()<HPGrowingTextViewDelegate, UIWebViewDelegate>
{
	//<#@private var#>
    __weak IBOutlet UIWebView *myWebView;
    __weak IBOutlet UIView *viBottom;
    __weak IBOutlet UIButton *btnPhoto;
    
    __weak IBOutlet UIButton *btnSend;
    __weak IBOutlet HPGrowingTextView *textView;
}
@end

@implementation TeacherAskBoard

- (void)load
{
}

- (void)unload
{
}

- (void)dealloc{
    [self unobserveNotification:@"question"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isQuestionMode = NO;
}

ON_NOTIFICATION(notification){
    if ([notification is:@"question"]) {
        _dictQuestion = notification.object;
        [self showQuestionDetail];
    }
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.title = @"提问";
    [self observeNotification:@"question"];
    [self showQuestionDetail];
    textView.backgroundColor = [UIColor whiteColor];
    // textView.backgroundImage = IMAGESTRING(@"chat_input");
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.returnKeyType = UIReturnKeySend;
    textView.font = FONT(15);
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
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
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        CGRect frameView = viBottom.frame;
        
        CGFloat height = [[UIScreen mainScreen] bounds].size.height;
        CGFloat inputHeight = viBottom.height;
        CGFloat y = keyboardBounds.origin.y;
        NSLog(@"y=======%f",y);
        if (y>height) {
            y = height;
        }
        //CGFloat keyHeight = keyboardBounds.size.height;
        
        frameView.origin.y = y - inputHeight-64;
        myWebView.frame = CGRectMake(0, 64, self.viewWidth, frameView.origin.y);
        
        //frameView.origin.y = y - inputHeight-20-44;
        //        if (y == height) {
        //            frameView.origin.y = y;
        //        }
        //        else {
        viBottom.frame = frameView;
        //        }
        
        [UIView commitAnimations];
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    }
#endif
}

-(void)keyboardWillShow:(NSNotification *) n{
     NSValue *keyboardBoundsValue = [[n userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
   
    [UIView animateWithDuration:0.2 animations:^{
        viBottom.frame = CGRectMake(0, self.view.height - keyboardBounds.size.height - viBottom.height-64, kWidth, viBottom.height);
        myWebView.frame = CGRectMake(0, 64, kWidth, viBottom.y -64);
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)n{
    
    [UIView animateWithDuration:0.2 animations:^{
        viBottom.frame = CGRectMake(0, self.viewHeight  - viBottom.height, kWidth, viBottom.height);
        myWebView.frame = CGRectMake(0, 64, kWidth, viBottom.y-64);
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self unobserveNotification:@"question"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isQuestionMode = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self observeNotification:@"question"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isQuestionMode = YES;
    [self showQuestionDetail];
}

- (void)showQuestionDetail{
    if ([_dictQuestion[@"cmd"] intValue]==2) {
        //add by zhaojian 2015-06-30 ~~修正teacher_ipad当老师结束提问的时候student_iphone无法自动提交的bug
        [myWebView stringByEvaluatingJavaScriptFromString:@"commitQuesAnswer()"];
        //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //delegate.isQuestionMode = NO;
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?machineType=phone&questionRecordId=%@&id=%@",kSchoolUrl,@"app/question/stu_get_question_detail.action",_dictQuestion[@"questionRecordId"],kUserInfo[@"id"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
    [myWebView loadRequest:request];
    myWebView.delegate = self;
        switch ([_dictQuestion[@"questionType"] intValue]) {
        case 1:
//        {
//           
//            myWebView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
//            viBottom.hidden = YES;
//        }
//            break;
        case 2:
        {
            myWebView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
            viBottom.hidden = YES;
        }
            break;
        case 3:
        {
            myWebView.frame = CGRectMake(0, 64, kWidth, self.viewHeight-viBottom.height-64);
            viBottom.hidden = NO;
            textView.text = @"";
        }
            break;
            
        default:
            break;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    NSLog(@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"]);

}
- (IBAction)touchSendBtn:(id)sender {
    if (textView.text.length==0) {
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请输入内容"];
        return;
    }
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/question/stu_save_answer_zgt.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"questionRecordId",_dictQuestion[@"questionRecordId"]).PARAM(@"answerContent",textView.text);//.PARAM(@"pageOffset",@"0").PARAM(@"pageSize",@"100");
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
    
    [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在提交" inView:self.view];
}

- (IBAction)touchPicBtn:(id)sender {
    
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        NETWORK_ERROR
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
                        NSMutableDictionary *dict = json[@"result"];
                        myWebView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
                        viBottom.hidden = YES;
                        NSString *strUrl = [NSString stringWithFormat:@"%@%@?machineType=phone&questionRecordId=%@&id=%@",kSchoolUrl,@"app/question/stu_get_zgt_result.action",dict[@"questionRecordId"],kUserInfo[@"id"]];
                        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
                        [myWebView loadRequest:request];
                        /*
                         questionId = 11;
                         questionRecordId = 73;
                         questionType = 3;
                         */
                    }
                        break;
                }
            }
                break;
        }
    }
    
    //2016-05-06
    [super handleRequest:request];
    
}

#pragma mark -- HPGrowingTextViewDelegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = viBottom.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    viBottom.frame = r;
    CGRect photo = btnPhoto.frame;
    photo.origin.y =  r.size.height - photo.size.height;
    btnPhoto.frame = photo;
    CGRect send = btnSend.frame;
    send.origin.y =  r.size.height - send.size.height;
    btnSend.frame = send;
}
@end
