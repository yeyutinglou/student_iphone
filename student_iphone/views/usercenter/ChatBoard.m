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
//  ChatBoard.m
//  ClassRoom
//
//  Created by he chao on 14-6-24.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "ChatBoard.h"
//#import "TeamMemberBoard.h"
#import "ChatCell.h"
//#import "FriendSearchBoard.h"
#import "AppDelegate.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
//#import "TeamMemberDelBoard.h"
#import "HPGrowingTextView.h"
#pragma mark -

@interface ChatBoard()<HPGrowingTextViewDelegate>
{
	//add by dyw
    
    HPGrowingTextView *textView;
    BeeUIButton *btnFace;
    BeeUIButton *btnPhoto;
    
}
@end

@implementation ChatBoard
DEF_SIGNAL(FACE)
DEF_SIGNAL(PHOTO)
DEF_SIGNAL(SEND)
DEF_SIGNAL(CAMERA)
DEF_SIGNAL(LOCAL)
DEF_SIGNAL(PHOTO_FULL)

- (void)load
{
}

- (void)unload
{
    [MessageRequest sharedInstance].chatBoard = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self loadContent];
    [self showBackBtn];
    [self clearUnreadCount];
    self.title = self.dictFriend[@"nickName"];
    
    [MessageRequest sharedInstance].chatBoard = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
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
    if (IOS7_OR_LATER) {
        self.view.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight-64);
    }
    myTableView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight-50-64);
    imgToolBar.frame = CGRectMake(0, self.viewHeight-50-64, self.viewWidth, 50);
    [[MessageRequest sharedInstance] setModel:YES];
    //[MessageRequest sharedInstance].chatBoard = self;
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
    [[MessageRequest sharedInstance] setModel:NO];
    [MessageRequest sharedInstance].chatBoard = nil;
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL2( ChatBoard, signal )
{
    if ([signal is:ChatBoard.FACE]) {
//        [field resignFirstResponder];
        [textView resignFirstResponder];
        
        if (!facePageCtrl) {
            facePageCtrl = [[CVScrollPageViewController alloc] init];
        }
        facePageCtrl.frame = CGRectMake(0, self.viewHeight-160-64, self.viewWidth, 160);
        facePageCtrl.view.hidden = NO;
        facePageCtrl.view.backgroundColor = RGB(239, 239, 239);
        [facePageCtrl setDelegate:self];
        facePageCtrl.pageCount = 3;
        facePageCtrl.pageControlFrame = CGRectMake(0, 140, self.viewWidth, 20);
        [facePageCtrl reloadData];
        
        imgToolBar.frame = CGRectMake(0, facePageCtrl.frame.origin.y-imgToolBar.height, imgToolBar.width, imgToolBar.height);
        [self.view addSubview:facePageCtrl.view];
    }
    else if ([signal is:ChatBoard.PHOTO]) {
        BeeUIActionSheet *sheet = [BeeUIActionSheet spawn];
        sheet.title = @"请选择操作";
        [sheet addButtonTitle:@"拍照" signal:ChatBoard.CAMERA];
        [sheet addButtonTitle:@"从相册选择" signal:ChatBoard.LOCAL];
        [sheet addCancelTitle:@"取消"];
        [sheet showInViewController:self];
    }
    else if ([signal is:ChatBoard.CAMERA]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypeCamera;
        //c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
    else if ([signal is:ChatBoard.LOCAL]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
    else if ([signal is:ChatBoard.SEND]) {
        if (facePageCtrl.view.hidden==NO) {
            facePageCtrl.view.hidden = YES;
            imgToolBar.frame = CGRectMake(0, self.viewHeight-imgToolBar.height-(IOS7_OR_LATER?64:44), self.viewWidth, imgToolBar.height);
        }
        
//        [field resignFirstResponder];
        [textView resignFirstResponder];
        
        [self sendMsg];
    }
    else if ([signal is:ChatBoard.PHOTO_FULL]){
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:signal.object]; // 图片路径
        //photo.strDescription = arrayPhotos[i][@"description"];
        photo.srcImageView = signal.source;
        [photos addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }
}

- (void)clearUnreadCount{
    [[MessageDB sharedInstance] updateFriendCountClear:self.dictFriend[@"id"]];
    [self postNotification:kBadge];
}

- (void)didScrollToPageAtIndex:(NSUInteger)index {
}

- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
    UIView *pageView;
    pageView = (UIView *)[scrollPageView dequeueReusablePage:index];
    if (nil == pageView) {
        pageView = [[UIView alloc] initWithFrame:facePageCtrl.view.bounds];
    }
    for (id element in pageView.subviews) {
        [element removeFromSuperview];
    }
    
    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 3; j++) {
            BeeUIButton *btn = [BeeUIButton spawn];
            btn.frame = CGRectMake(i*self.viewWidth/7.0, j*40, self.viewWidth/7.0, self.viewWidth/7.0);
            if (i==6 && j==2) {
                [btn setImage:IMAGESTRING(@"face_del_ico_dafeult.png") forState:UIControlStateNormal];
            }
            else {
                int source = j*7+i+index*20+1;
                btn.tag = source;
                NSString *strSource = [NSString stringWithFormat:@"face_%d",source];
                [btn setImage:IMAGESTRING(strSource) forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clickFace:) forControlEvents:UIControlEventTouchUpInside];
                //[btnFace addSignal:TeamChatBoard.FACE_CHAT forControlEvents:UIControlEventTouchUpInside object:strSource];
            }
            [pageView addSubview:btn];
        }
    }
    return pageView;
}

