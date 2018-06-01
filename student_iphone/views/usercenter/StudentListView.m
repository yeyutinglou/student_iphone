//
//  StudentListView.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "StudentListView.h"
#import "FriendContactCell.h"
#import "StudentListBoard.h"
#import "SearchUserBoard.h"
#import "StudentHomePageBoard.h"

@implementation StudentListView
DEF_SIGNAL(SEARCH)
DEF_SIGNAL(ADD)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        arrayStudent = [[NSMutableArray alloc] init];
    }
    return self;
}

ON_SIGNAL2(StudentListView, signal){
    if ([signal is:StudentListView.SEARCH]) {
        if (kStrTrim(search.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入搜索关键字"];
            return;
        }
        SearchUserBoard *board = [[SearchUserBoard alloc] init];
        board.isSearchTeacher = NO;
        board.strKey = search.text;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        [search resignFirstResponder];
    }
    else if ([signal is:StudentListView.ADD]) {
        StudentListBoard *board = [[StudentListBoard alloc] init];
        board.isSearchClassmate = YES;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
}

- (void)loadContent{
    self.backgroundColor = RGB(242, 242, 242);
    myTableView = [[UITableView alloc] initWithFrame:self.bounds];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self addSubview:myTableView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 110)];
    header.backgroundColor = [UIColor clearColor];
    
    search = [BeeUITextField spawn];
    search.frame = CGRectMake(20, 7, 280, 40);
    search.backgroundImage = IMAGESTRING(@"search_bg");
    search.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    search.font =  FONT(14);
    //search.text = @"马";
    search.placeholder = @"搜索添加好友";
    search.leftViewMode = UITextFieldViewModeAlways;
    search.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    
    BeeUIButton *btnSearch = [BeeUIButton spawn];
    btnSearch.frame = CGRectMake(0, 0, 40, 40);
    [btnSearch setImage:IMAGESTRING(@"search_icon") forState:UIControlStateNormal];
    [btnSearch addSignal:StudentListView.SEARCH forControlEvents:UIControlEventTouchUpInside];
    search.rightView = btnSearch;
    search.rightViewMode = UITextFieldViewModeAlways;
    [header addSubview:search];
    
    
    
    if (!isTeacher) {
        BeeUIButton *btnAdd = [BeeUIButton spawn];
        btnAdd.frame = CGRectMake(0, 55, self.width, 55);
        [btnAdd addSignal:StudentListView.ADD forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:btnAdd];
        
        BeeUIImageView *imgIcon = [BeeUIImageView spawn];
        imgIcon.image = IMAGESTRING(@"add_friends");
        imgIcon.frame = CGRectMake(10, 0, 55, 55);
        [btnAdd addSubview:imgIcon];
        
        BaseLabel *lb = [BaseLabel initLabel:@"添加同学为好友" font:FONT(15) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        lb.frame = CGRectMake(imgIcon.right, 0, 200, 55);
        [btnAdd addSubview:lb];
    }
    
    myTableView.tableHeaderView = header;
    
//    if (isTeacher) {
//        [self teacherGetStudentList];
//    }
//    else {
        [self studentGetFriendList];
//    }
}

- (void)refresh{
//    if (isTeacher) {
//        [self teacherGetStudentList];
//    }
//    else {
        [self studentGetFriendList];
//    }
}

- (void)hideKeyboard{
    [search resignFirstResponder];
}

- (void)teacherGetStudentList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/friend/teacher_get_stu_friend_list.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)studentGetFriendList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/friend/stu_get_stu_friend_list.action"]].PARAM(@"id",kUserInfo[@"id"]);
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
                    [arrayStudent removeAllObjects];
                    NSArray *tempArray = json[@"result"];
                    for (int i = 0; i < tempArray.count; i++) {
                        NSMutableDictionary *dictTemp = tempArray[i];
                        BOOL isFind = NO;
                        for (int j = 0; j < arrayStudent.count; j++) {
                            NSMutableArray *array = arrayStudent[j][@"array"];
                            if ([array[0][@"indexChar"] isEqualToString:dictTemp[@"indexChar"]]) {
                                isFind = YES;
                                [array addObject:dictTemp];
                                break;
                            }
                        }
                        if (!isFind) {
                            NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:dictTemp, nil];
                            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,@"array",dictTemp[@"indexChar"],@"indexChar", nil];
                            [arrayStudent addObject:dict];
                        }
                    }
                    
                    NSSortDescriptor *_sorter  = [[NSSortDescriptor alloc] initWithKey:@"indexChar" ascending:YES];
                    arrayStudent = [[arrayStudent sortedArrayUsingDescriptors:[NSArray arrayWithObject:_sorter]] mutableCopy];
                    [myTableView reloadData];
                }
                else if (request.tag == 9529) {
                    [BeeUIAlertView showMessage:@"删除成功" cancelTitle:@"确定"];
                    /*NSMutableArray *array = arrayStudent[selIndexPath.section];
                    if (array.count<=1) {
                        [arrayStudent removeObject:array];
                    }
                    else {
                        [arrayStudent removeObjectAtIndex:selIndexPath.row];
                    }*/
                    NSMutableDictionary *dict = arrayStudent[selIndexPath.section];
                    if ([dict[@"array"] count]<=1) {
                        [arrayStudent removeObject:dict];
                    }
                    else {
                        [dict[@"array"] removeObjectAtIndex:selIndexPath.row];
                    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayStudent.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayStudent[section][@"array"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return arrayStudent[section][@"indexChar"];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *arrayT = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayStudent.count; i++) {
        [arrayT addObject:arrayStudent[i][@"indexChar"]];
    }
    return arrayT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[FriendContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.dictContact = arrayStudent[indexPath.section][@"array"][indexPath.row];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StudentHomePageBoard *board = [[StudentHomePageBoard alloc] init];
    board.dictUser = arrayStudent[indexPath.section][@"array"][indexPath.row];
    board.type = 1;
    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        selIndexPath = indexPath;
        dictSelUser = arrayStudent[indexPath.section][@"array"][indexPath.row];
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/friend/del_friend.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"delUserId",dictSelUser[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9529;
    }
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
