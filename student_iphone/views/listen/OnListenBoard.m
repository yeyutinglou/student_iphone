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
//  OnListenBoard.m
//  student_iphone
//
//  Created by he chao on 14/11/18.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "OnListenBoard.h"
#import "AppDelegate.h"
#import "ReaderViewController.h"
#import "ResourceDownload.h"
#import "AddClipNoteBoard.h"
#import "SocketData.h"

#import "PaintViewController.h"

#pragma mark -

@interface OnListenBoard()<ReaderViewControllerDelegate,ResourceDownloadDelegate>
{
	//<#@private var#>
    __weak IBOutlet UIView *viResource;
    ReaderViewController *readerViewController;
    //NSMutableDictionary *dictSelResource;
    ResourceDownload *resourceDownload;
    __weak IBOutlet UIView *viBottom;
    
    //add by zhaojian 2015-12-28
    PaintViewController *paintCtrl;
    NSString *resourceStr;
    //add by dyw
    int lastPage;
    
    BOOL isDownload;
}
@end

@implementation OnListenBoard

- (void)load
{
}

- (void)unload
{
}

- (void)dealloc{
    [self unobserveNotification:@"resource"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isOnClassMode = NO;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    self.title = @"听课中";
    //[self loadContent];
    //[self showBackBtn];
    
    [self observeNotification:@"resource"];
    
    viResource.frame = CGRectMake(0, 0, kWidth, self.viewHeight-58);
    
    [self showResourceDetail];
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
    [self.navigationItem setHidesBackButton:YES];
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

ON_NOTIFICATION(notification){
    if ([notification is:@"resource"]) {
        _dictMessage = notification.object;
        if (isDownload) {
            [self showResourceDetail];
        }
        
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //2016-05-26 zhaojian
    delegate.isOnClassMode = YES;
    if (delegate.isPush) {
        NSString *filePath = [[BeeFileCache sharedInstance] fileNameForKey:[(NSString *)_dictMessage[@"playUrlIos"] MD5]];
        
        [self openPDF:filePath];
        
        int page = [_dictMessage[@"pageNo"] integerValue];
        [self showPage:page];

    }
       lastPage = 0;
    
}

/**
 *  离开时设置为: 非资源模式~~~delegate.isOnClassMode = NO;
 */
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //[self unobserveNotification:@"resource"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isOnClassMode = NO;
}

- (IBAction)touchQuestionBtn:(id)sender {
//    [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在提交"];
//    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/stuhelp/stu_send_help.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseSchedId",@"851");
//    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
//    request.tag = 9527;
    [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在提交"];
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/stuhelp/stu_send_help.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseSchedId",[SocketData sharedInstance].dictSocket[@"courseSchedId"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (IBAction)touchSnapshotBtn:(id)sender {
    AddClipNoteBoard *controller = kGetControllerByStoryBoard(@"AddClipNoteBoard");
    controller.screenImage = [self convertViewToImage:readerViewController.view];
    controller.dictCourse = _dictMessage;
    [self.navigationController pushViewController:controller animated:YES];
}

-(UIImage*)convertViewToImage:(UIView*)v{
    UIGraphicsBeginImageContext(v.bounds.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)loadContent{
    
}

- (void)showResourceDetail{
//    if (mCtr) {
//        [mCtr.view removeFromSuperview];
//        mCtr = nil;
//    }
    
    if (![_dictMessage[@"resExtName"] isEqualToString:@""]) {
        if ([_dictMessage[@"resExtName"] isEqualToString:@"mp4"]||[_dictMessage[@"resExtName"] isEqualToString:@"mp3"]) {
//            NSURL* url = [NSURL URLWithString:_dictMessage[@"playUrlIos"]];
//            mCtr = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//            mCtr.view.frame = CGRectMake(0, 0, 1024, 768);
//            [mCtr.moviePlayer prepareToPlay];
//            [mCtr.moviePlayer play];
//            [self.view insertSubview:mCtr.view belowSubview:viewOperate];
            //[self.view addSubview:mCtr.view];
            [BeeUIAlertView showMessage:@"请看大屏幕" cancelTitle:@"确定"];
            viBottom.hidden = YES;
        }
        else {//playUrlIos
            viBottom.hidden = NO;
            isDownload = YES;
            if ([[BeeFileCache sharedInstance] hasObjectForKey:[_dictMessage[@"playUrlIos"] MD5]]) {
                NSString *filePath = [[BeeFileCache sharedInstance] fileNameForKey:[(NSString *)_dictMessage[@"playUrlIos"] MD5]];
                
                //add by zhaojian 2015-01-04
                if (![resourceStr isEqualToString:filePath])
                {
                     [self openPDF:filePath];
                }
               
                
                int page = [_dictMessage[@"pageNo"] integerValue];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showPage:page];
                });
            }
            else {
                isDownload = NO;
                [resourceDownload cancelRequests];
                resourceDownload = nil;

               // [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在加载"];
                
                resourceDownload = [[ResourceDownload alloc] init];
                resourceDownload.delegate = self;
                [resourceDownload downloadResource:_dictMessage[@"playUrlIos"]];
            }
            
            //add by zhaojian 2015-12-28
            if (readerViewController)
            {
                //paintCtrl = kGetControllerByStoryBoard(@"PaintViewController");
                if (!paintCtrl)
                {
                    paintCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaintViewController"];
                    paintCtrl.view.userInteractionEnabled = NO;
                    //paintCtrl.subDic = (NSMutableDictionary *)@{@"viewWidth":@"1024",@"viewHeight":@"700",@"label":@"1"};
                    paintCtrl.subDic = (NSMutableDictionary *)@{@"viewWidth":[NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.width], @"viewHeight":[NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height-64], @"label":@"1"};
                    
                    [paintCtrl showWhiteBoardDetail:paintCtrl];
                    [paintCtrl clearBg];
                }
                paintCtrl.view.userInteractionEnabled = NO;
                paintCtrl.view.backgroundColor = [UIColor clearColor];
                paintCtrl.backView.hidden = YES;

                //add by dyw
                int page = [_dictMessage[@"pageNo"] integerValue];
                if (lastPage != page) {
                    [paintCtrl.paintView myalllineclear];
                }
                lastPage = page;
                
                [readerViewController.view addSubview:paintCtrl.view];
                
                if (_dictMessage[@"INFO"]) {
                    paintCtrl.infoDic = _dictMessage[@"INFO"];
                    //float boardWidth   =  ((NSNumber*)_subDic[@"viewWidth"]).floatValue;
                    //float boardHeight  =  ((NSNumber*)_subDic[@"viewHeight"]).floatValue;
                    //paintCtrl.subDic = (NSMutableDictionary *)@{@"viewWidth":@"1024", @"viewHeight":@"700"};
                    paintCtrl.subDic = (NSMutableDictionary *)@{@"viewWidth":[NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.width], @"viewHeight":[NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height-64]};
                    [paintCtrl showWhiteBoardDetail:paintCtrl];
                    [paintCtrl clearBg];
                }
            }
        }
    }
}

- (void)downloadSuccess:(NSString *)strResourceName{
    isDownload = YES;
    NSString *filePath = [[BeeFileCache sharedInstance] fileNameForKey:[strResourceName MD5]];
    [self openPDF:filePath];
}

//2016-05-11
-(void)downloadFailed:(NSString *)strResourceName
{
    isDownload = YES;
}

- (void)showPage:(int)pageParam
{
    //add by zhaojian avoid memroy leak
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showPage) object:nil];
    //int page = [_dictMessage[@"pageNo"] integerValue];
    
    [readerViewController showDocumentPage:pageParam];
    
    JYDLog(@"ReaderViewController showDocumentPage#########:%d", pageParam);
}

