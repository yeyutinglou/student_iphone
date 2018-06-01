//
//  PublicInfoView.m
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "PublicInfoView.h"
#import "PublicInfoCell.h"
#import "PublicBoard.h"
#import "CommentListBoard.h"
#import "PublicAccountInfoListBoard.h"

@implementation PublicInfoView

DEF_SIGNAL(COMMENT)
DEF_SIGNAL(COMMENT_ALL)
DEF_SIGNAL(FACE)
DEF_SIGNAL(SEND)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pageOffset = 0;
        arrayPublicMsg = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

ON_SIGNAL2(BeeUITextField, signal) {
    if ([signal is:BeeUITextField.WILL_ACTIVE]) {
        faceChooseView.hidden = YES;
    }
}

ON_SIGNAL2(PublicInfoView, signal){
    if ([signal is:PublicInfoView.COMMENT]) {
        dictSelPublicInfo = signal.object;
        [self showToolBar];
    }
    else if ([signal is:PublicInfoView.COMMENT_ALL]) {
        CommentListBoard *board = [[CommentListBoard alloc] init];
        board.type = 2;
        board.dictPublic = signal.object;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
    else if ([signal is:PublicInfoView.FACE]) {
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
    else if ([signal is:PublicInfoView.SEND]) {
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

- (void)refresh{
    [self refreshData];
}

- (void)loadContent{
    myTableView = [[UITableView alloc] initWithFrame:self.bounds];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] init];
    
    PublicInfoView *board = self;
    [myTableView addInfiniteScrollingWithActionHandler:^{
        [board moreData];
    }];
    [myTableView addPullToRefreshWithActionHandler:^{
        [board refreshData];
    }];
    
    
    [self addSubview:myTableView];
    
    
    
    [self getPublicMsgList];
}

- (void)refreshData{
    pageOffset = 0;
    [self getPublicMsgList];
}

- (void)moreData{
    pageOffset += pageSize;
    [self getPublicMsgList];
}

- (void)getPublicMsgList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/publicorg/get_all_public_org_msg_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"pageOffset",INTTOSTRING(pageOffset)).PARAM(@"pageSize",INTTOSTRING(pageSize));
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
        //id json = [request.responseString mutableObjectFromJSONString];
        NSString *tmpStr  = [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        //tmpStr = [tmpStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                        
                        if (pageOffset==0) {
                            [arrayPublicMsg removeAllObjects];
                        }
                        NSMutableArray *array = json[@"result"];
                        [self getCellHeight:array];
                       // [arrayPublicMsg addObjectsFromArray:array];
                        [myTableView reloadData];
                    }
                        break;
                    case 9528:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"评论成功"];
                        [self getPublicMsgList];
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
                
        }
    }
}
-(NSMutableDictionary *)addHeightInDic:(NSDictionary *)dic height:(CGFloat)height array:(NSArray *)arr contentHeight:(float)contentHeight{
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
    [newDic setObject:dic[@"commentNum"] forKey:@"commentNum"];
    if (arr.count) {
        [newDic setObject:arr forKey:@"comments"];
    }else{
        [newDic setObject:dic[@"comments"] forKey:@"comments"];
    }
    
    [newDic setObject:dic[@"content"] forKey:@"content"];
    [newDic setObject:dic[@"createDate"] forKey:@"createDate"];
    [newDic setObject:dic[@"createUserId"] forKey:@"createUserId"];
    [newDic setObject:dic[@"picNum"] forKey:@"picNum"];
    [newDic setObject:dic[@"pics"] forKey:@"pics"];
    [newDic setObject:dic[@"publicOrgId"] forKey:@"publicOrgId"];
    [newDic setObject:dic[@"publicOrgName"] forKey:@"publicOrgName"];
    [newDic setObject:dic[@"publicOrgPic"] forKey:@"publicOrgPic"];
    [newDic setObject:dic[@"id"] forKey:@"id"];
    [newDic setObject:[NSString stringWithFormat:@"%f",height] forKey:@"height"];
    [newDic setObject:[NSString stringWithFormat:@"%f",contentHeight] forKey:@"contentHeight"];
    
    return newDic;
    
}

