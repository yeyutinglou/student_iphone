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
//  PublishMediaBoard.m
//  ClassRoom
//
//  Created by he chao on 7/1/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "PublishMediaBoard.h"
#import "amrFileCodec.h"


#pragma mark -

@interface PublishMediaBoard()
{
	//<#@private var#>
}
@end

@implementation PublishMediaBoard
DEF_SIGNAL(DONE)
DEF_SIGNAL(ADD)
DEF_SIGNAL(DEL)
DEF_SIGNAL(DEL_VOICE)
DEF_SIGNAL(CAMERA)
DEF_SIGNAL(LIBRARY)
DEF_SIGNAL(CHANGE)
DEF_SIGNAL(PLAY)

- (void)load
{
    /**
     添加笔记初始状态设定
     */
    arrayImages = [[NSMutableArray alloc] init];
    isVoice = NO;
    haseVoice = NO;
    isAllowRecord = YES;
}

- (void)unload
{
    [self stopRecording];
    [self stopPlaying];
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    /**
     *  新建笔记Controller
     */
    self.title = @"新建笔记";
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (!btnDone) {
        btnDone = [BeeUIButton spawn];
        btnDone.frame = CGRectMake(self.viewWidth-50, 0, 50, 44);
        [btnDone setTitle:@"完成" forState:UIControlStateNormal];
        [btnDone setTitleColor:RGB(255, 255, 1) forState:UIControlStateNormal];
        [btnDone addSignal:PublishMediaBoard.DONE forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navigationController.navigationBar addSubview:btnDone];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [btnDone removeFromSuperview];
    [self stopPlaying];
    [self stopRecording];
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

ON_SIGNAL2(BeeUITextField, signal){
    if ([signal is:BeeUITextField.WILL_ACTIVE]) {
        [myScrollView setContentOffset:CGPointMake(0, 90) animated:YES];
    }
}

ON_SIGNAL2(PublishMediaBoard, signal) {
    /**
     *  发布笔记
     */
    if ([signal is:PublishMediaBoard.DONE]) {
        
        if (!haseVoice && kStrTrim(field.text).length==0) {
            [BeeUIAlertView showMessage:@"请输入笔记说明或者录音" cancelTitle:@"确定"];
            return;
        }
        if (arrayImages && arrayImages.count>0) {
            [self postImages];
        }
        else {
            [self addCourseNote:nil];
        }
        
    }
    /**
     *  添加照片
     */
    else if ([signal is:PublishMediaBoard.ADD]) {
        if (arrayImages.count>=9) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"您最多可以同时上传9张照片"];
            return;
        }
        BeeUIActionSheet *sheet = [BeeUIActionSheet spawn];
        sheet.title = @"请选择操作";
        [sheet addButtonTitle:@"拍照" signal:PublishMediaBoard.CAMERA];
        [sheet addButtonTitle:@"从相册选择" signal:PublishMediaBoard.LIBRARY];
        [sheet addCancelTitle:@"取消"];
        [sheet showInViewController:self];
    }
    /**
     *  删除某一张照片
     */
    else if ([signal is:PublishMediaBoard.DEL]) {
        BeeUIButton *btn = (BeeUIButton *)signal.object;
        int index = btn.tag - 9527;
        [arrayImages removeObjectAtIndex:index];
        [self reloadImages];
    }
    /**
     *  相册中选取照片
     */
    else if ([signal is:PublishMediaBoard.LIBRARY]) {
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //c.sourceType = self.isCamera?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
        //c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
    /**
     *  相机拍照片
     */
    else if ([signal is:PublishMediaBoard.CAMERA]){
        UIImagePickerController * c = [[UIImagePickerController alloc] init];
        c.delegate = self;
        c.sourceType = UIImagePickerControllerSourceTypeCamera;
        //c.sourceType = self.isCamera?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
        //c.allowsEditing = YES;
        [self presentViewController:c animated:YES completion:nil];
    }
    /**
     *  切换文字输入还是语音输入
     */
    else if ([signal is:PublishMediaBoard.CHANGE]) {
        isVoice = !isVoice;
        [btnChange setImage:isVoice?IMAGESTRING(@"btn_keyboard"):IMAGESTRING(@"btn_voice") forState:UIControlStateNormal];
        if (isVoice) {
            [self checkAudioSession];
            field.hidden = YES;
            [field resignFirstResponder];
            btnRecording.hidden = NO;
        }
        else {
            field.hidden = NO;
            btnRecording.hidden = YES;
        }
    }
    /**
     *  删除语音
     */
    else if ([signal is:PublishMediaBoard.DEL_VOICE]){
        haseVoice = NO;
        imgVoiceBg.hidden = YES;
        btnDeleteVoice.hidden = YES;
        btnChange.hidden = NO;
        btnRecording.hidden = NO;
    }
    /**
     *  播放语音
     */
    else if ([signal is:PublishMediaBoard.PLAY]) {
        [self playRecording];
    }
}

- (void)postImages{
    if (!postImage) {
        postImage = [[PostImage alloc] init];
    }
    
    postImage.type = PostImageTypeNote;
    postImage.mainCtrl = self;
    postImage.arrayImages = arrayImages;
    [postImage postImages];
}

- (void)uploadImageFailed{
    NSLog(@"d");
}

- (void)uploadImageSuccess:(NSMutableArray *)arrayPicInfo{
    NSMutableString *strIds = [[NSMutableString alloc] init];
    for (int i = 0; i<arrayPicInfo.count; i++) {
        [strIds appendString:arrayPicInfo[i][@"id"]];
        if (i<arrayPicInfo.count-1) {
            [strIds appendString:@","];
        }
        
    }
    [self addCourseNote:strIds];
}

/**
 *  添加笔记功能----如果有录音则将录音转化为amr文件上传到服务器
 */
- (void)addCourseNote:(NSString *)strImageIds{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/add_course_note.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",self.dictCourse[@"courseId"]).PARAM(@"courseSchedId",self.dictCourse[@"id"]).PARAM(@"content",field.text);
    if (haseVoice) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:[self getVoicePath]];
        NSData *data2 = EncodeWAVEToAMR(data, 1, 16);
        request.FILE(@"file",data2);
        request.PARAM(@"voiceTime",[NSString stringWithFormat:@"%d",recordSeconds]);
    }
    if (strImageIds) {
        request.PARAM(@"picIds",strImageIds);
    }
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
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"发布成功"];
                        [self.stack popBoardAnimated:YES];
                        //arrayCourseCharacters = json[@"result"];
                    }
                        break;
                    case 9528:
                    {
                        //                        arrayCourseNote = json[@"result"];
                        //                        [myTableView reloadData];
                    }
                        break;
                    case 9529:
                    {
                    }
                        break;
                    case 9530:
                    {
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

/**
 *  加载视图内容布局
 */
- (void)loadContent{
    myScrollView = [BeeUIScrollView spawn];
    myScrollView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44));
    [self.view addSubview:myScrollView];
    
    vi = [BeeUIImageView spawn];
    vi.frame = CGRectMake(10, 20, 300, 125);
    vi.backgroundColor = [UIColor whiteColor];
    vi.layer.borderColor = RGB(212, 212, 212).CGColor;
    vi.layer.borderWidth = 1;
    vi.userInteractionEnabled = YES;
    [myScrollView addSubview:vi];
    
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.frame = CGRectMake(0, 44.5, vi.width, 0.5);
    line.backgroundColor = RGB(212, 212, 212);
    [vi addSubview:line];
    
    BeeUIButton *btnAdd = [BeeUIButton spawn];
    btnAdd.frame = CGRectMake(0, 0, 45, 45);
    [btnAdd setImage:IMAGESTRING(@"post_add_btn") forState:UIControlStateNormal];
    [btnAdd addSignal:PublishMediaBoard.ADD forControlEvents:UIControlEventTouchUpInside];
    [vi addSubview:btnAdd];
    
    BaseLabel *lbT = [BaseLabel initLabel:@"添加笔记图片" font:FONT(20) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lbT.frame = CGRectMake(btnAdd.right+15, 0, 200, 45);
    [lbT makeTappable:PublishMediaBoard.ADD];
    [vi addSubview:lbT];
    
    scrollVPhoto = [[UIScrollView alloc] init];
    scrollVPhoto.frame = CGRectMake(1, lbT.bottom, vi.width-2, vi.height-lbT.bottom);
    [vi addSubview:scrollVPhoto];
    
    [self reloadImages];
    
    BeeUIImageView *line2 = [BeeUIImageView spawn];
    line2.frame = CGRectMake(0, vi.bottom+10, self.viewWidth, 1);
    line2.backgroundColor = RGB(190, 190, 190);
    [myScrollView addSubview:line2];
    
    BaseLabel *lb1 = [BaseLabel initLabel:@"添加笔记说明(文字或者语音)" font:FONT(15) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lb1.frame = CGRectMake(20, 5+line2.bottom, 200, 20);
    [myScrollView addSubview:lb1];
    
    btnChange = [BeeUIButton spawn];
    btnChange.frame = CGRectMake(lb1.left-5, lb1.bottom+20, 44, 44);
    [btnChange setImage:IMAGESTRING(@"btn_voice") forState:UIControlStateNormal];
    [btnChange addSignal:PublishMediaBoard.CHANGE forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:btnChange];
    
    field = [BeeUITextField spawn];
    field.frame = CGRectMake(btnChange.right+10, btnChange.top+2, 240, 40);
    field.backgroundImage = IMAGESTRING(@"field_bg1");
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    field.leftViewMode = UITextFieldViewModeAlways;
    [myScrollView addSubview:field];
    
    btnRecording = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRecording.frame = field.frame;
    btnRecording.titleLabel.font = BOLDFONT(16);
    [btnRecording setTitle:@"按住说话" forState:UIControlStateNormal];
    [btnRecording setTitle:@"松开停止录音" forState:UIControlStateHighlighted];
    [btnRecording setTitleColor:RGB(70, 173, 28) forState:UIControlStateNormal];
    [btnRecording setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnRecording setBackgroundImage:IMAGESTRING(@"btn_recording") forState:UIControlStateNormal];
    [btnRecording setBackgroundImage:IMAGESTRING(@"btn_recording_pre") forState:UIControlStateHighlighted];
    [btnRecording addTarget:self action:@selector(recording) forControlEvents:UIControlEventTouchDown];
    [btnRecording addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [btnRecording addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDragExit];
    btnRecording.hidden = YES;
    [myScrollView addSubview:btnRecording];
    
    
    BaseButton *btnPost = [BaseButton initBaseBtn:IMAGESTRING(@"btn_green") highlight:IMAGESTRING(@"btn_green_pre") text:@"发 布" textColor:[UIColor whiteColor] font:BOLDFONT(22)];
    btnPost.frame = CGRectMake(10, btnRecording.bottom+30, 300, 40);
    [btnPost addSignal:PublishMediaBoard.DONE forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:btnPost];
    
}

- (void)checkAudioSession{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            //NSLog(@"%d",granted);
            isAllowRecord = granted;
        }];
    }
}

