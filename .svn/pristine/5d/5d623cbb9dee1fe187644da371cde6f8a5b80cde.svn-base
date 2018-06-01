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
//  StudentListBoard.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "StudentListBoard.h"
#import "StudentCell.h"
#import "StudentHomePageBoard.h"

#pragma mark -

@interface StudentListBoard()
{
	//<#@private var#>
}
@end

@implementation StudentListBoard
DEF_SIGNAL(ADD)
DEF_SIGNAL(DETAIL)

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
    [self showBackBtn];
    self.title = @"加好友";
    [self loadContent];
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
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL2(StudentListBoard, signal){
    if ([signal is:StudentListBoard.ADD]) {
        
    }
    else if ([signal is:StudentListBoard.DETAIL]) {
        NSMutableDictionary *dictUser = signal.object;
        StudentHomePageBoard *board = [[StudentHomePageBoard alloc] init];
        board.dictUser = dictUser;
        board.type = [dictUser[@"friendStatus"] boolValue]?1:3;
        [self.stack pushBoard:board animated:YES];
    }
}

- (void)loadContent{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    myTableView.tableFooterView = [[UIView alloc] init];
    
    if (self.isSearchClassmate) {
        [self getClassmateList];
    }
    else {
        [self getStudentList];
    }
}

- (void)getStudentList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_classmate_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",self.dictCourse[@"courseId"]).PARAM(@"courseSchedId",self.dictCourse[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)getClassmateList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/friend/get_classmate_student.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9528;
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
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        arrayStudent = json[@"result"];
                        [myTableView reloadData];
                        //arrayCourseCharacters = json[@"result"];
                    }
                        break;
                    case 9528:
                    {
                        arrayStudent = json[@"result"];
                        [myTableView reloadData];
                    }
                        break;
                }
            }
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceil(arrayStudent.count/4.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (nil == cell) {
        cell = [[StudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictUser0 = arrayStudent[indexPath.row*4];
    if (arrayStudent.count>indexPath.row*4+1) {
        cell.dictUser1 = arrayStudent[indexPath.row*4+1];
    }
    else {
        cell.dictUser1 = nil;
    }
    if (arrayStudent.count>indexPath.row*4+2) {
        cell.dictUser2 = arrayStudent[indexPath.row*4+2];
    }
    else {
        cell.dictUser2 = nil;
    }
    if (arrayStudent.count>indexPath.row*4+3) {
        cell.dictUser3 = arrayStudent[indexPath.row*4+3];
    }
    else {
        cell.dictUser3 = nil;
    }
    [cell load];
    return cell;
}

@end
