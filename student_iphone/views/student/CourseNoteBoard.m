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
//  CourseNoteBoard.m
//  ClassRoom
//
//  Created by he chao on 8/4/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "CourseNoteBoard.h"
#import "ClassNoteCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CommentListBoard.h"

#pragma mark -

@interface CourseNoteBoard()
{
	//<#@private var#>
}
@end

@implementation CourseNoteBoard

DEF_SIGNAL(DEL_NOTE)
DEF_SIGNAL(LIKE_NOTE)
DEF_SIGNAL(PLAY_VOICE)
DEF_SIGNAL(COMMENT)

- (void)load
{
    arrayNotes = [[NSMutableArray alloc] init];
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.title = @"我的笔记";
    [self showNaviBar];
    [self showBackBtn];
    
    BaseLabel *lb = [BaseLabel initLabel:[NSString stringWithFormat:@"      %@",self.dictCourseNote[@"courseName"]] font:FONT(16) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lb.backgroundColor = RGB(200, 200, 200);
    lb.frame = CGRectMake(0, 0, self.viewWidth, 50);
    [self.view addSubview:lb];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lb.bottom, self.viewWidth, self.viewHeight-lb.bottom)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    myTableView.tableFooterView = [[UIView alloc] init];
    
    pageOffset = 0;
    [self getCourseNote];
    
    CourseNoteBoard *board = self;
    [myTableView addPullToRefreshWithActionHandler:^{
        [board refresh];
    }];
    
    [myTableView addInfiniteScrollingWithActionHandler:^{
        
        [board more];
    }];
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
    [myTableView reloadData];
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

ON_SIGNAL2(CourseNoteBoard, signal) {
    if ([signal is:CourseNoteBoard.DEL_NOTE]) {
        dictSelNote = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/del_course_note.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",dictSelNote[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9529;
    }
    else if ([signal is:CourseNoteBoard.LIKE_NOTE]) {
        dictSelNote = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/add_note_praise.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",dictSelNote[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9530;
    }
    else if ([signal is:CourseNoteBoard.PLAY_VOICE]) {
        dictSelNote = signal.object;
    }
    else if ([signal is:CourseNoteBoard.COMMENT]){
        dictSelNote = signal.object;
        CommentListBoard *board = [[CommentListBoard alloc] init];
        board.type = 1;
        board.dictNote = dictSelNote;
        [self.stack pushBoard:board animated:YES];
    }
}

- (void)refresh{
    pageOffset = 0;
    [self getCourseNote];
}

- (void)more{
    pageOffset += pageSize;
    [self getCourseNote];
}

- (void)getCourseNote{
    if (self.isUserHomePageEnter && [self.dictCourseNote[@"userId"] intValue]==[kUserId intValue]) {
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/my/get_course_note_by_course_id.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"pageOffset",INTTOSTRING(pageOffset)).PARAM(@"pageSize",INTTOSTRING(pageSize)).PARAM(@"courseId",self.dictCourseNote[@"courseId"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9531;
    }
    else {
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/my/get_course_note_by_course_id.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"pageOffset",INTTOSTRING(pageOffset)).PARAM(@"pageSize",INTTOSTRING(pageSize)).PARAM(@"courseId",self.dictCourseNote[@"courseId"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9527;
    }
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        NETWORK_ERROR
        if (myTableView) {
            [myTableView.pullToRefreshView stopAnimating];
            [myTableView.infiniteScrollingView stopAnimating];
        }
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
                switch (request.tag) {
                    case 9527:
                    {
                        if (pageOffset==0) {
                            [arrayNotes removeAllObjects];
                        }
                        [arrayNotes addObjectsFromArray:json[@"result"]];
                        [self getCellHeight];
                        [myTableView reloadData];
                    }
                        break;
                    case 9529:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"删除成功"];
                        int commentNum = [dictSelNote[@"commentNum"] intValue]-1;
                        [dictSelNote setObject:[NSString stringWithFormat:@"%d",commentNum] forKey:@"commentNum"];
                        [arrayNotes removeObject:dictSelNote];
                        [myTableView reloadData];
                    }
                        break;
                    case 9530:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"操作成功"];
                        int praiseNum = [dictSelNote[@"praiseNum"] intValue]+1;
                        [dictSelNote setObject:[NSString stringWithFormat:@"%d",praiseNum] forKey:@"praiseNum"];
                        [myTableView reloadData];
                    }
                        break;
                    case 9531:
                    {
                        if (pageOffset==0) {
                            [arrayNotes removeAllObjects];
                        }
                        [arrayNotes addObjectsFromArray:json[@"result"]];
                        [self getCellHeight];
                        [myTableView reloadData];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"没有更多查询结果"];
            }
                break;
            default:
            {
                [[BeeUITipsCenter sharedInstance] presentFailureTips:json[@"ERRMSG"]];
            }
                break;
        }
    }
}

- (void)getCellHeight{
    for (int i = 0; i < arrayNotes.count; i++) {
        NSMutableDictionary *dict = arrayNotes[i];
        CGSize szTitle = [dict[@"title"] sizeWithFont:BOLDFONT(16) byWidth:286];
        CGSize szContent = [dict[@"content"] sizeWithFont:FONT(13) byWidth:286];
        CGFloat height = szTitle.height+szContent.height+80;
        [dict setObject:[NSString stringWithFormat:@"%f",height] forKey:@"height"];
        
        CGFloat y = 49;
        if ([dict[@"voiceRecordUrl"] length]>0) {
            y+=32;
        }
        else {
            y = y+szContent.height;
        }
        int picCount = [dict[@"pics"] count];
        if (picCount>0) {
            int count = ceil(picCount/3.0);
            y += 55*count;
            y +=3;
        }
        y+=45;
        
        [dict setObject:[NSString stringWithFormat:@"%f",y] forKey:@"height"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [arrayNotes[indexPath.row][@"height"] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayNotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[ClassNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictNote = arrayNotes[indexPath.row];
    cell.isCourseNote = YES;
    cell.courseNoteBoard = self;
    [cell load];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}

#pragma mark - full image
- (void)showFullImage:(NSArray *)pics imgV:(BeeUIImageView *)imgV index:(int)index{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < [pics count]; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:pics[i][@"url"]]; // 图片路径
        //photo.strDescription = arrayPhotos[i][@"description"];
        if (i==index) {
            photo.srcImageView = imgV;
        }
        
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