/**
 *  开始进行录音
 */
- (void)recording{
    if (!isAllowRecord) {
        [BeeUIAlertView showMessage:@"轻新课堂需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风" cancelTitle:@"确定"];
        return;
    }
//    if (!webGif) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"recording" ofType:@"gif"];
//        NSData *gifData = [NSData dataWithContentsOfFile:path];
//        webGif = [[UIWebView alloc] initWithFrame:CGRectMake(80, 10, 160, 160)];
//        webGif.backgroundColor = [UIColor clearColor];
//        webGif.scalesPageToFit = YES;
//        [webGif loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//        for (id subview in webGif.subviews) {
//            if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
//                ((UIScrollView *)subview).scrollEnabled = NO;
//            }
//        }
//        [self.view addSubview:webGif];
//    }
    
    
    
    [self showGif:YES];
    NSLog(@"recording");
    imgGif.hidden = NO;
    startTime = [self getDateTimeTOMilliSeconds:[NSDate date]];
    
    [self startRecording];
}

/**
 *  录音结束的时候进行判断 说话的时间长度
 */
- (void)stop{
    NSLog(@"stop");
    long long time2 = [self getDateTimeTOMilliSeconds:[NSDate date]];
    long long t = time2-startTime;
    if (t<500) {
        [self cancel];
    }
    else {
        recordSeconds = (int)(t/1000+((t%1000>500)?1:0));
        [self success];
    }
    imgGif.hidden = YES;
    //NSLog(@"zzz");
}

