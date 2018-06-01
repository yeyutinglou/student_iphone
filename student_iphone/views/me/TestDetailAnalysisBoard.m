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
//  TestDetailAnalysisBoard.m
//  student_iphone
//
//  Created by he chao on 14/11/16.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "TestDetailAnalysisBoard.h"
#import "TestDetailAnalysisCell.h"
#import "AnswerCardBoard.h"

#pragma mark -

@interface TestDetailAnalysisBoard()
{
	//<#@private var#>
    __weak IBOutlet UITableView *myTableView;
    NSMutableArray *arrayAnalysis;
}
@end

@implementation TestDetailAnalysisBoard

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
    self.title = @"课程统计";
    [self loadContent];
    [self showBackBtn];
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

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.navigationController popViewControllerAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

- (void)loadContent{
    [self getMyExamDetailList];
}

- (void)getMyExamDetailList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/exam/stu_get_exam_abstr_list_by_course_id.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",_dictTest[@"courseId"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        
        NETWORK_ERROR
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
                    arrayAnalysis = json[@"result"];
                    [myTableView reloadData];
                }
            }
                break;
            case 2:
            {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"没有更多查询结果"];
            }
                break;
                
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayAnalysis.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *kDiaryIdentifier = @"TestDetailAnalysisCell";
    TestDetailAnalysisCell *cell = (TestDetailAnalysisCell *)[tableView dequeueReusableCellWithIdentifier:kDiaryIdentifier];
    [cell loadContent:arrayAnalysis[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath * indexpath = [myTableView indexPathForCell:sender];
    
    [myTableView deselectRowAtIndexPath:indexpath animated:YES];
    
    if ([segue.identifier isEqualToString:@"answerCard"]) {
        //        YQDetailViewController *detailViewController = segue.destinationViewController;
        //        detailViewController.dictFeed = arrayFeeds[indexpath.row];
        //        YQFeedCell *cell = (YQFeedCell *)[myTableView cellForRowAtIndexPath:indexpath];
        //        detailViewController.coverImage = cell.bgImageView.image;
        AnswerCardBoard *controller = segue.destinationViewController;
        controller.examRecordId = arrayAnalysis[indexpath.row][@"examRecordId"];
    }
}

@end
