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
//  SearchUserBoard.m
//  ClassRoom
//
//  Created by he chao on 7/15/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "SearchUserBoard.h"
#import "ContactUserCell.h"
#import "StudentHomePageBoard.h"
#import "CurriculumBoard.h"
#import "SignInMessage.h"
#pragma mark -

@interface SearchUserBoard()
{
	//<#@private var#>
}
@end

@implementation SearchUserBoard
DEF_SIGNAL(SEARCH)

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
    self.title = @"搜索结果";
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

ON_SIGNAL2(SearchUserBoard, signal){
    if ([signal is:SearchUserBoard.SEARCH]) {
        //self.isSearchTeacher?@"张":@"李"
        if (kStrTrim(search.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入搜索关键字"];
            return;
        }
        if ([search.text isEqualToString:@"jyd"]) {
            arrayUser = [[SignInMessage sharedInstance] queryAllErrorMessage];
            [myTableView reloadData];
        }else{
            BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,self.isSearchTeacher?@"app/friend/search_teacher_user.action":@"app/friend/search_student_user.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"keywords",search.text);
            request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
            request.tag = 9527;
        }
        [search resignFirstResponder];
        
    }
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
                if (request.tag == 9527) {
                    arrayUser = json[@"result"];
                    [myTableView reloadData];
                }
            }
                break;
            case 2:
            {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"暂无搜索结果"];
            }
                break;
                
        }
    }
}

- (void)loadContent{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 55)];
    header.backgroundColor = [UIColor clearColor];
    
    search = [BeeUITextField spawn];
    search.frame = CGRectMake(20, 7, 280, 40);
    search.backgroundImage = IMAGESTRING(@"search_bg");
    search.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    search.font =  FONT(14);
    search.placeholder = @"搜索添加好友";
    search.text = self.strKey;
    search.leftViewMode = UITextFieldViewModeAlways;
    search.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    
    BeeUIButton *btnSearch = [BeeUIButton spawn];
    btnSearch.frame = CGRectMake(0, 0, 40, 40);
    [btnSearch setImage:IMAGESTRING(@"search_icon") forState:UIControlStateNormal];
    [btnSearch addSignal:SearchUserBoard.SEARCH forControlEvents:UIControlEventTouchUpInside];
    search.rightView = btnSearch;
    search.rightViewMode = UITextFieldViewModeAlways;
    [header addSubview:search];
    [self.view addSubview:header];
    
    [self sendUISignal:SearchUserBoard.SEARCH];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, header.bottom, self.viewWidth, self.viewHeight-55-(IOS7_OR_LATER?64:44))];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayUser.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([search.text isEqualToString:@"jyd"]) {
        static NSString *identifier = @"jyd";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        NSDictionary *dic = arrayUser[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",dic[@"date"],dic[@"userId"],dic[@"courseId"],dic[@"message"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    ContactUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[ContactUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.dictContact = arrayUser[indexPath.row];
    cell.isSearch = YES;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dictContact = arrayUser[indexPath.row];
    if (![search.text isEqualToString:@"jyd"]) {
        if (self.isSearchTeacher) {
            CurriculumBoard *board = [[CurriculumBoard alloc] init];
            board.dictUser = dictContact;
            board.type = [dictContact[@"friendStatus"] boolValue]?1:3;
            [self.stack pushBoard:board animated:YES];
        }
        else {
            StudentHomePageBoard *board = [[StudentHomePageBoard alloc] init];
            board.dictUser = dictContact;
            board.type = [dictContact[@"friendStatus"] boolValue]?1:3;
            [self.stack pushBoard:board animated:YES];
        }

    }
}


@end