- (void)clickFace:(BeeUIButton *)btn{
    NSString *strSource = [NSString stringWithFormat:@"face_%d.png",btn.tag];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *dictFace = delegate.dictFace;
    
    NSString *strKey;
    for (int j = 0; j<=[[dictFace allKeys]count]-1; j++) {
        if ([[dictFace objectForKey:[[dictFace allKeys]objectAtIndex:j]] isEqual:strSource]) {
            strKey = [[dictFace allKeys] objectAtIndex:j];
        }
    }
    
//    field.text = [NSString stringWithFormat:@"%@%@",field.text,strKey];
    textView.text = [NSString stringWithFormat:@"%@%@",textView.text,strKey];
    
    [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSend.enabled = YES;
}



- (void)sendMsg{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/talk/send_msg.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"bisId",self.dictFriend[@"id"]).PARAM(@"bisType",@"1").PARAM(@"talkType",@"1").PARAM(@"talkContent",textView.text);//talkType 1文字 2图片 file 图片
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9529;
}

- (void)sendImage:(UIImage *)image{
    [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在发送"];
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/talk/send_msg.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"bisId",self.dictFriend[@"id"]).PARAM(@"bisType",@"1").PARAM(@"talkType",@"2").FILE(@"file",UIImagePNGRepresentation(image));//talkType 1文字 2图片 file 图片
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9530;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        NETWORK_ERROR
    }
    else if (request.succeed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9529:
                    {
//                        field.text = @"";
                        textView.text = @"";
                        NSMutableDictionary *dictMessage = json[@"result"];

                        if ([[NSString stringWithFormat:@"%@",dictMessage[@"sendUserId"]] isEqualToString:kUserInfo[@"id"]]) {
                            [dictMessage setObject:self.dictFriend[@"id"] forKey:@"receiveId"];
                            [dictMessage setObject:self.dictFriend[@"nickName"] forKey:@"friendName"];
                        }

                        [[ChatDB sharedInstance] insert:dictMessage];
                        [self saveMessage:dictMessage];

                        [self receiveMessage:dictMessage];
                        //[self getCellHeight:dictMessage];
                        [arrayMessage addObject:dictMessage];
                        
                        [myTableView reloadData];
                        [self scrollTableToFoot:YES];
                        
                        //                        [[BeeFileCache sharedInstance] setObject:[arrayMessage JSONData] forKey:@"message"];
                    }
                        break;
                    case 9530:
                    {
                        NSMutableDictionary *dictMessage = json[@"result"];

                        if ([[NSString stringWithFormat:@"%@",dictMessage[@"sendUserId"]] isEqualToString:kUserInfo[@"id"]]) {
                            [dictMessage setObject:self.dictFriend[@"id"] forKey:@"receiveId"];
                            [dictMessage setObject:self.dictFriend[@"nickName"] forKey:@"friendName"];
                        }
                        [[ChatDB sharedInstance] insert:dictMessage];
                        [self saveMessage:dictMessage];

                        [self receiveMessage:dictMessage];

                        [arrayMessage addObject:dictMessage];
                        [myTableView reloadData];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
}

- (void)saveMessage:(NSMutableDictionary *)dictMessage{
    NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
    [dictTemp setObject:dictMessage[@"id"] forKey:@"id"];
    [dictTemp setObject:dictMessage[@"sendUserId"] forKey:@"sendId"];
    [dictTemp setObject:dictMessage[@"sendUserName"] forKey:@"sendName"];
    [dictTemp setObject:dictMessage[@"sendUserPic"] forKey:@"sendPic"];
    [dictTemp setObject:@"0" forKey:@"unReadCount"];
    [dictTemp setObject:dictMessage[@"content"] forKey:@"newMessage"];
    [dictTemp setObject:dictMessage[@"sendDate"] forKey:@"sendDate"];
    [dictTemp setObject:dictMessage[@"msgType"] forKey:@"msgType"];
    [dictTemp setObject:dictMessage[@"contentType"] forKey:@"contentType"];

    [dictTemp setObject:self.dictFriend[@"id"] forKey:@"friendId"];
    [dictTemp setObject:dictMessage[@"friendName"] forKey:@"friendName"];
    
    if ([[MessageDB sharedInstance] hasMessage:dictTemp]) {
        [[MessageDB sharedInstance] update:dictTemp];
    }
    else {
        [[MessageDB sharedInstance] insert:dictTemp];
    }
    
}


ON_SIGNAL2( BeeUITextField, signal )
{
    if ([signal is:BeeUITextField.RETURN]) {
        if (textView.text.length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入聊天内容"];
            return;
        }
        [textView resignFirstResponder];
        [self sendMsg];
    }
    else if ([signal is:BeeUITextField.TEXT_CHANGED]) {
        if (textView.text.length==0) {
            [btnSend setTitleColor:RGB(194, 194, 194) forState:UIControlStateNormal];
            btnSend.enabled = NO;
        }
        else {
            [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnSend.enabled = YES;
        }
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
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
        CGRect frameView = imgToolBar.frame;
        
        CGFloat height = [[UIScreen mainScreen] bounds].size.height;
        CGFloat inputHeight = imgToolBar.height;
        CGFloat y = keyboardBounds.origin.y;
        if (y>height) {
            y = height;
        }
        //CGFloat keyHeight = keyboardBounds.size.height;
        
        frameView.origin.y = y - inputHeight-64;
        myTableView.frame = CGRectMake(0, 0, self.viewWidth, frameView.origin.y);
        
        //frameView.origin.y = y - inputHeight-20-44;
        //        if (y == height) {
        //            frameView.origin.y = y;
        //        }
        //        else {
        imgToolBar.frame = frameView;
        //        }
        
        [UIView commitAnimations];
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    }
#endif
}

- (void)loadContent{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-50)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDisapperence)];
    [myTableView addGestureRecognizer:tap];
    
    imgToolBar = [BeeUIImageView spawn];
    imgToolBar.backgroundColor = self.view.backgroundColor;
    imgToolBar.frame = CGRectMake(0, self.viewHeight-50, self.viewWidth, 50);
    imgToolBar.userInteractionEnabled = YES;
    [self.view addSubview:imgToolBar];
    
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.frame = CGRectMake(0, 0, self.viewWidth, 0.5);
    line.backgroundColor = RGB(171, 176, 180);
    [imgToolBar addSubview:line];
    
   btnFace = [BeeUIButton spawn];
    [btnFace setImage:IMAGESTRING(@"chat_face_btn") forState:UIControlStateNormal];
    btnFace.frame = CGRectMake(0, 0, 40, 50);
    [btnFace addSignal:ChatBoard.FACE forControlEvents:UIControlEventTouchUpInside];
    [imgToolBar addSubview:btnFace];
    
