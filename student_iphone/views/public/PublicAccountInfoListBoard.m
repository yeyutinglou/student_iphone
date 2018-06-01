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
//  PublicAccountInfoListBoard.m
//  ClassRoom
//
//  Created by he chao on 6/23/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "PublicAccountInfoListBoard.h"
#import "PublicAccountInfoCell.h"
#import "PublicIntroBoard.h"
#import "CommentListBoard.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#pragma mark -

@interface PublicAccountInfoListBoard()
{
	//<#@private var#>
}
@end

@implementation PublicAccountInfoListBoard
DEF_SIGNAL(COMMENT_ALL)
DEF_SIGNAL(COMMENT)
DEF_SIGNAL(FACE)
DEF_SIGNAL(SEND)

- (void)load
{
    arrayMsgList = [[NSMutableArray alloc] init];
    pageOffset = 0;
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    
    [self showNaviBar];
    [self showBackBtn];
    self.title = self.dictInfo[@"publicOrgName"];//self.dictInfo[@"name"];
    
    [self showBarButton:UINavigationBar.BARBUTTON_RIGHT image:IMAGESTRING(@"navi_info")];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] init];
    PublicAccountInfoListBoard *board = self;
    [myTableView addInfiniteScrollingWithActionHandler:^{
        [board moreData];
    }];
    [myTableView addPullToRefreshWithActionHandler:^{
        [board refreshData];
    }];
    [self refreshData];
    [self.view addSubview:myTableView];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    self.title = self.dictInfo[@"publicOrgName"];//self.dictInfo[@"name"];
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
    PublicIntroBoard *board = [[PublicIntroBoard alloc] init];
    //board.dictInfo = self.dictInfo;
    board.isInfoEnter = YES;
    board.strPublicOrgId = self.dictInfo[@"publicOrgId"];
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL2(PublicAccountInfoListBoard, signal) {
    if ([signal is:PublicAccountInfoListBoard.COMMENT_ALL]) {
        CommentListBoard *board = [[CommentListBoard alloc] init];
        board.type = 2;
        board.dictPublic = signal.object;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:PublicAccountInfoListBoard.COMMENT]) {
        dictSelPublicInfo = signal.object;
        [self showToolBar];
    }
    else if ([signal is:PublicAccountInfoListBoard.FACE]) {
        if (!faceChooseView) {
            faceChooseView = [[FaceSelectView alloc] initWithFrame:CGRectMake(0, [MainBoard sharedInstance].viewHeight-160, [MainBoard sharedInstance].viewWidth, 160)];
            faceChooseView.mainCtrl = self;
            [faceChooseView loadContent];
        }
        [field resignFirstResponder];
        faceChooseView.hidden = NO;
        [[MainBoard sharedInstance].view addSubview:faceChooseView];
        
        toolBar.frame = CGRectMake(0, faceChooseView.top-toolBar.height-50-64, toolBar.width, toolBar.height);
    }
    else if ([signal is:PublicAccountInfoListBoard.SEND]) {
        if (kStrTrim(field.text).length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入评论内容"];
            return;
        }
        [field resignFirstResponder];
        faceChooseView.hidden = YES;
        toolBar.hidden = YES;
        
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/add_public_org_msg_comment.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"content",field.text).PARAM(@"publicOrgId",dictSelPublicInfo[@"publicOrgId"]).PARAM(@"publicOrgMsgId",dictSelPublicInfo[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9528;
    }
}

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
        field.returnKeyType = UIReturnKeyDone;
        [toolBar addSubview:field];
        
        BaseButton *btnFace = [BaseButton initBaseBtn:IMAGESTRING(@"face") highlight:nil];
        btnFace.frame = CGRectMake(0, 0, 50, 50);
        [btnFace addSignal:PublicAccountInfoListBoard.FACE forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btnFace];
        
        BaseButton *btnSend = [BaseButton initBaseBtn:IMAGESTRING(@"btn_send") highlight:IMAGESTRING(@"btn_send_pre") text:@"发表" textColor:[UIColor blackColor] font:FONT(15)];
        btnSend.frame = CGRectMake(240, btnFace.top+10, 70, 30);
        [btnSend addSignal:PublicAccountInfoListBoard.SEND forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btnSend];
    }
    //field.inputAccessoryView = toolBar;
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


