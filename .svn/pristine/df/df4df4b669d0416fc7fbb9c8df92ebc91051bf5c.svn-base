//
//  TeacherListView.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "TeacherListView.h"
#import "ContactUserCell.h"
#import "SearchUserBoard.h"
#import "CurriculumBoard.h"

@implementation TeacherListView
DEF_SIGNAL(SEARCH)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

ON_SIGNAL2(TeacherListView, signal){
    if ([signal is:TeacherListView.SEARCH]) {
        if (kStrTrim(search.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入搜索关键字"];
            return;
        }
        SearchUserBoard *board = [[SearchUserBoard alloc] init];
        board.isSearchTeacher = YES;
        board.strKey = search.text;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        [search resignFirstResponder];
    }
}

- (void)loadContent{
    self.backgroundColor = RGB(242, 242, 242);
    myTableView = [[UITableView alloc] initWithFrame:self.bounds];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self addSubview:myTableView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 55)];
    header.backgroundColor = [UIColor clearColor];
    
    search = [BeeUITextField spawn];
    search.frame = CGRectMake(20, 7, 280, 40);
    search.backgroundImage = IMAGESTRING(@"search_bg");
    search.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    search.font =  FONT(14);
    search.placeholder = @"搜索添加老师";
    search.leftViewMode = UITextFieldViewModeAlways;
    search.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    
    BeeUIButton *btnSearch = [BeeUIButton spawn];
    btnSearch.frame = CGRectMake(0, 0, 40, 40);
    [btnSearch setImage:IMAGESTRING(@"search_icon") forState:UIControlStateNormal];
    [btnSearch addSignal:TeacherListView.SEARCH forControlEvents:UIControlEventTouchUpInside];
    search.rightView = btnSearch;
    search.rightViewMode = UITextFieldViewModeAlways;
    [header addSubview:search];
    
    myTableView.tableHeaderView = header;
    
//    if (isTeacher) {
//        [self teacherGetTeacherList];
//    }
//    else {
        [self studentGetTeacherList];
//    }
}

- (void)refresh{
//    if (isTeacher) {
//        [self teacherGetTeacherList];
//    }
//    else {
        [self studentGetTeacherList];
//    }
}

- (void)hideKeyboard{
    [search resignFirstResponder];
}

- (void)teacherGetTeacherList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/friend/teacher_get_teacher_friend_list.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)studentGetTeacherList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/friend/stu_get_teacher_friend_list.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9528;
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
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                if (request.tag == 9527 ||
                    request.tag == 9528) {
                    arrayTeacher = json[@"result"];
                    [myTableView reloadData];
                }
            }
                break;
            case 2:
            {
            }
                break;
                
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayTeacher.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[ContactUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.dictContact = arrayTeacher[indexPath.row];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CurriculumBoard *board = [[CurriculumBoard alloc] init];
    board.dictUser = arrayTeacher[indexPath.row];
    board.type = [arrayTeacher[indexPath.row][@"friendStatus"] boolValue]?1:3;
    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideKeyboard];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
