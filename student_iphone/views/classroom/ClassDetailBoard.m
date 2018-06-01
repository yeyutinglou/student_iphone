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
//  ClassDetailBoard.m
//  ClassRoom
//
//  Created by he chao on 14-6-30.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "ClassDetailBoard.h"
#import "ClassDetailCell.h"
#import "CheckinBoard.h"
#import "PlayViewController.h"
#import "PublishMediaBoard.h"
#import "CommentListBoard.h"
#import "StudentListBoard.h"
#import "StarPopupView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PreviewDataSource.h"
#import "JSPlaybackCourseViewController.h"
#import "JYDModelLocator.h"

#pragma mark -

@interface ClassDetailBoard()<UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
	//<#@private var#>
    //add by zhaojian
    PreviewDataSource *dataSource;
    UIView *customPicker;
    UIPickerView *pickView;
    NSArray *labelTitle;
    BeeUIImageView *imageView;
    BeeUILabel *lab1;
    BeeUILabel *lab2;
    BeeUILabel *lab3;
    
    
}
//add by zhaojian
AS_SIGNAL(PICKVIEW_CANCEL)
AS_SIGNAL(PICKVIEW_OK)
AS_SIGNAL(PICKVIEW_SHOW)

@end

@implementation ClassDetailBoard
DEF_SIGNAL(PRE)
DEF_SIGNAL(CHOOSE)
DEF_SIGNAL(NEXT)
DEF_SIGNAL(CENTER)
DEF_SIGNAL(CLOSE)
DEF_SIGNAL(ORDER)
DEF_SIGNAL(COMMENT)
DEF_SIGNAL(COMMENT_ALL)
DEF_SIGNAL(SEND_COMMENT)
DEF_SIGNAL(DEL)
DEF_SIGNAL(DEL_ALERT)
DEF_SIGNAL(LIKE)
DEF_SIGNAL(PLAY_VIDEO)
DEF_SIGNAL(FACE)
DEF_SIGNAL(HIDE)
DEF_SIGNAL(STAR)
DEF_SIGNAL(EVALUATE)
DEF_SIGNAL(OPEN_FILE)
DEF_SIGNAL(RELOAD_COUNT)
//add by zhaojian
DEF_SIGNAL(PICKVIEW_CANCEL)
DEF_SIGNAL(PICKVIEW_OK)
DEF_SIGNAL(PICKVIEW_SHOW)

- (void)load
{
    isHot = YES;
    arrayCourseNote = [[NSMutableArray alloc] init];
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    self.title = self.dictCourse[@"courseName"];
    dictSelCourse = self.dictCourse;
    [self showBarButton:BeeUINavigationBar.RIGHT image:IMAGESTRING(@"navi_add_note")];
    [self loadContent];
    //add by zhaojian
    [self createPickerView];
    
    [self showStarInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReloadCount:) name:@"reloadCount" object:nil];
}

-(void)didReloadCount:(NSNotification *)tif{
    NSDictionary * dic = tif.object;
    [self getCourseCount:dic[@"courseSchedId"]];
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
    [self getCourseNote:dictSelCourse[@"id"]];
    [self getCourseCount:dictSelCourse[@"id"]];
    
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
    /**
     * 点击添加笔记
     */
    PublishMediaBoard *board = [[PublishMediaBoard alloc] init];
    board.dictCourse = dictSelCourse;//self.dictCourse;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL2(BeeUIPickerView, signal){
    if ([signal is:BeeUIPickerView.CONFIRMED]) {
        BeeUIPickerView *picker = signal.source;
        selIndex = [picker selectedRowInComponent:0];
        dictSelCourse = arrayCourseCharacters[selIndex];
        lbSelected.text = [NSString stringWithFormat:@"%@%@第%@节",[dictSelCourse[@"teachTime"] substringFromIndex:5],dictSelCourse[@"weekDay"],dictSelCourse[@"orderNumChar"]];
        
        /**
         *  获取对应的课程笔记
         */
        [self getCourseNote:dictSelCourse[@"id"]];
        [self getCourseCount:dictSelCourse[@"id"]];
        [self showStarInfo];
    }
}