//    field = [BeeUITextField spawn];
//    field.frame = CGRectMake(btnFace.right, 10, 183, 30);
//    field.backgroundImage = IMAGESTRING(@"chat_input");
//    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    field.clearButtonMode = UITextFieldViewModeWhileEditing;
//    field.returnKeyType = UIReturnKeySend;
//    field.leftViewMode = UITextFieldViewModeAlways;
//    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
//    field.font = FONT(15);
//    [imgToolBar addSubview:field];
    
//    add by dyw
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(btnFace.right, 10, 183, 30)];
   // textView.backgroundImage = IMAGESTRING(@"chat_input");
    textView.backgroundColor = [UIColor whiteColor];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.returnKeyType = UIReturnKeySend;
    textView.font = FONT(15);
    textView.delegate = self;
     textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    [imgToolBar addSubview:textView];
    
    
    btnPhoto = [BeeUIButton spawn];
    [btnPhoto setImage:IMAGESTRING(@"chat_choose_img") forState:UIControlStateNormal];
    btnPhoto.frame = CGRectMake(textView.right, 0, 38, 50);
    [btnPhoto addSignal:ChatBoard.PHOTO forControlEvents:UIControlEventTouchUpInside];
    [imgToolBar addSubview:btnPhoto];
    
    btnSend = [BeeUIButton spawn];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    btnSend.frame = CGRectMake(btnPhoto.right, 0, self.viewWidth-btnPhoto.right, 50);
    [btnSend addSignal:ChatBoard.SEND forControlEvents:UIControlEventTouchUpInside];
    [btnSend setTitleColor:RGB(194, 194, 194) forState:UIControlStateNormal];
    [btnSend setTitleFont:FONT(15)];
    btnSend.enabled = NO;
    [imgToolBar addSubview:btnSend];
    
    [self loadCache];
}

