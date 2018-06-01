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
//  MyCheckinBoard.m
//  ClassRoom
//
//  Created by he chao on 14-6-25.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

/*
 * 我的签到页面
 */



#import "MyCheckinBoard.h"
#import "MyCheckinCell.h"

#pragma mark -

@interface MyCheckinBoard()
{
	//<#@private var#>
}
@end

@implementation MyCheckinBoard

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
    self.title = @"我的签到";
    [self loadContent];
    [self getMyCourse];
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

- (void)getMyCourse{
//    arrayCourse = kGetCache(@"arrayCourse");
//    [myTableView  reloadData];
    
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/my/get_my_course.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
    
    //JYDLog(@"%@", kUserInfo[@"id"]);
    
    [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在加载"];
}

- (void)getMyCourseSignDetail:(NSMutableDictionary *)dictCourse{
    dictSelCourse = dictCourse;
    [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在加载"];
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/my/get_my_course_sign_detail.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dictCourse[@"id"]);
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
                if (request.tag == 9527) {
                    arrayCourse = json[@"result"];
                    [myTableView reloadData];
                    
                    //kSaveCache(arrayCourse, @"arrayCourse");
                }
                else if (request.tag == 9528) {
                    NSMutableArray *arraySign = json[@"result"];

                    [dictSelCourse setObject:arraySign forKey:@"sign"];
                    [dictSelCourse setObject:@YES forKey:@"isShowSign"];
                    
                    [myTableView reloadData];
                }
            }
                break;
            case 2:
            {
                if (request.tag == 9527) {
                    [[BeeUITipsCenter sharedInstance] presentMessageTips:@"暂无课程信息"];
                }
                if (request.tag == 9528) {
                    [[BeeUITipsCenter sharedInstance] presentMessageTips:@"暂无签到信息"];
                }
            }
                break;
                
        }
    }
}

- (void)loadContent{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.tableFooterView = [[UITableView alloc] init];
    [self.view addSubview:myTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        return 48+45*4+10;
//    }
//    
    NSMutableDictionary *dict = arrayCourse[indexPath.row];
    if ([dict[@"isShowSign"] boolValue]) {
        int signCount = [dict[@"sign"] count];
        return 58+45*ceil(signCount/5.0);
    }
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayCourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCheckinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[MyCheckinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictCourse = arrayCourse[indexPath.row];
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dictCourse = arrayCourse[indexPath.row];
    if ([dictCourse[@"isShowSign"] boolValue]) {
        [dictCourse setObject:@NO forKey:@"isShowSign"];
        [myTableView reloadData];
    }
    else {
        if (dictCourse[@"sign"]) {
            [dictCourse setObject:@YES forKey:@"isShowSign"];
            [myTableView reloadData];
        }
        else {
            [self getMyCourseSignDetail:dictCourse];
        }
    }
}

@end