- (void)openPDF:(NSString *)strFilePath{
    
     //add by zhaojian 2015-12-28
    if (![resourceStr isEqualToString:strFilePath]) {
        [readerViewController.view removeFromSuperview];
        readerViewController = nil;
        
        //add by zhaojian 2015-12-28
        if (paintCtrl != nil)
        {
            [paintCtrl.paintView myalllineclear];
        }
    }
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:strFilePath password:nil];
    
    if (document) {
    
        //add by zhaojian --- slove for 闪退问题
        [readerViewController.view removeFromSuperview];
        readerViewController = nil;
        
        readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.view.userInteractionEnabled = NO;
        
        readerViewController.view.frame = viResource.bounds;
        
        [viResource addSubview:readerViewController.view];
    }
    
    //[self performSelector:@selector(showPage) withObject:nil afterDelay:0.5];
    
    //add by zhaojian 2015-01-04
    if (![resourceStr isEqualToString:strFilePath])
    {
        [self showPage:1];//首次打开的时候在第一页
    }
    
    resourceStr = strFilePath;
    
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        NETWORK_ERROR
        [[BeeUITipsCenter sharedInstance] dismissTips];
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
                        [BeeUIAlertView showMessage:@"提交成功" cancelTitle:@"确定"];
                        //                        dictDetail = json[@"result"];
                        //                        [self loadPieChart];
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
                [[BeeUITipsCenter sharedInstance] presentMessageTips:json[@"ERRMSG"]];
            }
                break;
        }
    }
    
    //2016-05-06
    [super handleRequest:request];
    
}

@end