ON_SIGNAL2(BeeUITextField, signal) {
    if ([signal is:BeeUITextField.WILL_ACTIVE]) {
        faceChooseView.hidden = YES;
    }
}

ON_SIGNAL2(ClassDetailBoard, signal) {
    if ([signal is:ClassDetailBoard.PRE]) {
        [self sendUISignal:ClassDetailBoard.HIDE];
        int index = [dictSelCourse[@"orderNum"] intValue]-1;
        if (index == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"没有上一节了"];
            return;
        }
        
        dictSelCourse = arrayCourseCharacters[index-1];
        selIndex = index-1;
        lbSelected.text = [NSString stringWithFormat:@"%@%@第%@节",[dictSelCourse[@"teachTime"] substringFromIndex:5],dictSelCourse[@"weekDay"],dictSelCourse[@"orderNumChar"]];
        
        [self getCourseNote:dictSelCourse[@"id"]];
        [self getCourseCount:dictSelCourse[@"id"]];
        
        [self showStarInfo];
        
    }
    else if ([signal is:ClassDetailBoard.CHOOSE]) {
        //点击弹出ActionSheet选择讲、列表
        if (!arrayCourseCharacters) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"正在获取节数列表"];
            return;
        }
        
        JYDLog(@"第%@讲",  arrayCourseCharacters[0][@"orderNum"]);
       
        [self sendUISignal:ClassDetailBoard.HIDE];
        //以下commentted by zhaojian
