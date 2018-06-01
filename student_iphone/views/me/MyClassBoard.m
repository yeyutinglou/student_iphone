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
//  MyClassBoard.m
//  student_iphone
//
//  Created by he chao on 3/24/15.
//  Copyright (c) 2015 he chao. All rights reserved.
//

#import "MyClassBoard.h"
#import "MyClassCell.h"
#import "PlayViewController.h"
#import "PreviewDataSource.h"
#import <QuickLook/QuickLook.h>
#import "DownloadPopupView.h"
#import "JSPlaybackCourseViewController.h"

#pragma mark -

@interface MyClassBoard()<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDelegate>
{
	//<#@private var#>
    NSMutableArray *arrayClass;
    NSMutableDictionary *dictSelClass;
    UITableView *myTableView;
    int selIndex;
    DownloadPopupView *downloadPopupView,*videoPopupView;
    
    PreviewDataSource *dataSource;
}
@end

@implementation MyClassBoard
DEF_SIGNAL(PLAY)
DEF_SIGNAL(DOWNLOAD)
DEF_SIGNAL(PLAY_VIDEO)
DEF_SIGNAL(OPEN_FILE)
DEF_SIGNAL(CLOSE)

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_SIGNAL2(MyClassBoard, signal) {
    if ([signal is:MyClassBoard.PLAY]) {
        NSMutableDictionary *dict = signal.object;
        NSLog(@"%@",dict);
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_course_video.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dict[@"courseId"]).PARAM(@"courseSchedId",dict[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9530;
    }
    else if ([signal is:MyClassBoard.DOWNLOAD]) {
        NSMutableDictionary *dict = signal.object;
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_course_res.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dict[@"courseId"]).PARAM(@"courseSchedId",dict[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9531;
    }
    else if ([signal is:MyClassBoard.PLAY_VIDEO]){
//        NSString *strUrl = signal.object;
//        PlayViewController *controller = [[PlayViewController alloc] initWithContentURL:[NSURL URLWithString:strUrl]];
//        [[MainBoard sharedInstance] presentMoviePlayerViewControllerAnimated:controller];
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
                
                [[MainBoard sharedInstance] presentViewController:mCtr animated:YES completion:nil];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
    else if ([signal is:MyClassBoard.OPEN_FILE]){
        NSString *strKey = signal.object;
        QLPreviewController *previewCtrl = [[QLPreviewController alloc] init];
        //一下两行commenttd by zhaojian
        //previewCtrl.delegate = self;
        //PreviewDataSource *dataSource = [[PreviewDataSource alloc] init];
        if (dataSource == nil) {
            dataSource = [[PreviewDataSource alloc] init];
        }
        dataSource.path = [[BeeFileCache sharedInstance] fileNameForKey:strKey];//[[NSBundle mainBundle] pathForResource:@"5" ofType:@"pptx"];
        JYDLog(@"dataSource.path:%@", dataSource.path);
        previewCtrl.dataSource = dataSource;
        [[MainBoard sharedInstance] presentViewController:previewCtrl animated:YES completion:^{
        }];
    }
    else if ([signal is:MyClassBoard.CLOSE]) {
        NSNumber *status = signal.object;
        if ([status boolValue]) {
            [videoPopupView removeFromSuperview];
        }
        else {
            [downloadPopupView removeFromSuperview];
        }
    }
}


ON_CREATE_VIEWS( signal )
{
    [self getMyClassList];
    myTableView = [[UITableView alloc] initWithFrame:self.viewBound];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    myTableView.tableFooterView = [[UIView alloc] init];
    selIndex = -1;
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    myTableView.frame = self.view.bounds;
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

- (void)getMyClassList{ //接口60
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/my/get_my_course.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)getSimpleCourseChar{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/my/get_simple_course_char.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"courseId",dictSelClass[@"id"]);
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
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        arrayClass = json[@"result"];
                        [myTableView reloadData];
                    }
                        break;
                    case 9528:
                    {
                        [dictSelClass setObject:json[@"result"] forKey:@"courseChar"];
                        [myTableView reloadData];
                    }
                        break;
                    case 9530:
                    {
                        videoPopupView = nil;
                        
                        videoPopupView = [[DownloadPopupView alloc] initWithFrame:CGRectMake(0, -40, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
                        videoPopupView.arrayData = json[@"result"];
                        videoPopupView.isVideo = YES;
                        videoPopupView.isCurriculum = YES;
                        videoPopupView.isMyClass = YES;
                        [videoPopupView loadContent];
                        [self.view addSubview:videoPopupView];
                    }
                        break;
                    case 9531:
                    {
                        downloadPopupView = nil;
                        
                        downloadPopupView = [[DownloadPopupView alloc] initWithFrame:CGRectMake(0, -40, self.viewWidth, self.viewHeight-(IOS7_OR_LATER?64:44))];
                        downloadPopupView.arrayData = json[@"result"];
                        downloadPopupView.isVideo = NO;
                        downloadPopupView.isCurriculum = YES;
                        downloadPopupView.isMyClass = YES;
                        [downloadPopupView loadContent];
                        [self.view addSubview:downloadPopupView];
                    }
                        break;
                }
            }
                break;
            case 2:
            {
                switch (request.tag) {
                    case 9530:
                    {
                        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"此讲暂时没有轻课件"];
                    }
                        break;
                    case 9531:
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == selIndex) {
        return 78+50*[dictSelClass[@"courseChar"] count];
    }
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayClass.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[MyClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isSelected = indexPath.row==selIndex;
    cell.dictCurriculum = arrayClass[indexPath.row];
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selIndex == indexPath.row) {
        selIndex = -1;
        [myTableView reloadData];
    }
    else {
        selIndex = indexPath.row;
        //[myTableView reloadData];
        dictSelClass = arrayClass[indexPath.row];
        if (dictSelClass[@"courseChar"]) {
            [myTableView reloadData];
        }
        else
            [self getSimpleCourseChar];
    }
    //    QLPreviewController *previewCtrl = [[QLPreviewController alloc] init];
    //    previewCtrl.delegate = self;
    //    PreviewDataSource *dataSource = [[PreviewDataSource alloc] init];
    //    dataSource.path = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"pptx"];
    //    previewCtrl.dataSource = dataSource;
    //    [self presentViewController:previewCtrl animated:YES completion:^{
    //
    //    }];
    //[self.stack pushBoard:dataSource animated:YES];
}

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item{
    return NO;
}

@end
