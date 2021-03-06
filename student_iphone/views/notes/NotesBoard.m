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
//  NotesBoard.m
//  ClassRoom
//
//  Created by he chao on 6/17/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "NotesBoard.h"
#import "NotesCell.h"
#import "NotesDetailBoard.h"

#pragma mark -

@interface NotesBoard()
{
	//<#@private var#>
}
@end

@implementation NotesBoard

- (void)load
{
    pageOffset = 0;
    arrayNotes = [[NSMutableArray alloc] init];
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    self.title = @"通知";
    [self showMenuBtn];
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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [myTableView reloadData];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [popupView removeFromSuperview];
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

- (void)loadContent{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-50-(IOS7_OR_LATER?64:44))];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    myTableView.tableFooterView = [[UIView alloc] init];
    
    [self getNoteList];
    
    NotesBoard *board = self;
    [myTableView addPullToRefreshWithActionHandler:^{
        [board refresh];
    }];
    
    [myTableView addInfiniteScrollingWithActionHandler:^{
        [board more];
    }];
}

- (void)refresh{
    pageOffset = 0;
    [self getNoteList];
}

- (void)more{
    pageOffset +=pageSize;
    [self getNoteList];
}

- (void)getNoteList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/article/get_article_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"pageOffset",INTTOSTRING(pageOffset)).PARAM(@"pageSize",INTTOSTRING(pageSize));
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        if (myTableView) {
            [myTableView.pullToRefreshView stopAnimating];
            [myTableView.infiniteScrollingView stopAnimating];
        }
        NETWORK_ERROR
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {
        if (myTableView) {
            [myTableView.pullToRefreshView stopAnimating];
            [myTableView.infiniteScrollingView stopAnimating];
        }
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                if (request.tag == 9527) {
                    if (pageOffset==0) {
                        [arrayNotes removeAllObjects];
                    }
                    [arrayNotes addObjectsFromArray:json[@"result"]];
                    [self getCellHeight];
                    [myTableView reloadData];
                    if ([json[@"result"] count]==0) {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"没有更多查询结果"];
                    }
                    //                    PublicCreateSuccessBoard *board = [[PublicCreateSuccessBoard alloc] init];
                    //                    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
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
    //////add by liuhui
    [super handleRequest:request];
}

- (void)getCellHeight{
    for (int i = 0; i < arrayNotes.count; i++) {
        NSMutableDictionary *dictNote = arrayNotes[i];
        CGSize szTitle = [dictNote[@"title"] sizeWithFont:BOLDFONT(16) byWidth:286];
        CGSize szContent = [dictNote[@"description"] sizeWithFont:FONT(13) byWidth:286];
        CGFloat height = szTitle.height+szContent.height+80;
        [dictNote setObject:[NSString stringWithFormat:@"%f",height] forKey:@"height"];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [arrayNotes[indexPath.row][@"height"] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayNotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[NotesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictNote = arrayNotes[indexPath.row];
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dictNote = arrayNotes[indexPath.row];
    int count = [dictNote[@"visitCount"] intValue]+1;
    [dictNote setObject:[NSString stringWithFormat:@"%d",count] forKey:@"visitCount"];
    NotesDetailBoard *board = [[NotesDetailBoard alloc] init];
    board.strId = dictNote[@"id"];
    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
}



@end
