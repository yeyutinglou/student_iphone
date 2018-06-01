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
//  CommentListBoard.m
//  ClassRoom
//
//  Created by he chao on 6/24/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "CommentListBoard.h"
#import "CommentCell.h"

#pragma mark -

@interface CommentListBoard()
{
	//<#@private var#>
}
@end

@implementation CommentListBoard
DEF_SIGNAL(DEL_COMMENT)
DEF_SIGNAL(SEND_COMMENT)
DEF_SIGNAL(ALERT)
DEF_SIGNAL(FACE)

- (void)load
{
    arrayComments = [[NSMutableArray alloc] init];
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    self.title = @"评论";
    [self loadContent];
    [self showBarButton:BeeUINavigationBar.RIGHT title:@"评论"];
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
    [self showToolBar];
}

ON_SIGNAL2(CommentListBoard, signal) {
    if ([signal is:CommentListBoard.DEL_COMMENT]) {
        dictSelComment = signal.object;
        switch (self.type) {
            case 1:
            {
                BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/del_course_note_comment.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteCommentId",dictSelComment[@"id"]);
                request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
                request.tag = 9529;
            }
                break;
            case 2:
            {
                BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/del_public_org_comment.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"publicOrgCommentId",dictSelComment[@"id"]);
                request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
                request.tag = 9530;
            }
                break;
                
            default:
                break;
        }
    }
    else if ([signal is:CommentListBoard.ALERT]) {
        BeeUIAlertView *myAlert = [BeeUIAlertView spawn];
        [myAlert setTitle:@"您确认删除此评论?"];
        [myAlert addCancelTitle:@"取消"];
        [myAlert addButtonTitle:@"删除" signal:CommentListBoard.DEL_COMMENT object:signal.object];
        [myAlert showInViewController:self];
    }
    else if ([signal is:CommentListBoard.SEND_COMMENT]) {
        if (kStrTrim(field.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入评论内容"];
            return;
        }
        if (self.type == 1) {
            NSString *strNoteId = self.dictNote[@"noteId"];
            if (!strNoteId || [strNoteId intValue]==0) {
                strNoteId = self.dictNote[@"id"];
            }
            BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/add_course_note_comment.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",strNoteId).PARAM(@"content",field.text);
            request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
            request.tag = 9531;
        }
        else if (self.type == 2){
            BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/add_public_org_msg_comment.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"content",field.text).PARAM(@"publicOrgId",self.dictPublic[@"publicOrgId"]).PARAM(@"publicOrgMsgId",self.dictPublic[@"id"]);
            request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
            request.tag = 9532;
        }
    }
    else if ([signal is:CommentListBoard.FACE]) {
        if (!faceChooseView) {
            faceChooseView = [[FaceSelectView alloc] initWithFrame:CGRectMake(0, self.viewHeight-(IOS7_OR_LATER?64:44)-160, self.viewWidth, 160)];
            faceChooseView.mainCtrl = self;
            [faceChooseView loadContent];
        }
        [field resignFirstResponder];
        faceChooseView.hidden = NO;
        [self.view addSubview:faceChooseView];
        
        toolBar.frame = CGRectMake(0, faceChooseView.top-toolBar.height, toolBar.width, toolBar.height);
    }
}

- (void)loadContent{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    
    lbCount = [BaseLabel initLabel:[NSString stringWithFormat:@"  共评论%@条",self.type==1?self.dictNote[@"commentNum"]:self.dictPublic[@"commentNum"]] font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lbCount.frame = CGRectMake(0, 0, self.viewWidth, 30);
    [self.view addSubview:lbCount];
    
    
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lbCount.bottom, self.viewWidth, self.viewHeight-50-lbCount.height-(IOS7_OR_LATER?64:44))];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:myTableView];
    
    UITextField *field1 = [[UITextField alloc] init];
    field1.delegate = self;
    field1.backgroundColor = [UIColor whiteColor];
    field1.layer.borderWidth = 0.5;
    field1.layer.borderColor = RGB(200, 200, 200).CGColor;
    field1.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    field1.leftViewMode = UITextFieldViewModeAlways;
    field1.placeholder = @"评论一下";
    field1.frame = CGRectMake(10, myTableView.bottom+10, self.viewWidth-20, 30);
    field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:field1];
    
    switch (self.type) {
        case 1:
        {
            [self getNoteCommentList];
        }
            break;
        case 2:
        {
            [self getPublicCommentList];
            //field1.hidden = YES;
            //myTableView.frame = CGRectMake(0, lbCount.bottom, self.viewWidth, self.viewHeight-lbCount.height-(IOS7_OR_LATER?64:44));
        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self showToolBar];
    return NO;
}