/**
 *  取消录音结果记录
 */
- (void)cancel{
    imgGif.hidden = YES;
    NSLog(@"cancel");
    
    [self stopRecording];
}

/**
 *  说话语音聊天成功之后显示录音的时间
 */
- (void)success{
    if (!imgVoiceBg) {
        imgVoiceBg = [BeeUIButton spawn];
        [imgVoiceBg setImage:IMAGESTRING(@"voice_bg") forState:UIControlStateNormal];
        [imgVoiceBg addSignal:PublishMediaBoard.PLAY forControlEvents:UIControlEventTouchUpInside];
        imgVoiceBg.image = IMAGESTRING(@"voice_bg");
        imgVoiceBg.frame = CGRectMake(20, 200, 173, 50);
        //[imgVoiceBg makeTappable:PublishMediaBoard.PLAY];
        [myScrollView addSubview:imgVoiceBg];
        
        BeeUIImageView *wave = [BeeUIImageView spawn];
        wave.frame = CGRectMake(30, 0, 17, 50);
        wave.image = IMAGESTRING(@"voice_wave");
        [imgVoiceBg addSubview:wave];
        
        
        time_recording = [BaseLabel initLabel:@"" font:BOLDFONT(18) color:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
        time_recording.frame = CGRectMake(wave.right+15, 0, 200, 50);
        [imgVoiceBg addSubview:time_recording];
    }
    
    if (!btnDeleteVoice) {
        btnDeleteVoice = [BeeUIButton spawn];
        btnDeleteVoice.frame = CGRectMake(imgVoiceBg.right, imgVoiceBg.top, 120, imgVoiceBg.height);
        [btnDeleteVoice setTitle:@"删除语言" forState:UIControlStateNormal];
        [btnDeleteVoice setTitleColor:RGB(243, 155, 10) forState:UIControlStateNormal];
        [btnDeleteVoice setTitleFont:BOLDFONT(18)];
        [btnDeleteVoice addSignal:PublishMediaBoard.DEL_VOICE forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:btnDeleteVoice];
    }
    
    int minutes = recordSeconds/60;
    int seconds = recordSeconds%60;
    NSString *strTime;
    if (minutes>0) {
        strTime = [NSString stringWithFormat:@"%d'%d''",minutes,seconds];
    }
    else {
        strTime = [NSString stringWithFormat:@"%d''",seconds];
    }
    time_recording.text = strTime;
    
    btnDeleteVoice.hidden = NO;
    imgVoiceBg.hidden = NO;
    btnChange.hidden = YES;
    btnRecording.hidden = YES;
    
    haseVoice = YES;
}

/**
 *  返回毫秒数
 */
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    //NSLog(@"interval=%f",interval);
    long long totalMilliseconds = interval*1000 ;
    //NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

/**
 *  播放GIF动画 2015-07-31
 */
- (void)showGif:(BOOL)isShow{
    if (isShow) {
        if (!imgGif) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"recording" ofType:@"gif"];
            NSData *gifData = [NSData dataWithContentsOfFile: path];
            NSMutableArray *frames = nil;
            CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
            double total = 0;
            NSTimeInterval gifAnimationDuration;
            if (src) {
                size_t l = CGImageSourceGetCount(src);
                if (l > 1){
                    frames = [NSMutableArray arrayWithCapacity: l];
                    for (size_t i = 0; i < l; i++) {
                        CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                        NSDictionary *dict = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, 0, NULL);
                        if (dict){
                            NSDictionary *tmpdict = [dict objectForKey: @"{GIF}"];
                            total += [[tmpdict objectForKey: @"DelayTime"] doubleValue] * 100;
                        }
                        if (img) {
                            [frames addObject: [UIImage imageWithCGImage: img]];
                            CGImageRelease(img);
                        }
                    }
                    gifAnimationDuration = total / 100;
                    
                    imgGif = [[UIImageView alloc] initWithFrame:CGRectMake(80, 10, 160, 160)];
                    imgGif.animationImages = frames;
                    imgGif.animationDuration = gifAnimationDuration;
                    [imgGif startAnimating];
                    
                    [self.view addSubview:imgGif];
                }
            }
            
            BaseLabel *lb = [BaseLabel initLabel:@"松开停止录音" font:BOLDFONT(15) color:RGB(187, 187, 187) textAlignment:NSTextAlignmentCenter];
            lb.frame = CGRectMake(0, 130, 160, 20);
            [imgGif addSubview:lb];
        }
        imgGif.hidden = NO;
    }
    else {
        imgGif.hidden = YES;
    }
}

