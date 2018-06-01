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
//  AnswerAnalysisBoard.m
//  student_iphone
//
//  Created by he chao on 15/3/24.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "AnswerAnalysisBoard.h"

#pragma mark -

@interface AnswerAnalysisBoard()
{
	//<#@private var#>
}
@end

@implementation AnswerAnalysisBoard

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
    self.title = @"答题解析";
    [self showBackBtn];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.viewBound];
    [self.view addSubview:webView];
    
    NSString *strUrl;
    if (_isError) {
        strUrl = [NSString stringWithFormat:@"%@%@?machineType=phone&examRecordId=%@&id=%@",kSchoolUrl,@"app/exam/stu_get_exam_error_explain.action",_examRecordId,kUserInfo[@"id"]];
    }
    else {
        if (_answerRecordId) {
            strUrl = [NSString stringWithFormat:@"%@%@?machineType=phone&examRecordId=%@&id=%@&answerRecordId=%@",kSchoolUrl,@"app/exam/stu_get_exam_explain.action",_examRecordId,kUserInfo[@"id"],_answerRecordId];
        }
        else {
            strUrl = [NSString stringWithFormat:@"%@%@?machineType=phone&examRecordId=%@&id=%@",kSchoolUrl,@"app/exam/stu_get_exam_explain.action",_examRecordId,kUserInfo[@"id"]];
        }
    }
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]]];
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


ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

@end
