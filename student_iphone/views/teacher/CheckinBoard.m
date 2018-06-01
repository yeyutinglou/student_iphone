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
//  CheckinBoard.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "CheckinBoard.h"
#import "CheckinCell.h"

#pragma mark -

@interface CheckinBoard()
{
	//<#@private var#>
}
@end

@implementation CheckinBoard
DEF_SIGNAL(DONE)
DEF_SIGNAL(CHECK_IN)

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
    self.title = @"点名";
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
    if (!btnDone) {
        btnDone = [BeeUIButton spawn];
        btnDone.frame = CGRectMake(self.viewWidth-50, 0, 50, 44);
        [btnDone setTitle:@"完成" forState:UIControlStateNormal];
        [btnDone addSignal:CheckinBoard.DONE forControlEvents:UIControlEventTouchUpInside];
        [btnDone setTitleColor:RGB(255, 255, 11) forState:UIControlStateNormal];
    }
    [self.navigationController.navigationBar addSubview:btnDone];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [btnDone removeFromSuperview];
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

ON_SIGNAL2(CheckinBoard, signal) {
    if ([signal is:CheckinBoard.DONE]) {
        [self.stack popBoardAnimated:YES];
    }
    else if ([signal is:CheckinBoard.CHECK_IN]){
        dictSel = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/teacher_roll_call.action"]].PARAM(@"id",dictSel[@"teacherId"]).PARAM(@"stuSignId",dictSel[@"id"]).PARAM(@"rollCallStatus",[dictSel[@"signStatus"] boolValue]?@"0":@"1");
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9528;
        [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在操作"];
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
    
    [self getStudentList];
}

- (void)getStudentList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_stu_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",self.dictCourse[@"courseId"]).PARAM(@"courseSchedId",self.dictCourse[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        NETWORK_ERROR
        [[BeeUITipsCenter sharedInstance] dismissTips];
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"---------------%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        arrayStudent = json[@"result"];
                        [myTableView reloadData];
                    }
                        break;
                    case 9528:
                    {
                        BOOL status = [dictSel[@"signStatus"] boolValue];
                        status = !status;
                        [dictSel setObject:[NSString stringWithFormat:@"%d",status] forKey:@"signStatus"];
                        [myTableView reloadData];
//                        arrayCourseNote = json[@"result"];
//                        [myTableView reloadData];
                    }
                        break;
                    case 9529:
                    {
                    }
                        break;
                    case 9530:
                    {
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                switch (request.tag) {
                    case 9527:
                    {
                    }
                        break;
                    case 9528:
                    {
                    }
                        break;
                    case 9529:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"此讲暂时没有轻课件"];
                    }
                        break;
                    case 9530:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"此讲暂时没有课件可供下载"];
                    }
                        break;
                        
                    default:
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
    NSString *identifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    CheckinCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[CheckinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