//        BeeUIPickerView *pickerView = [BeeUIPickerView spawn];
//        for (int i = 0; i < arrayCourseCharacters.count; i++) {
//            [pickerView addTitle:[NSString stringWithFormat:@"第%@讲",arrayCourseCharacters[i][@"orderNum"]]];
//        }
//        [pickerView selectRow:selIndex inComponent:0 animated:YES];
//        [pickerView showInViewController:self];
//        [pickerView reloadAllComponents];
        [pickView reloadAllComponents];
        [self sendUISignal:ClassDetailBoard.PICKVIEW_SHOW];
        [pickView selectRow:selIndex inComponent:0 animated:YES];
    }
    
    else if ([signal is:ClassDetailBoard.NEXT]) {
        [self sendUISignal:ClassDetailBoard.HIDE];
        int index = [dictSelCourse[@"orderNum"] intValue];
        if (index == arrayCourseCharacters.count) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"没有下一节了"];
            return;
        }
        
        dictSelCourse = arrayCourseCharacters[index];
        selIndex = index;
        lbSelected.text = [NSString stringWithFormat:@"%@%@第%@节",[dictSelCourse[@"teachTime"] substringFromIndex:5],dictSelCourse[@"weekDay"],dictSelCourse[@"orderNumChar"]];
        [self getCourseNote:dictSelCourse[@"id"]];
        [self getCourseCount:dictSelCourse[@"id"]];
        [self showStarInfo];
    }
    else if ([signal is:ClassDetailBoard.ORDER]) {
        [self sendUISignal:ClassDetailBoard.HIDE];
        isHot = !isHot;
        [btnOrder setImage:isHot?IMAGESTRING(@"hot"):IMAGESTRING(@"time2") forState:UIControlStateNormal];
        [self getCourseNote:dictSelCourse[@"id"]];
        [self getCourseCount:dictSelCourse[@"id"]];
    }
    else if ([signal is:ClassDetailBoard.OPEN_FILE]){
        NSString *strKey = signal.object;
        QLPreviewController *previewCtrl = [[QLPreviewController alloc] init];
        //以下两行commenttd by zhaojian
        //previewCtrl.delegate = self;
        //PreviewDataSource *dataSource = [[PreviewDataSource alloc] init];
        if (dataSource == nil) {
            dataSource = [[PreviewDataSource alloc]init];
        }
        dataSource.path = [[BeeFileCache sharedInstance] fileNameForKey:strKey];//[[NSBundle mainBundle] pathForResource:@"5" ofType:@"pptx"];
        JYDLog(@"dataSource.path:%@", dataSource.path);
        previewCtrl.dataSource = dataSource;
        [self presentViewController:previewCtrl animated:YES completion:^{
            
        }];
    }
    else if ([signal is:ClassDetailBoard.CENTER]) {
        [self sendUISignal:ClassDetailBoard.HIDE];
        
        UIView *vi = signal.object;
        switch (vi.tag) {
            case 0:
            {
                [self getCourseVideo:dictSelCourse[@"id"]];
//                PlayViewController *controller = [[PlayViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8"]];
//                [self presentMoviePlayerViewControllerAnimated:controller];
            }
                break;
            case 1:
            {
                [self getCourseResource:dictSelCourse[@"id"]];
//                downloadPopupView = [[DownloadPopupView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
//                [downloadPopupView loadContent];
//                [self.view addSubview:downloadPopupView];
            }
                break;
            case 2:
            {
//                if (isTeacher) {
//                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                    [formatter setDateFormat:@"yyyyMMdd HH:mm"];
//                    
//                    NSDate *dateBegin = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",dictSelCourse[@"teachTime"],dictSelCourse[@"classBeginTime"]]];
//                    
//                    NSTimeInterval secondBegin = [dateBegin timeIntervalSinceNow];
//                    if (secondBegin>0) {
//                        [BeeUIAlertView showMessage:@"课程未开始,暂时无法点名" cancelTitle:@"确定"];
//                        return;
//                    }
//                    CheckinBoard *board = [[CheckinBoard alloc] init];
//                    board.dictCourse = dictSelCourse;//self.dictCourse;
//                    [self.stack pushBoard:board animated:YES];
//                }
//                else {
                    StudentListBoard *board = [[StudentListBoard alloc] init];
                    board.dictCourse = dictSelCourse;
                    [self.stack pushBoard:board animated:YES];
//                }
                
            }
                break;
                
            default:
                break;
        }
    }
    else if ([signal is:ClassDetailBoard.CLOSE]) {
        NSNumber *status = signal.object;
        if ([status boolValue]) {
            [videoPopupView removeFromSuperview];
        }
        else
        {
            if ([JYDModelLocator shareModelLocator].isDownloading)
            {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请耐心等待下载..."];
                return;
            }
            
            [downloadPopupView removeFromSuperview];
        }
    }
    else if ([signal is:ClassDetailBoard.COMMENT]) {
        dictSelNote = signal.object;
        [self showToolBar];
    }
    else if ([signal is:ClassDetailBoard.COMMENT_ALL]){
        dictSelNote = signal.object;
        CommentListBoard *board = [[CommentListBoard alloc] init];
        board.dictNote = dictSelNote;
        board.type = 1;
        [self.stack pushBoard:board animated:YES];
    }
    else if ([signal is:ClassDetailBoard.SEND_COMMENT]) {
        if (kStrTrim(field.text).length==0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请输入评论内容"];
            return;
        }
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/add_course_note_comment.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",dictSelNote[@"id"]).PARAM(@"content",field.text);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9532;
    }
    else if ([signal is:ClassDetailBoard.DEL_ALERT]){
        BeeUIAlertView *alert = [BeeUIAlertView spawn];
        [alert setTitle:@"您确认删除此课堂笔记?"];
        [alert addCancelTitle:@"取消"];
        [alert addButtonTitle:@"删除" signal:ClassDetailBoard.DEL object:signal.object];
        [alert showInViewController:self];
    }
    else if ([signal is:ClassDetailBoard.DEL]) {
        dictSelNote = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/del_course_note.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",dictSelNote[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9531;
    }
    else if ([signal is:ClassDetailBoard.LIKE]){
        dictSelNote = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/add_note_praise.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseNoteId",dictSelNote[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9533;
    }
    else if ([signal is:ClassDetailBoard.PLAY_VIDEO]){
        //NSString *strUrl = signal.object;
        //PlayViewController *controller = [[PlayViewController alloc] initWithContentURL:[NSURL URLWithString:strUrl]];
        //[self presentMoviePlayerViewControllerAnimated:controller];
        
        
        //add by zhaojian
        NSMutableDictionary *dictResource = signal.object;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"%@%@",kVeUrl,kVideoType];
        [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"STATUS"] isEqualToString :STATUS_SUCCESS]) {
                JSPlaybackCourseViewController *mCtr = [[JSPlaybackCourseViewController alloc]init];
                //课程唯一ID:@"958B56CBAC01491C85154784AA64EEF8"
                mCtr.course_id = dictResource[@"uuid"];
                //学校服务器地址:@"http://192.168.11.14:8089/JSmaster/"
                mCtr.schoolServerAddress = dictResource[@"masterUrl"];
                //打点信息服务器地址:@"http://192.168.11.14:88/ve/"
                mCtr.veServerAddress = dictResource[@"veUrl"];
                
                /**
                 *  视频类型获取
                 */
                mCtr.videoType = responseObject[@"result"][0][@"menu_type"];
                mCtr.dic = dictResource;
                [self presentViewController:mCtr animated:YES completion:nil];

            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
    else if ([signal is:ClassDetailBoard.FACE]){
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
    else if ([signal is:ClassDetailBoard.HIDE]) {
        [field resignFirstResponder];
        faceChooseView.hidden = YES;
        toolBar.hidden = YES;
    }
    else if ([signal is:ClassDetailBoard.STAR]) {
        StarPopupView *starView = [[StarPopupView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
        [starView loadContent];
        [self.view addSubview:starView];
    }
    else if ([signal is:ClassDetailBoard.EVALUATE]) {
        StarPopupView *starView = signal.object;
        if (!starView.score) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请选择评分"];
            return;
        }
        [starView removeFromSuperview];
        NSString *strScore = [NSString stringWithFormat:@"%@",starView.score];
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/add_evaluate.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dictSelCourse[@"courseId"]).PARAM(@"courseSchedId",dictSelCourse[@"id"]).PARAM(@"score",strScore);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9534;
    }
    //add by zhaojian
    else if ([signal is:ClassDetailBoard.PICKVIEW_CANCEL]) {
        [UIView animateWithDuration:0.3 animations:^{
            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewWidth, customPicker.height);
        } completion:^(BOOL finished) {
            customPicker.hidden = YES;
            myTableView.userInteractionEnabled = YES;
        }];
    }
    else if ([signal is:ClassDetailBoard.PICKVIEW_OK]) {
        [UIView animateWithDuration:0.3 animations:^{
            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewWidth, customPicker.height);
        } completion:^(BOOL finished) {
            customPicker.hidden = YES;
            myTableView.userInteractionEnabled = YES;
        }];
        
        [myTableView reloadData];
    }
    else if ([signal is:ClassDetailBoard.PICKVIEW_SHOW]) {
        myTableView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            customPicker.hidden = NO;
            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-customPicker.height, self.viewWidth, customPicker.height);
        } completion:^(BOOL finished) {
            
        }];
        [pickView reloadAllComponents];
    }else if ([signal is:ClassDetailBoard.RELOAD_COUNT]){
        NSDictionary *dic = signal.object;
        [self getCourseCount:dic[@""]];
        
    }
    
}