-(NSMutableDictionary *)addCommentsHeightInDic:(NSMutableDictionary *)dic height:(CGFloat)commentHeight{
    NSMutableDictionary *comDic = [[NSMutableDictionary alloc] init];
    [comDic setObject:dic[@"content"] forKey:@"content"];
    [comDic setObject:dic[@"createDate"] forKey:@"createDate"];
    [comDic setObject:dic[@"userId"] forKey:@"userId"];
    [comDic setObject:dic[@"userPicUrl"] forKey:@"userPicUrl"];
    [comDic setObject:dic[@"publicOrgId"] forKey:@"publicOrgId"];
    [comDic setObject:dic[@"userNickName"] forKey:@"userNickName"];
    [comDic setObject:dic[@"publicOrgMsgId"] forKey:@"publicOrgMsgId"];
    [comDic setObject:dic[@"id"] forKey:@"id"];
    [comDic setObject:[NSString stringWithFormat:@"%f",commentHeight] forKey:@"commentHeight"];
    
    
    return comDic;
}

- (void)getCellHeight:(NSMutableArray *)array{
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        NSMutableArray *arrayContent = [[DataUtils sharedInstance] getMessageArray:dict[@"content"]];
        CGFloat height = [[DataUtils sharedInstance] getContentSize:arrayContent width:240];
       // [dict setObject:[NSString stringWithFormat:@"%f",height] forKey:@"contentHeight"];
        
        CGFloat cellHeight = 50;
        cellHeight += height;
        
        int picCount = [dict[@"pics"] count];
        if (picCount>0) {
            int count = ceil(picCount/3.0);
            cellHeight += 55*count;
        }
        
        int commentCount = [dict[@"commentNum"] intValue];
        NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic;
        if (commentCount>0) {
            NSMutableArray *comments = dict[@"comments"];
            for (int j = 0; j < comments.count; j++) {
                NSMutableDictionary *dictComment = comments[j];
                NSString *strName = [NSString stringWithFormat:@"%@:",dictComment[@"userNickNames"]];
                NSMutableArray *arrayComment = [[DataUtils sharedInstance] getMessageArray:dictComment[@"content"]];
                [arrayComment insertObject:strName atIndex:0];
                CGFloat commentHeight = [[DataUtils sharedInstance] getContentSize:arrayComment width:240];
                //[dictComment setObject:[NSString stringWithFormat:@"%f",commentHeight] forKey:@"commentHeight"];
                NSMutableDictionary *commentDic = [self addCommentsHeightInDic:dictComment height:commentHeight];
                [commentsArray addObject:commentDic];
                cellHeight += commentHeight;
            }
            if (commentCount>5) {
                cellHeight += 40;
            }
        }
        
        //[dict setObject:[NSString stringWithFormat:@"%f",cellHeight] forKey:@"height"];
        dic = [self addHeightInDic:dict height:cellHeight array:commentsArray contentHeight:height];
        [arrayPublicMsg addObject:dic];
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
        [btnFace addSignal:PublicInfoView.FACE forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btnFace];
        
        BaseButton *btnSend = [BaseButton initBaseBtn:IMAGESTRING(@"btn_send") highlight:IMAGESTRING(@"btn_send_pre") text:@"发表" textColor:[UIColor blackColor] font:FONT(15)];
        btnSend.frame = CGRectMake(240, btnFace.top+10, 70, 30);
        [btnSend addSignal:PublicInfoView.SEND forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btnSend];
    }
    //field.inputAccessoryView = toolBar;
    toolBar.hidden = NO;
    [field becomeFirstResponder];
    [self addSubview:toolBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayPublicMsg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 100+300;
    return [arrayPublicMsg[indexPath.row][@"height"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[PublicInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell initSelf];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictInfo = arrayPublicMsg[indexPath.row];
    cell.board = self.publicBoard;
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PublicAccountInfoListBoard *board = [[PublicAccountInfoListBoard alloc] init];
//    board.dictInfo = arrayPublicMsg[indexPath.row];
//    [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    toolBar.hidden = YES;
    field.text = @"";
    [field resignFirstResponder];
    faceChooseView.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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
        
        frameView.origin.y = y - inputHeight-64-50;
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