- (void)refreshData{
    pageOffset = 0;
    //BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/get_public_org_msg_list.action"]].PARAM(@"pageSize",INTTOSTRING(pageSize)).PARAM(@"pageOffset",INTTOSTRING(pageOffset)).PARAM(@"publicOrgId",self.dictInfo[@"id"]).PARAM(@"id",kUserInfo[@"id"]);
    //request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/get_public_org_msg_list.action"]].PARAM(@"pageSize",INTTOSTRING(pageSize)).PARAM(@"pageOffset",INTTOSTRING(pageOffset)).PARAM(@"publicOrgId",self.dictInfo[@"publicOrgId"]).PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)moreData{
    pageOffset += pageSize;
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/get_public_org_msg_list.action"]].PARAM(@"pageSize",INTTOSTRING(pageSize)).PARAM(@"pageOffset",INTTOSTRING(pageOffset)).PARAM(@"publicOrgId",self.dictInfo[@"publicOrgId"]).PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        [self closeAnimating];
        NETWORK_ERROR
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {
        if (myTableView) {
            [myTableView.pullToRefreshView stopAnimating];
            [myTableView.infiniteScrollingView stopAnimating];
        }
        //[self closeAnimating];
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
                        if (pageOffset==0) {
                            [arrayMsgList removeAllObjects];
                        }
                        NSMutableArray *array = json[@"result"];
                        [self getCellHeight:array];
                        [arrayMsgList addObjectsFromArray:array];
                        [myTableView reloadData];
                    }
                        break;
                    case 9528:
                    {
                        field.text = @"";
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"评论成功"];
                        [self refreshData];
                    }
                        break;
                }
            }
                break;
            case 2:
            {
                if (pageOffset== 0) {
                    [[BeeUITipsCenter sharedInstance] presentMessageTips:@"暂没有公众号信息"];
                }
                else {
                    [[BeeUITipsCenter sharedInstance] presentMessageTips:@"没有更多查询结果"];
                }
                
            }
                break;
        }
    }
}

- (void)getCellHeight:(NSMutableArray *)array{
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        NSMutableArray *arrayContent = [[DataUtils sharedInstance] getMessageArray:dict[@"content"]];
        CGFloat height = [[DataUtils sharedInstance] getContentSize:arrayContent width:270];
        [dict setObject:[NSString stringWithFormat:@"%f",height] forKey:@"contentHeight"];
        
        CGFloat cellHeight = 35;
        cellHeight += height;
        
        int picCount = [dict[@"pics"] count];
        if (picCount>0) {
            int count = ceil(picCount/3.0);
            cellHeight += 55*count;
        }
        
        int commentCount = [dict[@"commentNum"] intValue];
        
        if (commentCount>0) {
            NSMutableArray *comments = dict[@"comments"];
            for (int j = 0; j < comments.count; j++) {
                NSMutableDictionary *dictComment = comments[j];
                NSString *strName = [NSString stringWithFormat:@"%@:",dictComment[@"userNickNames"]];
                NSMutableArray *arrayComment = [[DataUtils sharedInstance] getMessageArray:dictComment[@"content"]];
                [arrayComment insertObject:strName atIndex:0];
                CGFloat commentHeight = [[DataUtils sharedInstance] getContentSize:arrayComment width:270];
                [dictComment setObject:[NSString stringWithFormat:@"%f",commentHeight] forKey:@"commentHeight"];
                
                cellHeight += commentHeight;
            }
            if (commentCount>5) {
                cellHeight += 40;
            }
        }
        
        [dict setObject:[NSString stringWithFormat:@"%f",cellHeight] forKey:@"height"];
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayMsgList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [arrayMsgList[indexPath.row][@"height"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicAccountInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[PublicAccountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell initSelf];
    }
    cell.board = self;
    cell.dictInfo = arrayMsgList[indexPath.row];
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
