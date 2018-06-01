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
//  WrongListBoard.m
//  student_iphone
//
//  Created by he chao on 14/11/16.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "WrongListBoard.h"
#import "WrongCell.h"
#import "ErrorExplainBoard.h"

#pragma mark -

@interface WrongListBoard()
{
	//<#@private var#>
    NSMutableArray *arrayError;
}
@end

@implementation WrongListBoard

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self getMyErrorList];
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
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

- (void)getMyErrorList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/exam/stu_get_error_abstr.action"]].PARAM(@"id",kUserInfo[@"id"]);
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
                    arrayError = json[@"result"];
                    [_myTable reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 55)];
    vi.backgroundColor = [UIColor whiteColor];
    
    BeeUIImageView *icon = [BeeUIImageView spawn];
    icon.frame = CGRectMake(10, 0, 30, 55);
    [vi addSubview:icon];
    
    BaseLabel *name = [BaseLabel initLabel:arrayError[section][@"courseName"] font:BOLDFONT(20) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    name.frame = CGRectMake(50, 0, 250, 55);
    [vi addSubview:name];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54.5, self.viewWidth, 0.5)];
    line.backgroundColor = HEX_RGB(0xe4e4e4);
    [vi addSubview:line];
    
    return vi;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayError.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayError[section][@"errorQuestionData"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *kDiaryIdentifier = @"WrongCell";
    WrongCell *cell = (WrongCell *)[tableView dequeueReusableCellWithIdentifier:kDiaryIdentifier];
    [cell loadContent:arrayError[indexPath.section][@"errorQuestionData"][indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    ErrorExplainBoard *board = [[ErrorExplainBoard alloc] init];
    NSMutableDictionary *dict = arrayError[indexPath.section][@"errorQuestionData"][indexPath.row];
    board.examRecordId = dict[@"examRecordId"];
    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
}

@end