- (void)showStarInfo{
//    if (isTeacher) {
//        info.hidden = YES;
//        if ([dictSelCourse[@"evaluateScore"] floatValue]==0.0) {
//            stars.hidden = YES;
//        }
//        else {
//            [stars loadContent:[NSString stringWithFormat:@"%@",dictSelCourse[@"evaluateScore"]]];
//        }
//    }
//    else {
        if ([dictSelCourse[@"evaluateStatus"] boolValue]) {
            info.hidden = YES;
            [stars loadContent:[NSString stringWithFormat:@"%@",dictSelCourse[@"evaluateScore"]]];
        }
        else {
            info.hidden = NO;
            stars.hidden = YES;
        }
//    }
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

- (void)loadContent{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    
    BeeUIImageView *header = [BeeUIImageView spawn];
    header.frame = CGRectMake(0, 0, self.viewWidth, 45);
    header.backgroundColor = RGB(236, 236, 236);
    header.userInteractionEnabled = YES;
    [self.view addSubview:header];
    
    BaseButton *btnPre = [BaseButton initBaseBtn:IMAGESTRING(@"class_btn") highlight:nil text:@"上一节" textColor:RGB(120, 120, 120) font:FONT(15)];
    [btnPre addSignal:ClassDetailBoard.PRE forControlEvents:UIControlEventTouchUpInside];
    btnPre.frame = CGRectMake(10, 5, 68, 35);
    [header addSubview:btnPre];
    
    BaseButton *btnCenter = [BaseButton initBaseBtn:IMAGESTRING(@"class_middle_btn") highlight:nil];
    btnCenter.frame = CGRectMake(btnPre.right+10, btnPre.top, 144, btnPre.height);
    [btnCenter addSignal:ClassDetailBoard.CHOOSE forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btnCenter];
    
    selIndex = [dictSelCourse[@"orderNum"] intValue]-1;
    
    lbSelected = [BaseLabel initLabel:[NSString stringWithFormat:@"%@%@第%@节",[dictSelCourse[@"teachTime"] substringFromIndex:5],dictSelCourse[@"weekDay"],dictSelCourse[@"orderNumChar"]] font:FONT(15) color:RGB(74, 174, 61) textAlignment:NSTextAlignmentCenter];
    lbSelected.frame = CGRectMake(0, 0, 110, 35);
    [btnCenter addSubview:lbSelected];
    
    BaseButton *btnNext = [BaseButton initBaseBtn:IMAGESTRING(@"class_btn") highlight:nil text:@"下一节" textColor:RGB(120, 120, 120) font:FONT(15)];
    [btnNext addSignal:ClassDetailBoard.NEXT forControlEvents:UIControlEventTouchUpInside];
    btnNext.frame = CGRectMake(btnCenter.right+10, btnPre.top, 68, btnPre.height);
    [header addSubview:btnNext];
    
    BeeUIImageView *viewInfo = [BeeUIImageView spawn];
    viewInfo.frame = CGRectMake(0, header.bottom, self.viewWidth, 70);
    viewInfo.backgroundColor = RGB(233, 233, 233);
    viewInfo.userInteractionEnabled = YES;
    [self.view addSubview:viewInfo];
    imageView = viewInfo;
    
    avatar = [AvatarView initFrame:CGRectMake(10, 15, 40, 40) image:IMAGESTRING(@"demo_icon1") borderColor:[UIColor clearColor]];
    [avatar setImageWithURL:kImage100(dictSelCourse[@"teacherPicUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
    [viewInfo addSubview:avatar];
    
    BaseLabel *teacher = [BaseLabel initLabel:dictSelCourse[@"teacherName"] font:FONT(15) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    teacher.frame = CGRectMake(avatar.right+10, avatar.top, 200, 20);
    [viewInfo addSubview:teacher];
    
    info = [BaseLabel initLabel:@"给老师评分" font:FONT(12) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
    info.frame = CGRectMake(teacher.left, teacher.bottom, teacher.width, 18);
    [info makeTappable:ClassDetailBoard.STAR];
    info.hidden = YES;
    [viewInfo addSubview:info];
    
    stars = [[StarView alloc] initWithFrame:CGRectMake(teacher.left, teacher.bottom+3, 70, 13)];
    stars.hidden = YES;
    [viewInfo addSubview:stars];
     NSArray *arrayIcon = @[@"teacher_play",@"teacher_download",@"student_add"];
    labelTitle = @[@"播放0次",@"下载0次",@"添加好友"];
    for (int i = 0; i < 3; i++) {
        BeeUIImageView *icon = [BeeUIImageView spawn];
        icon.frame = CGRectMake(150+52*i, 12, 50, 30);
        icon.image = IMAGESTRING(arrayIcon[i]);
        icon.tag = i;
        [viewInfo addSubview:icon];
        
        BaseLabel *lb = [BaseLabel initLabel:labelTitle[i] font:FONT(10) color:RGB(88, 88, 88) textAlignment:NSTextAlignmentCenter];
        lb.frame = CGRectMake(icon.left, icon.bottom, icon.width, 20);
        lb.tag = i;
        [viewInfo addSubview:lb];
        
        if (lb.tag == 0) {
            lab1 = lb;
        }else if (lb.tag == 1){
            lab2 = lb;
        }else if (lb.tag == 2){
            lab3 = lb;
        }
        [icon makeTappable:ClassDetailBoard.CENTER withObject:icon];
        [lb makeTappable:ClassDetailBoard.CENTER withObject:lb];
    }

    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewInfo.bottom, self.viewWidth, self.viewHeight-viewInfo.bottom-(IOS7_OR_LATER?64:44))];
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    btnOrder = [BaseButton initBaseBtn:IMAGESTRING(@"hot") highlight:nil];
    btnOrder.frame = CGRectMake(260, viewInfo.bottom-22, 44, 44);
    [btnOrder addSignal:ClassDetailBoard.ORDER forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOrder];
    
    [self getCourseCharacter];
    [self getCourseNote:dictSelCourse[@"id"]];
    [self getCourseCount:dictSelCourse[@"id"]];
    [self.view makeTappable:ClassDetailBoard.HIDE withObject:nil];
}

//设置不同字体颜色
-(void)fuwenbenLabel:(BeeUILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
}

-(void)courseCountShow:(NSDictionary *)dic{
    
   
    // NSArray *arrayTitle = @[@"播放轻课件",@"下载课件",@"添加好友"];
    lab1.text = [NSString stringWithFormat:@"播放%@次",dic[@"playCount"]];
    lab2.text = [NSString stringWithFormat:@"下载%@次",dic[@"downResCount"]];
        NSString *str1  = [NSString stringWithFormat:@"%@",dic[@"playCount"]];
        [self fuwenbenLabel:lab1 FontNumber:FONT(10) AndRange:NSMakeRange(2, [str1 length]) AndColor:RGB(246, 181, 60)];
        NSString *str2  = [NSString stringWithFormat:@"%@",dic[@"downResCount"]];
        [self fuwenbenLabel:lab2 FontNumber:FONT(10) AndRange:NSMakeRange(2, [str2 length]) AndColor:RGB(111, 186, 44)];
   

}
-(void)getCourseCount:(NSString *)strScheduleId{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_course_data.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dictSelCourse[@"courseId"]).PARAM(@"courseSchedId",strScheduleId);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 10000;
}

- (void)getCourseCharacter{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_course_character.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dictSelCourse[@"courseId"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

/**
 *  获取课程笔记
 */
- (void)getCourseNote:(NSString *)strScheduleId{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_course_note.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dictSelCourse[@"courseId"]).PARAM(@"courseSchedId",strScheduleId).PARAM(@"orderType",isHot?@"hot":@"time").PARAM(@"pageOffset",@"0").PARAM(@"pageSize",@"100");
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9528;
    
}

- (void)getCourseVideo:(NSString *)strScheduleId{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_course_video.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dictSelCourse[@"courseId"]).PARAM(@"courseSchedId",strScheduleId);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9529;
}

- (void)getCourseResource:(NSString *)strScheduleId{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_course_res.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dictSelCourse[@"courseId"]).PARAM(@"courseSchedId",strScheduleId);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9530;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
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
        NSLog(@"%@",request.responseString);
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        arrayCourseCharacters = json[@"result"];
                        if (arrayCourseCharacters.count>0) {
                            [avatar setImageWithURL:kImage100(arrayCourseCharacters[0][@"teacherPicUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                        }
                    }
                        break;
                    case 9528:
                    {
                        NSMutableArray *array = json[@"result"];
                        [self getTableCellHeight:array];
                        arrayCourseNote = array;
                        [myTableView reloadData];
                    }
                        break;
                    case 9529:
                    {
                        videoPopupView = nil;
                        
                        videoPopupView = [[DownloadPopupView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
                        videoPopupView.arrayData = json[@"result"];
                        videoPopupView.isVideo = YES;
                        
                        [videoPopupView loadContent];
                        [self.view addSubview:videoPopupView];
                    }
                        break;
                    case 9530:
                    {
                        downloadPopupView = nil;
                        
                        downloadPopupView = [[DownloadPopupView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
                        downloadPopupView.arrayData = json[@"result"];
                        downloadPopupView.isVideo = NO;
                        [[NSUserDefaults standardUserDefaults] setObject:dictSelCourse forKey:@"teachers"] ;
                        [downloadPopupView loadContent];
                        [self.view addSubview:downloadPopupView];
                    }
                        break;
                    case 9531:
                    {
                        [arrayCourseNote removeObject:dictSelNote];
                        [myTableView reloadData];
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"删除成功"];
                    }
                        break;
                    case 9532:
                    {
                        [field resignFirstResponder];
                        toolBar.hidden = YES;
                        faceChooseView.hidden = YES;
                        [self getCourseNote:dictSelCourse[@"id"]];
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"评论成功"];
                    }
                        break;
                    case 9533:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"操作成功"];
                        int praiseNum = [dictSelNote[@"praiseNum"] intValue]+1;
                        [dictSelNote setObject:[NSString stringWithFormat:@"%d",praiseNum] forKey:@"praiseNum"];
                        [myTableView reloadData];
                    }
                        break;
                    case 9534:
                    {
                        [dictSelCourse setObject:json[@"result"][@"evaluateScore"] forKey:@"evaluateScore"];
                        [dictSelCourse setObject:@YES forKey:@"evaluateStatus"];
                        [self showStarInfo];
                        
                        for (NSMutableDictionary *dict in arrayCourseCharacters) {
                            if ([dict[@"id"] intValue]==[json[@"result"][@"courseSchedId"] intValue]) {
                                [dict setObject:json[@"result"][@"evaluateScore"] forKey:@"evaluateScore"];
                                [dict setObject:@YES forKey:@"evaluateStatus"];
                            }
                        }
                    }
                        break;
                    case 10000:
                    {
                        [self courseCountShow:json[@"result"]];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                switch (request.tag) {
                    case 9527:
                    {
                    }
                        break;
                    case 9528:
                    {
                        [arrayCourseNote removeAllObjects];
                        [myTableView reloadData];
                    }
                        break;
                    case 9529:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"此讲暂时没有轻课件"];
                    }
                        break;
                    case 9530:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"此讲暂时没有课件可供下载"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            default:
            {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:json[@"ERRMSG"]];
            }
                break;
        }
    }
}


- (void)getTableCellHeight:(NSMutableArray *)array{
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        CGFloat y = 30.;
        if ([dict[@"voiceRecordUrl"] length]>0) {
            y += 42;
        }
        else {
            CGSize szContent = [dict[@"content"] sizeWithFont:FONT(14) byWidth:240];
            y = y+5+szContent.height;
        }
        
        y += 10;
        
        int picCount = [dict[@"pics"] count];
        if (picCount>0) {
            int count = ceil(picCount/3.0);
            y += 55*count;
        }
        
        int commentCount = [dict[@"commentNum"] intValue];
        if (commentCount>0) {
//            int max = 5;
//            if (commentCount<=max) {
//                max = commentCount;
//            }
//            y += max*20+10;
            NSMutableArray *comments = dict[@"comments"];
            for (int j = 0; j < comments.count; j++) {
                NSMutableDictionary *dictComment = comments[j];
                NSString *strName = [NSString stringWithFormat:@"%@:",dictComment[@"commentUserName"]];
                NSMutableArray *arrayComment = [[DataUtils sharedInstance] getMessageArray:dictComment[@"content"]];
                [arrayComment insertObject:strName atIndex:0];
                CGFloat commentHeight = [[DataUtils sharedInstance] getContentSize:arrayComment width:240];
                [dictComment setObject:[NSString stringWithFormat:@"%f",commentHeight] forKey:@"commentHeight"];
                
                y += commentHeight;
            }
            if (commentCount>5) {
                y += 40;
            }
        }
        
        [dict setObject:[NSString stringWithFormat:@"%f",y] forKey:@"height"];
    }
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayCourseNote.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [arrayCourseNote[indexPath.row][@"height"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[ClassDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell initSelf];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictNote = arrayCourseNote[indexPath.row];
    cell.board = self;
    [cell load];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    toolBar.hidden = YES;
    field.text = @"";
    [field resignFirstResponder];
    faceChooseView.hidden = YES;
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
        [btnFace addSignal:ClassDetailBoard.FACE forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btnFace];
        
        BaseButton *btnSend = [BaseButton initBaseBtn:IMAGESTRING(@"btn_send") highlight:IMAGESTRING(@"btn_send_pre") text:@"发表" textColor:[UIColor blackColor] font:FONT(15)];
        btnSend.frame = CGRectMake(240, btnFace.top+10, 70, 30);
        [btnSend addSignal:ClassDetailBoard.SEND_COMMENT forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btnSend];
    }
    //field.inputAccessoryView = toolBar;
    field.text = @"";
    toolBar.hidden = NO;
    [field becomeFirstResponder];
    [self.view addSubview:toolBar];
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

- (void)createPickerView{
    pickView = [[UIPickerView alloc] init];
    
    customPicker = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewWidth, pickView.height+44)];
    [self.view addSubview:customPicker];
    
    pickView.frame = CGRectMake(0, 44, self.viewWidth, pickView.height);
    pickView.dataSource = self;//委托当前viewController获取数据
    pickView.delegate = self;//委托当前viewController展示数据
    [pickView setShowsSelectionIndicator:YES];
    pickView.tag = 10009;
    pickView.backgroundColor = [UIColor whiteColor];
    [customPicker addSubview:pickView];
    customPicker.hidden = YES;
    
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 44)];
    toolbar.backgroundColor = RGB(245, 245, 245);
    BaseButton *btnCancel = [BaseButton spawn];
    btnCancel.frame = CGRectMake(0, 0, 60, 44);
    [btnCancel setTitleFont:FONT(18)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:RGB(104, 102, 116) forState:UIControlStateNormal];
    [btnCancel addSignal:ClassDetailBoard.PICKVIEW_CANCEL forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:btnCancel];
    
    BaseButton *btnOK = [BaseButton spawn];
    btnOK.frame = CGRectMake(self.viewWidth-60, 0, 60, 44);
    [btnOK setTitle:@"确认" forState:UIControlStateNormal];
    [btnOK setTitleFont:FONT(18)];
    [btnOK setTitleColor:RGB(86, 184, 152) forState:UIControlStateNormal];
    [btnOK addSignal:ClassDetailBoard.PICKVIEW_OK forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:btnOK];
    
    [customPicker addSubview:toolbar];
    
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.frame = CGRectMake(0, 0, self.viewWidth, 0.5);
    line.backgroundColor = RGB(188, 186, 193);
    [customPicker addSubview:line];
}

#pragma mark - pickerview delegate
//数据源方法 指定pickerView有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//此数据源方法 指定每个表盘有几条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return arrayCourseCharacters.count;
        }
            
        default:
            break;
    }
    return 0;
}

//此委托方法指定pickerView如何展示数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            //return arrayCourseCharacters[row][@"orderNum"];
            return [NSString stringWithFormat:@"%@%@第%@节",[arrayCourseCharacters[row][@"teachTime"] substringFromIndex:5],arrayCourseCharacters[row][@"weekDay"],arrayCourseCharacters[row][@"orderNumChar"]];
        }
            
        default:
            break;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            selIndex = [pickerView selectedRowInComponent:0];
            dictSelCourse = arrayCourseCharacters[selIndex];
            lbSelected.text = [NSString stringWithFormat:@"%@%@第%@节",[dictSelCourse[@"teachTime"] substringFromIndex:5],dictSelCourse[@"weekDay"],dictSelCourse[@"orderNumChar"]];
            
            [self getCourseNote:dictSelCourse[@"id"]];
            [self getCourseCount:dictSelCourse[@"id"]];
            [self showStarInfo];
        }
            break;
            
        default:
            break;
    }
}

@end
