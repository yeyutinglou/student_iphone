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
//  StudentHomePageBoard.m
//  ClassRoom
//
//  Created by he chao on 14-7-29.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "StudentHomePageBoard.h"
#import "ClassNoteCell.h"
#import "ChatBoard.h"
#import "MJPhotoBrowser.h"

#import "MJPhoto.h"
#import "CourseNoteBoard.h"
#import "CommentListBoard.h"

#pragma mark -

@interface StudentHomePageBoard()
{
	//<#@private var#>
}
@end

@implementation StudentHomePageBoard
DEF_SIGNAL(NAVI_BACK)
DEF_SIGNAL(REJECT)
DEF_SIGNAL(ACCEPT)
DEF_SIGNAL(MESSAGE)
DEF_SIGNAL(REQUEST)
DEF_SIGNAL(DEL_NOTE)
DEF_SIGNAL(DEL_CONFIRM)
DEF_SIGNAL(LIKE_NOTE)
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
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 20)];
        vi.backgroundColor = [UIColor blackColor];
        [self.view addSubview:vi];
    }
    
    self.view.backgroundColor = RGB(242, 242, 242);
    if (self.type != 2) {
        [self loadContent];
    }
    else {
        [self getUserDetail];
    }
    
//    [self loadContent];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL2(StudentHomePageBoard, signal) {
    if ([signal is:StudentHomePageBoard.NAVI_BACK]) {
        [self.stack popBoardAnimated:YES];
    }
    else if ([signal is:StudentHomePageBoard.REJECT]) {
        [[MessageDB sharedInstance] ignoreFriendRequest:self.dictMessage[@"friendId"]];
        [BeeUIAlertView showMessage:@"操作成功" cancelTitle:@"确定"];
        [self.stack popBoardAnimated:YES];
    }
    else if ([signal is:StudentHomePageBoard.ACCEPT]) {
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/reqmsg/process_msg.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"reqMsgId",self.dictMessage[@"id"]).PARAM(@"processType",@"1");
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9532;
        
        [[MessageDB sharedInstance] acceptFriendRequest:self.dictMessage[@"friendId"]];
    }
    else if ([signal is:StudentHomePageBoard.MESSAGE]) {
        ChatBoard *board = [[ChatBoard alloc] init];
        board.dictFriend = self.dictUser;
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:StudentHomePageBoard.REQUEST]) {
        if ([self.dictUser[@"friendAuth"] boolValue]) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"验证申请" message:@"您需要发送验证申请,并在对方通过后才能成为朋友。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *field = [myAlertView textFieldAtIndex:0];
            field.placeholder = @"50字内";
            [myAlertView show];
        }
        else {
            [self sendRequestData:@"lll"];
        }
    }
    else if ([signal is:StudentHomePageBoard.DEL_NOTE]) {
        dictSelNote = signal.object;
        BeeUIAlertView *alert = [BeeUIAlertView spawn];
        alert.message = @"您确认删除此笔记？";
        [alert addCancelTitle:@"取消"];
        [alert addButtonTitle:@"删除" signal:StudentHomePageBoard.DEL_CONFIRM object:dictSelNote];
        [alert showInViewController:self];
    }
    else if ([signal is:StudentHomePageBoard.DEL_CONFIRM]) {
        dictSelNote = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/del_course_note.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",dictSelNote[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9529;
    }
    else if ([signal is:StudentHomePageBoard.LIKE_NOTE]) {
        dictSelNote = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/add_note_praise.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",dictSelNote[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9530;
    }
    else if ([signal is:StudentHomePageBoard.COMMENT]){
        dictSelNote = signal.object;
        CommentListBoard *board = [[CommentListBoard alloc] init];
        board.type = 1;
        board.dictNote = dictSelNote;
        [self.stack pushBoard:board animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *field = [alertView textFieldAtIndex:0];
        if (kStrTrim(field.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入身份信息"];
            return;
        }
        [self sendRequestData:field.text];
    }
}

- (void)sendRequestData:(NSString *)strNote{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/friend/add_friend.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"acceptFriendsId",self.dictUser[@"id"]).PARAM(@"remark",strNote);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9528;
}

