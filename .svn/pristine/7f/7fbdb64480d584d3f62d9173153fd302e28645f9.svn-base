//
//  SchoolPublicView.m
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "SchoolPublicView.h"
#import "SchoolPublicCell.h"
#import "PublicBoard.h"
#import "PublicAccountInfoListBoard.h"
#import "PublishBoard.h"
#import "PublicIntroBoard.h"


@implementation SchoolPublicView

DEF_SIGNAL(ATTENTION)
DEF_SIGNAL(CANCEL)
DEF_SIGNAL(PUBLISH)


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)refresh{
    //[myTableView reloadData];
    [self getPublicOrgList];
}

ON_SIGNAL2(SchoolPublicView, signal){
    if ([signal is:SchoolPublicView.ATTENTION]) {
        //        PublicIntroBoard *board = [[PublicIntroBoard alloc] init];
        //        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        dictPublic = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/publc_org_fans.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"fansType",@"1").PARAM(@"publicOrgId",dictPublic[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9528;
    }
    else if ([signal is:SchoolPublicView.CANCEL]) {
//        CommentListBoard *board = [[CommentListBoard alloc] init];
//        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        dictPublic = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/publc_org_fans.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"fansType",@"2").PARAM(@"publicOrgId",dictPublic[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9529;
    }
    else if ([signal is:SchoolPublicView.PUBLISH]) {
        PublishBoard *board = [[PublishBoard alloc] init];
        board.dictPublic = signal.object;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
}

- (void)loadContent{
    myTableView = [[UITableView alloc] initWithFrame:self.bounds];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] init];
    SchoolPublicView *board = self;
    [myTableView addPullToRefreshWithActionHandler:^{
        [board getPublicOrgList];
    }];
    
    [self addSubview:myTableView];
    
    [self getPublicOrgList];
}

- (void)getPublicOrgList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/get_public_org_list.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        NETWORK_ERROR
        if (myTableView) {
            [myTableView.pullToRefreshView stopAnimating];
        }
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {
        if (myTableView) {
            [myTableView.pullToRefreshView stopAnimating];
        }
      //  id json = [request.responseString mutableObjectFromJSONString];
        NSString *tmpStr  = [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
       // tmpStr = [tmpStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if (tmpStr == nil || [tmpStr isEqualToString:@""])
        {
            return;
        }
        
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:[tmpStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];

        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        arrayPublic = json[@"result"];
                        [myTableView reloadData];
                    }
                        break;
                    case 9528:
                    {
                        NSMutableArray *array = [arrayPublic mutableCopy];
                        arrayPublic = [[NSMutableArray alloc] init];
                        for (int i = 0; i < array.count; i++) {
                            NSDictionary *dic = array[i];
                            if ([dic isEqualToDictionary:dictPublic]) {
                                NSMutableDictionary *dicState = [dictPublic mutableCopy];
                                [dicState setObject:@"1" forKey:@"inPublicOrgStatus"];
                                [arrayPublic addObject:dicState];
                
                            }else{
                                [arrayPublic addObject:dic];
                            }
                            
                        }

                        
                        [myTableView reloadData];
                       //[self getPublicOrgList];
                    }
                        break;
                    case 9529:
                    {
                        NSMutableArray *array = [arrayPublic mutableCopy];
                        arrayPublic = [[NSMutableArray alloc] init];
                        for (int i = 0; i < array.count; i++) {
                            NSDictionary *dic = array[i];
                            if ([dic isEqualToDictionary:dictPublic]) {
                                NSMutableDictionary *dicState = [dictPublic mutableCopy];
                                [dicState setObject:@"0" forKey:@"inPublicOrgStatus"];
                                [arrayPublic addObject:dicState];
                                
                            }else{
                                [arrayPublic addObject:dic];
                            }
                            
                        }

                        [myTableView reloadData];
                        //[self getPublicOrgList];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayPublic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolPublicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[SchoolPublicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell initSelf];
    }
    cell.dictPublic = arrayPublic[indexPath.row];
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //PublicAccountInfoListBoard *board = [[PublicAccountInfoListBoard alloc] init];
    PublicIntroBoard *board = [[PublicIntroBoard alloc] init];
    board.dictInfo = arrayPublic[indexPath.row];
    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
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
