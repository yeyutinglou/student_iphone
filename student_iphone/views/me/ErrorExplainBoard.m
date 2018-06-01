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
//  ErrorExplainBoard.m
//  student_iphone
//
//  Created by he chao on 15/3/24.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "ErrorExplainBoard.h"

#pragma mark -

@interface ErrorExplainBoard()
{
	//<#@private var#>
}
@end

@implementation ErrorExplainBoard

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
    self.title = @"错题解析";
    [self showBackBtn];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.viewBound];
    [self.view addSubview:webView];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?machineType=phone&examRecordId=%@&id=%@",kSchoolUrl,@"app/exam/stu_get_exam_error_history.action",_examRecordId,kUserInfo[@"id"]];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]]];
    
    JYDLog(@"错题解析strUrl--->:%@", strUrl);
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

//ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
//{
//}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

@end