- (void)getUserDetail{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/user/get_user_info.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"userId",self.dictMessage[@"friendId"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9531;
    
    [[MessageDB sharedInstance] updateFriendCountClear:self.dictMessage[@"friendId"]];
}

- (void)loadContent{
    BeeUIImageView *naviBar = [BeeUIImageView spawn];
    naviBar.frame = CGRectMake(0, IOS7_OR_LATER?20:0, self.viewWidth, 44);
    naviBar.image = IMAGESTRING(@"navi_bar2");
    naviBar.userInteractionEnabled = YES;
    [self.view addSubview:naviBar];
    
    BeeUIButton *btnBack = [BeeUIButton spawn];
    btnBack.frame = CGRectMake(0, 0, 44, 44);
    [btnBack setImage:IMAGESTRING(@"navi_back") forState:UIControlStateNormal];
    [btnBack addSignal:StudentHomePageBoard.NAVI_BACK forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:btnBack];
    
    
    BeeUIImageView *imgCover = [BeeUIImageView spawn];
    imgCover.frame = CGRectMake(0, IOS7_OR_LATER?20:0, self.viewWidth, 121);
    imgCover.image = IMAGESTRING(@"demo_icon2");
    imgCover.userInteractionEnabled = YES;
    //[self.view addSubview:imgCover];
    [self.view insertSubview:imgCover belowSubview:naviBar];
    
    BeeUIImageView *imgCurriculum = [BeeUIImageView spawn];
    imgCurriculum.image = IMAGESTRING(@"curriculum");
    imgCurriculum.frame = CGRectMake(13, imgCover.bottom-50, 52, 16);
    [imgCover addSubview:imgCurriculum];
    
    
    AvatarView *avatar = [AvatarView initFrame:CGRectMake(0, 0, 80, 80) image:IMAGESTRING(@"demo_icon3") borderColor:[UIColor whiteColor]];
    avatar.center = CGPointMake(160, 50);
    [avatar setImageWithURL:kImage100(self.dictUser[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
    [imgCover addSubview:avatar];
    
    BaseLabel *name = [BaseLabel initLabel:@"Leon" font:FONT(16) color:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    name.frame = CGRectMake(avatar.right+10, avatar.top, 200, avatar.height);
    name.text = self.dictUser[@"nickName"];
    [imgCover addSubview:name];
    
    btnReject = [BaseButton initBaseBtn:IMAGESTRING(@"reject") highlight:IMAGESTRING(@"reject_pre") text:@"拒绝" textColor:[UIColor whiteColor] font:FONT(15)];
    btnReject.frame = CGRectMake(160-90, imgCover.bottom-50, 75, 28);
    [btnReject addSignal:StudentHomePageBoard.REJECT forControlEvents:UIControlEventTouchUpInside];
    [imgCover addSubview:btnReject];
    
    btnAccept = [BaseButton initBaseBtn:IMAGESTRING(@"accept") highlight:IMAGESTRING(@"accept_pre") text:@"接受" textColor:[UIColor whiteColor] font:FONT(15)];
    btnAccept.frame = CGRectMake(160+15, imgCover.bottom-50, 75, 28);
    [btnAccept addSignal:StudentHomePageBoard.ACCEPT forControlEvents:UIControlEventTouchUpInside];
    [imgCover addSubview:btnAccept];
    
    btnMessage = [BaseButton initBaseBtn:IMAGESTRING(@"send_message") highlight:IMAGESTRING(@"send_message_pre") text:@"发送消息" textColor:[UIColor whiteColor] font:FONT(15)];
    btnMessage.frame = CGRectMake(200, imgCover.bottom-55, 100, 33);
    [btnMessage addSignal:StudentHomePageBoard.MESSAGE forControlEvents:UIControlEventTouchUpInside];
    [imgCover addSubview:btnMessage];
    
    btnRequest = [BaseButton initBaseBtn:IMAGESTRING(@"request") highlight:nil];
    btnRequest.frame = CGRectMake(107, imgCover.bottom-55, 105, 40);
    [btnRequest addSignal:StudentHomePageBoard.REQUEST forControlEvents:UIControlEventTouchUpInside];
    [imgCover addSubview:btnRequest];
    
    if ([self.dictUser[@"id"] intValue]==[kUserId intValue]) {
        self.type = 4;
    }
    
    switch (self.type) {
        case 1:
        {
            btnReject.hidden = YES;
            btnAccept.hidden = YES;
            btnRequest.hidden = YES;
            btnMessage.hidden = NO;
        }
            break;
        case 2:
        {
            btnAccept.hidden = NO;
            btnReject.hidden = NO;
            btnMessage.hidden = YES;
            btnRequest.hidden = YES;
        }
            break;
        case 3:
        {
            btnReject.hidden = YES;
            btnAccept.hidden = YES;
            btnMessage.hidden = YES;
            btnRequest.hidden = NO;
        }
            break;
        case 4: //用户自己
        {
            btnReject.hidden = YES;
            btnAccept.hidden = YES;
            btnMessage.hidden = YES;
            btnRequest.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, naviBar.bottom, self.viewWidth, self.viewHeight-naviBar.bottom)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    myTableView.tableHeaderView = imgCover;
    myTableView.tableFooterView = [[UIView alloc] init];
    
    pageOffset = 0;
    
    if ([self.dictUser[@"noteAuth"] boolValue]||[self.dictUser[@"id"] intValue]==[kUserId intValue]) {
        [self getNoteList];
        StudentHomePageBoard *board = self;
        [myTableView addPullToRefreshWithActionHandler:^{
            [board refresh];
        }];
        
        [myTableView addInfiniteScrollingWithActionHandler:^{
            
            [board more];
        }];

    }
    else {
        if ([self.dictUser[@"friendStatus"] boolValue]) {
            [BeeUIAlertView showMessage:@"该好友未公开笔记" cancelTitle:@"确定"];
        }
        else {
            [BeeUIAlertView showMessage:@"该用户未公开笔记" cancelTitle:@"确定"];
        }
    }
    
    //friendStatus
    
}

- (void)refresh{
    pageOffset = 0;
    [self getNoteList];
}

- (void)more{
    pageOffset += pageSize;
    [self getNoteList];
}

- (void)getNoteList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/my/get_user_note_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"pageOffset",INTTOSTRING(pageOffset)).PARAM(@"pageSize",INTTOSTRING(pageSize)).PARAM(@"userId",self.dictUser[@"id"]);
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
                    case 9528:
                    {
                        if ([self.dictUser[@"friendAuth"] boolValue]) {
                            [BeeUIAlertView showMessage:@"发送成功，等待对方验证" cancelTitle:@"确定"];
                        }
                        else {
                            [BeeUIAlertView showMessage:@"添加好友成功" cancelTitle:@"确定"];
                            btnReject.hidden = YES;
                            btnAccept.hidden = YES;
                            btnRequest.hidden = YES;
                            btnMessage.hidden = NO;
                        }
                    }
                        break;
                    case 9529:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"删除成功"];
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
                        _dictUser = json[@"result"];
                        [self loadContent];
                    }
                        break;
                    case 9532:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"添加成功"];
                        btnReject.hidden = YES;
                        btnAccept.hidden = YES;
                        btnRequest.hidden = YES;
                        btnMessage.hidden = NO;
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
//        CGSize szTitle = [dict[@"title"] sizeWithFont:BOLDFONT(16) byWidth:286];
//        CGSize szContent = [dict[@"content"] sizeWithFont:FONT(13) byWidth:286];
        CGSize szTitle = [dict[@"title"] sizeWithFont:BOLDFONT(16) byWidth:263];
        CGSize szContent = [dict[@"content"] sizeWithFont:FONT(13) byWidth:263];
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
    cell.board = self;
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseNoteBoard *board = [[CourseNoteBoard alloc] init];
    board.dictCourseNote = arrayNotes[indexPath.row];
    board.isUserHomePageEnter = YES;
    [self.stack pushBoard:board animated:YES];
}

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