- (void)getNoteCommentList{
    NSString *strNoteId = self.dictNote[@"noteId"];
    if (!strNoteId || [strNoteId integerValue]==0) {
        strNoteId = self.dictNote[@"id"];
    }
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_course_note_comment_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",strNoteId).PARAM(@"pageOffset",@"0").PARAM(@"pageSize",@"200");
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)getPublicCommentList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/get_public_org_comment_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"publicOrgMsgId",self.dictPublic[@"id"]).PARAM(@"pageOffset",@"0").PARAM(@"pageSize",@"200");
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
//        NSString *tmpStr  = [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
//        tmpStr = [tmpStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        
//        if (tmpStr == nil || [tmpStr isEqualToString:@""])
//        {
//            return;
//        }
//        
//        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:[tmpStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        [arrayComments removeAllObjects];
                        [arrayComments addObjectsFromArray:json[@"result"]];
                        [self getCellHeight:arrayComments];
                        [myTableView reloadData];
                    }
                        break;
                    case 9528:
                    {
                        [arrayComments removeAllObjects];
                        [arrayComments addObjectsFromArray:json[@"result"]];
                        [self getCellHeight:arrayComments];
                        [myTableView reloadData];
                    }
                        break;
                    case 9529:
                    {
                        [arrayComments removeObject:dictSelComment];
                        [myTableView reloadData];
                        
                        lbCount.text = [NSString stringWithFormat:@"  共评论%d条",arrayComments.count];
                    
                        int commentCount = [self.dictNote[@"commentNum"] intValue]-1;
                        [self.dictNote setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"commentNum"];
                        
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"删除成功"];
                    }
                        break;
                    case 9530:
                    {
                        
                        [arrayComments removeObject:dictSelComment];
                        [myTableView reloadData];
                        
                        lbCount.text = [NSString stringWithFormat:@"  共评论%d条",arrayComments.count];
                        
                        int commentCount = [self.dictPublic[@"commentNum"] intValue]-1;
                        [self.dictPublic setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"commentNum"];
                        
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"删除成功"];
                    }
                        break;
                    case 9531:
                    {
                        [field resignFirstResponder];
                        toolBar.hidden = YES;
                        faceChooseView.hidden = YES;
                        [self getNoteCommentList];
                        int commentCount = [self.dictNote[@"commentNum"] intValue]+1;
                        [self.dictNote setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"commentNum"];
                        
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"评论成功"];
                        
                        lbCount.text = [NSString stringWithFormat:@"  共评论%@条",self.type==1?self.dictNote[@"commentNum"]:self.dictPublic[@"commentNum"]];
                    }
                        break;
                    case 9532:
                    {
                        [field resignFirstResponder];
                        toolBar.hidden = YES;
                        faceChooseView.hidden = YES;
                        [self getPublicCommentList];
                        int commentCount = [self.dictPublic[@"commentNum"] intValue]+1;
                        [self.dictPublic setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"commentNum"];
                        
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"评论成功"];
                        
                        lbCount.text = [NSString stringWithFormat:@"  共评论%@条",self.type==1?self.dictNote[@"commentNum"]:self.dictPublic[@"commentNum"]];
                    }
                        break;
                }
            }
                break;
            case 2:
            {
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

- (void)getCellHeight:(NSMutableArray *)array{
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        NSMutableArray *arrayComment = [[DataUtils sharedInstance] getMessageArray:dict[@"content"]];
        NSString *strName = [NSString stringWithFormat:@"%@:",self.type==1?dict[@"commentUserName"]:dict[@"userNickNames"]];
        [arrayComment insertObject:strName atIndex:0];
        
        CGFloat commentHeight = [[DataUtils sharedInstance] getContentSize:arrayComment width:240];
        [dict setObject:[NSString stringWithFormat:@"%f",commentHeight] forKey:@"commentHeight"];
        
        [dict setObject:[NSString stringWithFormat:@"%f",commentHeight+40] forKey:@"height"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayComments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [arrayComments[indexPath.row][@"height"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell initSelf];
    }
    cell.dictComment = arrayComments[indexPath.row];
    cell.type = self.type;
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - keyboard notification
- (void)showToolBar{
    if (!toolBar) {
        toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        toolBar.backgroundColor = RGB(242, 242, 242);
        
        field = [BeeUITextView spawn];
        field.frame = CGRectMake(50, 10, 180, 30);
        field.placeholder = @"我也来说一句";
        field.font = FONT(14);
        field.backgroundColor = [UIColor whiteColor];
        field.layer.borderWidth = 0.5;
        field.layer.backgroundColor = RGB(167, 167, 167).CGColor;
        [toolBar addSubview:field];
        
        BaseButton *btnFace = [BaseButton initBaseBtn:IMAGESTRING(@"face") highlight:nil];
        btnFace.frame = CGRectMake(0, 0, 50, 50);
        [btnFace addSignal:CommentListBoard.FACE forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btnFace];
        
        BaseButton *btnSend = [BaseButton initBaseBtn:IMAGESTRING(@"btn_send") highlight:IMAGESTRING(@"btn_send_pre") text:@"发表" textColor:[UIColor blackColor] font:FONT(15)];
        btnSend.frame = CGRectMake(240, btnFace.top+10, 70, 30);
        [btnSend addSignal:CommentListBoard.SEND_COMMENT forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btnSend];
    }
    //field.inputAccessoryView = toolBar;
    field.text = @"";
    toolBar.hidden = NO;
    [field becomeFirstResponder];
    [self.view addSubview:toolBar];
}


- (void)chooseFace:(NSString *)strFace{
    field.text = [NSString stringWithFormat:@"%@%@",field.text,strFace];
}

- (void)delFace{
    NSMutableArray *arrayContent = [[DataUtils sharedInstance] getMessageArray:field.text];
    if (arrayContent.count>0) {
        NSString *strLast = [arrayContent lastObject];
        if ([strLast hasPrefix:@"["] && [strLast hasSuffix:@"]"]) {
            field.text = [field.text substringToIndex:field.text.length-strLast.length];
        }
    }
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        CGRect frameView = toolBar.frame;
        
        CGFloat height = [[UIScreen mainScreen] bounds].size.height;
        CGFloat inputHeight = toolBar.height;
        CGFloat y = keyboardBounds.origin.y;
        if (y>height) {
            y = height;
        }
        //CGFloat keyHeight = keyboardBounds.size.height;
        
        frameView.origin.y = y - inputHeight-64;
        //myTableView.frame = CGRectMake(0, 0, self.viewWidth, frameView.origin.y);
        
        //frameView.origin.y = y - inputHeight-20-44;
        //        if (y == height) {
        //            frameView.origin.y = y;
        //        }
        //        else {
        toolBar.frame = frameView;
        //        }
        
        [UIView commitAnimations];
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    }
#endif
}

@end