- (void)reloadImages{
    for (UIView *element in scrollVPhoto.subviews) {
        if (element.tag>100) {
            [element removeFromSuperview];
        }
    }
    
    for (int i = 0; i < arrayImages.count; i++) {
        BeeUIImageView *imgV = [BeeUIImageView spawn];
        imgV.tag = 9527;
        imgV.frame = CGRectMake(5+73*i, 10, 65, 65);
        imgV.image = arrayImages[i];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        [scrollVPhoto addSubview:imgV];
        
        BeeUIButton *btnClose = [BeeUIButton spawn];
        btnClose.tag = 9527+i;
        btnClose.frame = CGRectMake(0, 0, 30, 30);
        btnClose.center = CGPointMake(imgV.right, imgV.top);
        [btnClose setImage:IMAGESTRING(@"post_close_btn")];
        [btnClose addSignal:PublishMediaBoard.DEL forControlEvents:UIControlEventTouchUpInside object:btnClose];
        [scrollVPhoto addSubview:btnClose];
        
        [scrollVPhoto setContentSize:CGSizeMake(imgV.right+10, scrollVPhoto.height)];
    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    
    UIImage * i = [info[@"UIImagePickerControllerOriginalImage"] copy];
    if(i.size.width > 640)
    {
        i = [DataUtils scaleImage:i toScale:640/i.size.width];
    }
    [arrayImages addObject:i];
    //[_arrayURL addObject:@"9527"];
    
    [self reloadImages];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - record/play audio
/**
 *  开始录音======================================
 */
- (void)startRecording{
    audioRecorder = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];

        
    [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [recordSettings setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
    [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];


    NSURL *url = [NSURL fileURLWithPath:[self getVoicePath]];
    
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    audioRecorder.meteringEnabled = YES;
    if ([audioRecorder prepareToRecord] == YES){
        audioRecorder.meteringEnabled = YES;
        [audioRecorder record];
        timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }else {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
}

/**
 *  音频文件保存路径
 */
- (NSString *)getVoicePath{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"recordTest.caf"];
}

- (void)levelTimerCallback:(NSTimer *)timer {
	[audioRecorder updateMeters];
}

/**
 *  停止录音
 */
- (void)stopRecording{
    if (audioRecorder) {
        [audioRecorder stop];
        [timerForPitch invalidate];
        timerForPitch = nil;
    }
    
}

/**
 *  播放录音
 */
- (void)playRecording{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL *url = [NSURL fileURLWithPath:[self getVoicePath]];
    
    // NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
}

- (void)stopPlaying{
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil; 
    }
    
}

@end