-(void)didDisapperence{
    [textView resignFirstResponder];
}
- (void)loadCache{

    arrayMessage = [[ChatDB sharedInstance] queryFriendMessage:self.dictFriend[@"id"]];

    
    for (int i = 0; i < arrayMessage.count; i++) {
        NSMutableDictionary *dictMessage = arrayMessage[i];
        [self getCellHeight:dictMessage];
        BOOL isShow = NO;
        if (i == 0) {
            isShow = YES;
            
        }
        else {
            NSString *format = @"yyyyMMdd HH:mm:ss";
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:format];
            
            NSString *dt1 = arrayMessage[i][@"sendDate"];
            NSString *dt2 = arrayMessage[i-1][@"sendDate"];
            NSDate *date1 = [formatter dateFromString:dt1];
            NSDate *date2 = [formatter dateFromString:dt2];
            NSTimeInterval t = [date2 timeIntervalSinceDate:date1];
            int fabsT = fabs(t);
            if (fabsT/(5*60)>0) {
                isShow = YES;
            }
        }
        if (isShow) {
            int height = [dictMessage[@"height"] intValue];
            height += 30;
            [dictMessage setObject:[NSString stringWithFormat:@"%d",height] forKey:@"height"];
            [dictMessage setObject:@YES forKey:@"showTime"];
        }
        else {
            [dictMessage setObject:@NO forKey:@"showTime"];
        }
        
    }
    
    [myTableView reloadData];
    [self scrollTableToFoot:YES];
}

- (void)receiveMessage:(NSMutableDictionary *)dictMessage{
    [self getCellHeight:dictMessage];
    
    BOOL isShow = NO;
    if (arrayMessage.count == 0) {
        isShow = YES;
        
    }
    else {
        NSString *format = @"yyyyMMdd HH:mm:ss";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        
        NSString *dt1 = dictMessage[@"sendDate"];
        NSString *dt2 = [arrayMessage lastObject][@"sendDate"];
        NSDate *date1 = [formatter dateFromString:dt1];
        NSDate *date2 = [formatter dateFromString:dt2];
        NSTimeInterval t = [date2 timeIntervalSinceDate:date1];
        int fabsT = fabs(t);
        if (fabsT/(5*60)>0) {
            isShow = YES;
        }
    }
    if (isShow) {
        int height = [dictMessage[@"height"] intValue];
        height += 30;
        [dictMessage setObject:[NSString stringWithFormat:@"%d",height] forKey:@"height"];
        [dictMessage setObject:@YES forKey:@"showTime"];
    }
    else {
        [dictMessage setObject:@NO forKey:@"showTime"];
    }
    
}

- (void)getCellHeight:(NSMutableDictionary *)dictMessage{
    switch ([dictMessage[@"contentType"] integerValue]) {
        case 1:
        {
            MojiView *mojiView = [[MojiView alloc] init];
            [mojiView setContent:dictMessage[@"content"] maxWidth:150];
            
            int height = 70;
            if (mojiView.height+40>70) {
                height = mojiView.height+40;
            }
            [dictMessage setObject:[NSString stringWithFormat:@"%d",height] forKey:@"height"];
        }
            break;
        case 2:
        {
            [dictMessage setObject:@"115" forKey:@"height"];
        }
            break;
        case 3:
        {
            [dictMessage setObject:@"25" forKey:@"height"];
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayMessage count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [arrayMessage[indexPath.row][@"height"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.isFriendChat = YES;
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictMessage = arrayMessage[indexPath.row];
    [cell load];
    return cell;
}


- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [myTableView numberOfSections];
	if (s<1) return;
	NSInteger r = [myTableView numberOfRowsInSection:s-1];
	if (r<1) return;
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
	
	[myTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}








#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    UIImage * i = [info[@"UIImagePickerControllerOriginalImage"] copy];
    if(i.size.width > 640)
    {
        i = [self scaleImage:i toScale:640/i.size.width];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self sendImage:i];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark -- HPGrowingTextViewDelegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = imgToolBar.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    imgToolBar.frame = r;
    CGRect face = btnFace.frame;
    face.origin.y =  r.size.height - face.size.height;
    btnFace.frame = face;
    CGRect photo = btnPhoto.frame;
    photo.origin.y =  r.size.height - photo.size.height;
    btnPhoto.frame = photo;
    CGRect send = btnSend.frame;
    send.origin.y =  r.size.height - send.size.height;
    btnSend.frame = send;
}


-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    if (textView.text.length==0) {
        [btnSend setTitleColor:RGB(194, 194, 194) forState:UIControlStateNormal];
        btnSend.enabled = NO;
    }
    else {
        [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnSend.enabled = YES;
    }

}

@end
