//
//  JSPlaybackCourseViewController.m.m
//  JSmaster
//
//  Created by jyd on 15/1/7.
//  Copyright (c) 2015年 JYD. All rights reserved.
//

#import "JSPlaybackCourseViewController.h"
#import "JSPlaybackCourseVideoViewController.h"
#import "JSPlaybackCoursewareViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "JSPlaybackPointVO.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "JSConstants.h"

#define JSColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define PointImageHeight 44

@interface JSPlaybackCourseViewController ()<JSPlaybackCourseVideoDelegete, JSPlaybackCoursewareDelegete>

/**
 *  视频直播
 */
@property (nonatomic, strong) JSPlaybackCourseVideoViewController *courseVideoController;

/**
 *  课件直播
 */
@property (nonatomic, strong) JSPlaybackCoursewareViewController *coursewareController;

/**
 *  当前显示主界面视频
 */
@property (nonatomic, getter=isCourseVideoMainScreen) BOOL courseVideoMainScreen;

/**
 *  两个视频View容器
 */
@property (nonatomic, weak) UIView *videoContainerView;

/**
 *  是否是全屏状态
 */
@property (nonatomic, getter=isFullScreen) BOOL fullScreen;

/**
 *  视频顶部控制条
 */
@property (nonatomic, weak) UIView *topBar;

@property (nonatomic, weak) UIButton *playButton;

@property (nonatomic, weak) UISlider *progressSlider;

@property (nonatomic, weak) UILabel *progressLabel;

@property (nonatomic, weak) UILabel *leftLabel;

@property (nonatomic, assign) CGFloat duration;

/**
 *  视频底部控制条
 */
@property (nonatomic, weak) UIToolbar *bottomBar;

/**
 *  视频底部控制条2
 */
@property (nonatomic, weak) UIToolbar *bottomBarSecond;

/**
 *  视频底部控制条--返回按钮
 */
@property (nonatomic, weak) UIBarButtonItem *backBtn;

/**
 *  视频底部控制条--返回按钮
 */
@property (nonatomic, weak) UIBarButtonItem *backBtnCourseware;

/**
 *  视频底部控制条--全屏按钮
 */
@property (nonatomic, weak) UIBarButtonItem *fullScreenBtn;

/**
 *  视频底部控制条--课件全屏按钮
 */
@property (nonatomic, weak) UIBarButtonItem *fullScreenBtnCourseware;

/**
 *  视频底部控制条--UIToolBar弹性大小
 */
@property (nonatomic, weak) UIBarButtonItem *spaceItem;

/**
 *  视频底部控制条--UIToolBar固定大小
 */
@property (nonatomic, weak) UIBarButtonItem *fixedSpaceItem;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, getter=isPlayingBoth) BOOL playingBoth;

@property (strong, nonatomic) NSTimer *countTimer;

@property (assign, nonatomic) NSInteger countTime;

/**
 * 视频回放打点信息VO数组
 */
@property (nonatomic, strong) NSMutableArray *playbackPointArray;

@property (nonatomic, strong) UIButton *selectedButton;

/**
 *  打点显示的Button
 */
@property (strong, nonatomic) NSMutableArray *scrollBtnArray;

/**
 *  剩余时间
 */
@property (copy, nonatomic) NSMutableString *leftTime;

@end

@implementation JSPlaybackCourseViewController

-(NSMutableArray *)scrollBtnArray
{
    if (_scrollBtnArray == nil) {
        _scrollBtnArray = [NSMutableArray array];
    }
    
    return _scrollBtnArray;
}

- (NSMutableArray *)playbackPointArray
{
    if (_playbackPointArray == nil) {
        _playbackPointArray = [NSMutableArray array];
    }
    
    return _playbackPointArray;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation==UIInterfaceOrientationPortrait;
}

-(void)viewDidLoad
{
    [self.view setBackgroundColor:JSColor(78, 78, 78)];
    [self playCountRetain];
    //0.获取回放url
    [self loadPlaybackUrlsWithCourseID:self.course_id];
}
/**
 *播放课件统计次数
 */

-(void)playCountRetain{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:kUserInfo[@"sessionId"] forHTTPHeaderField:@"sessionId"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"courseId"] = self.dic[@"courseId"];
    params[@"courseSchedId"] = self.dic[@"courseSchedId"];
    params[@"id"]= kUserId;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kSchoolUrl, @"app/course/update_course_play_data.action"];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JYDLog(@"%@",responseObject);
        if ([responseObject[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
            JYDLog(@"播放次数统计成功");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JYDLog(@"播放次数统计失败");
    }];
}

/**
 * 获取回放视频urls
 */
- (void)loadPlaybackUrlsWithCourseID:(NSString *)course_id
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"course_id"] = course_id;
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", self.schoolServerAddress, REQUEST_URL_GET_PLAYBACK_URLS];

    [MBProgressHUD showMessage:@"正在加载" toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = responseObject;
        if ([dict[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
            NSDictionary *urlsDict = dict[@"result"];
            
            self.course_id = course_id;
            self.resourceID = urlsDict[@"id"];
            self.teacherUrl = urlsDict[@"teacher_url"];
            self.coursewareUrl = urlsDict[@"courseware_url"];

            if ([self.teacherUrl isEqualToString:@""] && [self.coursewareUrl isEqualToString:@""])
            {
                [MBProgressHUD showError:@"两路回放视频地址皆不存在!"];
            }
            
//            self.teacherUrl = @"http://v1.music.126.net/web/cloudmusic/YCMwIGJgISEiMDA0MTFhNQ==/mv/==/285050/20140702113832/4411240750638911_720.mp4";
//            self.coursewareUrl = @"http://v1.music.126.net/web/cloudmusic/YCMwIGJgISEiMDA0MTFhNQ==/mv/==/285050/20140702113832/4411240750638911_720.mp4";
            
            self.navigationController.navigationBarHidden = YES;
            
            //1.设置视频视图
            [self setupVideoContainerView];
            
            //2.获取视频回放打点信息
            [self loadPlaybackPointsInfo];
            
        } else if ([dict[@"STATUS"] isEqualToString:STATUS_FAILURE]) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:NO];
            NSString *failureStr = dict[@"ERRMSG"];
            NSLog(@"%@", failureStr);
            [MBProgressHUD showError:failureStr];
            return;
        } else if ([dict[@"STATUS"] isEqualToString:STATUS_EMPTY]) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:NO];
            [MBProgressHUD showSuccess:@"暂无回放数据记录"];
            NSLog(@"空数据");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:NO];
        NSLog(@"获取回放视频路径失败！ >>> %@", error);
        [MBProgressHUD showError:@"获取回放视频路径失败，请检查手机网络！"];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }];
}

/**
 * 获取视频回放打点信息
 */
- (void)loadPlaybackPointsInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"getPicInfo";
    params[@"id"] = self.resourceID;
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", self.veServerAddress, REQUEST_URL_GET_PIC_INFO];
    
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = responseObject;
        if ([dict[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
            NSMutableArray *resultArray = dict[@"result"];
            for (NSDictionary *ppDict in resultArray) {
                JSPlaybackPointVO *playbackPointVO = [[JSPlaybackPointVO alloc] init];
                playbackPointVO.time = [ppDict[@"time"] intValue];
                playbackPointVO.pic = ppDict[@"pic"];
                [self.playbackPointArray addObject:playbackPointVO];
            }
            // 设置回放打点图片视图
            [self setupScrollImageView];
        } else if ([dict[@"STATUS"] isEqualToString:STATUS_FAILURE]) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:NO];
            NSString *failureStr = dict[@"ERRMSG"];
            NSLog(@"%@", failureStr);
            [MBProgressHUD showError:failureStr];
            return;
        } else if ([dict[@"STATUS"] isEqualToString:STATUS_EMPTY]) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:NO];
            [MBProgressHUD showSuccess:@"暂无视频索引信息"];
            NSLog(@"空数据");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:NO];
        NSLog(@"获取视频索引信息失败！ >>> %@", error);
        [MBProgressHUD showError:@"获取视频索引信息失败，请检查手机网络！"];
        return;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)timerCheckMethod
{
    self.countTime+=1;
    NSLog(@"self.countTime:%ld", (long)self.countTime);
    if (self.countTime == 5)
    {
        self.topBar.hidden = YES;
        self.bottomBar.hidden = YES;
        self.bottomBarSecond.hidden = YES;
        //停止计时器
        [self.countTimer setFireDate:[NSDate distantFuture]];
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    [self hideBottomBar];
    self.countTime = 0;
    //开启计时器
    [self.countTimer setFireDate:[NSDate distantPast]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //释放定时器
    [self.countTimer invalidate];
    self.countTimer = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [self.countTimer setFireDate:[NSDate distantFuture]];
    
    [self.videoContainerView removeFromSuperview];
    [self.coursewareController.view removeFromSuperview];
    [self.courseVideoController.view removeFromSuperview];
    [self.courseVideoController removeFromParentViewController];
    [self.coursewareController removeFromParentViewController];
    self.courseVideoController = nil;
    self.coursewareController = nil;

}

/**
 *  1.设置视频View
 *
 */
- (void)setupVideoContainerView
{
    BOOL audioEnabled = NO;
    
    if (![self.teacherUrl isEqualToString:@""])
    {
        audioEnabled = YES;//如果老师有视频，则只播放老师的视频声音。课件声音不播放。
    }
    
    if ([self.videoType isEqualToString:@"3"]) {
        self.teacherUrl = self.coursewareUrl;
    }
    
    //直播视频
    JSPlaybackCourseVideoViewController *courseVideoController = [JSPlaybackCourseVideoViewController movieViewControllerWithContentPath:self.teacherUrl parameters:nil audioEnabled:audioEnabled];
    self.courseVideoController = courseVideoController;
    self.courseVideoController.delegete = self;
    self.courseVideoMainScreen = YES;
    self.courseVideoController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    
    //课件视频
    JSPlaybackCoursewareViewController *coursewareController = [JSPlaybackCoursewareViewController movieViewControllerWithContentPath:self.coursewareUrl parameters:nil audioEnabled:!audioEnabled];
    self.coursewareController = coursewareController;
    self.coursewareController.delegete = self;
    
    
    //视频容器
    UIView *tmpView = [[UIView alloc]init];
    tmpView.frame = CGRectMake(0, 0, ScreenWidth,  ScreenHeight-PointImageHeight);
    if ([self.videoType isEqualToString:@"2"] || [self.videoType isEqualToString:@"3"]) {
        [tmpView addSubview:self.courseVideoController.view];
        self.videoContainerView = tmpView;
        
        [self.view addSubview:self.videoContainerView];
        
        [self addChildViewController:self.courseVideoController];
        self.courseVideoController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2-PointImageHeight/2);
        [self addBottomBar];
    }else if ([self.videoType isEqualToString:@"4"]){
        [tmpView addSubview:courseVideoController.view];
        [tmpView addSubview:coursewareController.view];
        self.videoContainerView = tmpView;
        
        [self.view addSubview:self.videoContainerView];
        
        [self addChildViewController:self.courseVideoController];
        self.courseVideoController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2-PointImageHeight/2);
        [self addChildViewController:self.coursewareController];
        self.coursewareController.view.frame  = CGRectMake(0, ScreenHeight/2-PointImageHeight/2, ScreenWidth,  ScreenHeight/2-PointImageHeight/2);
        //底部指示器
        [self addBottomBar];
        
        //底部指示器-2
        [self addBottomBarSecond];
        

    }
    
    self.playingBoth = YES;
    //添加头部拖拽条
    [self addTopBar];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2000* NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self.courseVideoController play];
        if([self.videoType isEqualToString:@"4"]){
            [self.coursewareController play];
        }
        
    });
}

/**
 *  添加头部拖拽条
 */
-(void)addTopBar
{
    CGFloat topH = 44;
    
    UIView *topHUD = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topH)];
    topHUD.backgroundColor = JSColor(78, 78, 78);
    topHUD.alpha = 1.0;
    
    // top hud
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(15, 10, 30, 30);
    playButton.backgroundColor = [UIColor clearColor];
    [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playButton setBackgroundImage:[UIImage imageNamed:@"play-A"] forState:UIControlStateNormal];
    playButton.showsTouchWhenHighlighted = YES;
    [playButton addTarget:self action:@selector(playButtonDidTouch)
          forControlEvents:UIControlEventTouchUpInside];
    self.playButton = playButton;
    
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 1, 50, topH)];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.opaque = NO;
    progressLabel.adjustsFontSizeToFitWidth = NO;
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.text = @"00:00";
    progressLabel.font = [UIFont systemFontOfSize:12];
    self.progressLabel = progressLabel;
    
    UISlider *progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(96, 2, ScreenWidth-165, topH)];
    progressSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    progressSlider.continuous = NO;
    progressSlider.value = 0;
    //progressSlider.enabled = NO;
    [progressSlider setMinimumTrackImage:[UIImage imageNamed:@"progress-A"] forState:UIControlStateNormal];
    [progressSlider setMaximumTrackImage:[UIImage imageNamed:@"progress-B"] forState:UIControlStateNormal];
    [progressSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [progressSlider addTarget:self action:@selector(progressDidChange:) forControlEvents:UIControlEventValueChanged];
    self.progressSlider = progressSlider;
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-60, 1, 60, topH)];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.opaque = NO;
    leftLabel.adjustsFontSizeToFitWidth = NO;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.text = @"00:00";
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.leftLabel = leftLabel;
    
    [topHUD addSubview:playButton];
    [topHUD addSubview:progressLabel];
    [topHUD addSubview:progressSlider];
    [topHUD addSubview:leftLabel];
    
    self.topBar = topHUD;
    
    [self.videoContainerView addSubview:topHUD];
}

/**
 *  开始回放
 */
-(void)playButtonDidTouch
{
    if (!self.isPlayingBoth)
    {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play-A"] forState:UIControlStateNormal];
        if (![self.teacherUrl isEqualToString:@""])
        {
            [self.courseVideoController play];
        }
        else
        {
            [self .courseVideoController.activityIndicatorView stopAnimating];
        }
        if ([self.videoType isEqualToString:@"4"]) {
            if (![self.coursewareUrl isEqualToString:@""])
            {
                [self.coursewareController play];
            }
            else
            {
                [self.coursewareController.activityIndicatorView stopAnimating];
            }

        }
        
        self.playingBoth = YES;
    }
    else
    {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
        if (![self.teacherUrl isEqualToString:@""])
        {
            [self.courseVideoController pause];
        }
        
        if ([self.videoType isEqualToString:@"4"]) {
            if (![self.coursewareUrl isEqualToString:@""])
            {
                [self.coursewareController pause];
            }
        }
        
    
        self.playingBoth = NO;
    }
}

/**
 *  更新回放TimeLabel
 */
-(void)updateTopHud:(CGFloat)position duration:(CGFloat)duration type:(NSString *)type
{
    if (![self.teacherUrl isEqualToString:@""])
    {
        if ([type isEqualToString:@"coursevideo"])
        {
            //JYDLog(@"position:%.1f", position);
            
            [self setScrollViewPosition:position isProgress:NO];
            
            NSString *leftTimeStr = formatTimeInterval(duration - position, NO);
            NSMutableString *tmpleftTime = [[NSMutableString alloc]initWithString:leftTimeStr];
            self.leftTime = tmpleftTime;
            //JYDLog(@"leftTimeStr:%@", leftTimeStr);
            
            if ([self.leftTime isEqualToString:@"0:02"] || [self.leftTime isEqualToString:@"0:01"])
            {
                //从头开始播放
                self.progressSlider.value = 0;
                self.progressLabel.text = formatTimeInterval(0, NO);
                self.playingBoth = NO;
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                
                [self.courseVideoController setMoviePosition:0];
                if ([self.videoType isEqualToString:@"4"]) {
                    if (![self.coursewareUrl isEqualToString:@""])
                    {
                        [self.coursewareController setMoviePosition:0];
                    }
                }
                
            }
            
            self.duration = duration;
            self.progressSlider.value = position / duration;
            
            self.progressLabel.text = formatTimeInterval(position, NO);
            self.leftLabel.text = formatTimeInterval(duration, NO);
            
        }
    }
    else
    {
        if ([type isEqualToString:@"courseware"])
        {
            [self setScrollViewPosition:position isProgress:NO];
            
            NSMutableString *tmpleftTime = [[NSMutableString alloc]initWithString:formatTimeInterval(duration - position, NO)];
            self.leftTime = tmpleftTime;
            
            if ([self.leftTime isEqualToString:@"0:02"] || [self.leftTime isEqualToString:@"0:01"])
            {
                //从头开始播放
                self.progressSlider.value = 0;
                self.progressLabel.text = formatTimeInterval(0, NO);
                self.playingBoth = NO;
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                
                [self.coursewareController setMoviePosition:0];
            }
            
            self.duration = duration;
            self.progressSlider.value = position / duration;
            self.progressLabel.text = formatTimeInterval(position, NO);
            self.leftLabel.text = formatTimeInterval(duration, NO);
        }
    }
    
    //开始播放的时候开启计时器
    if (self.countTimer == nil)
    {
        NSTimer *countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCheckMethod) userInfo:nil repeats:YES];
        self.countTimer = countTimer;
        self.countTime = 0;
    }
}

/**
 *  打点图片选中状态随着时间变化:回放的时间进度
 *
 */
-(void)setScrollViewPosition:(CGFloat)position isProgress:(BOOL) isProgress
{
    for (int i=0; i<self.playbackPointArray.count; i++)
    {
        JSPlaybackPointVO *pointVo = [self.playbackPointArray objectAtIndex:i];
        
        if((long)pointVo.time == (long)position)
        {
            [self setupScrollBtn:i];
            break;
        }
        else if ((long)pointVo.time > (long)position)
        {
            if (isProgress) {
                if (i>=1) {
                    [self setupScrollBtn:i-1];
                }
                break;
            }
        }
    }
}

/**
 *  设置打点Button的选中状态 和 位置
 */
-(void)setupScrollBtn:(int)i
{
    self.selectedButton.selected = NO;
    self.selectedButton.superview.layer.borderColor = [UIColor clearColor].CGColor;
    self.selectedButton.superview.layer.borderWidth = 0;
    
    UIButton *btn = [self.scrollBtnArray objectAtIndex:i];
    btn.selected = YES;
    btn.superview.layer.borderColor = [UIColor greenColor].CGColor;
    btn.superview.layer.borderWidth = 2;
    self.selectedButton = btn;
    
    if (i>4) {
        int offsetContent =  btn.frame.size.width*(i-4) + (i-4+1)*6;
        [self.scrollView setContentOffset:CGPointMake(offsetContent, 0)];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointZero];
    }
}

/**
 *  拖拽Progressbar
 */
- (void) progressDidChange: (id) sender
{
    UISlider *slider = sender;

    if (![self.teacherUrl isEqualToString:@""])
    {
        if ([self.courseVideoController.activityIndicatorView isAnimating])
        {
            [MBProgressHUD showError:@"正在缓冲中。。。请您耐心等待！"];
        }else{
            [self.courseVideoController setMoviePosition:slider.value * self.duration];
        }
        
    }
    if ([self.videoType isEqualToString:@"4"]) {
        if (![self.coursewareUrl isEqualToString:@""])
        {
            if ([self.courseVideoController.activityIndicatorView isAnimating] || [self.coursewareController.activityIndicatorView isAnimating])
            {
                [MBProgressHUD showError:@"正在缓冲中。。。请您耐心等待！"];
            }else{
                [self setScrollViewPosition:slider.value * self.duration isProgress:YES];
                [self.coursewareController setMoviePosition:slider.value * self.duration];
            }
            
        }
    }
}

static NSString * formatTimeInterval(CGFloat seconds, BOOL isLeft)
{
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    
    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%d:%0.2d", h, m];
    else        [format appendFormat:@"%d", m];
    [format appendFormat:@":%0.2d", s];
    
    return format;
}

/**
 *  添加底部指示器
 */
- (void) addBottomBar
{
    UIToolbar *bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, (ScreenHeight- PointImageHeight)/2-44, ScreenWidth, 44)];
    bottomBar.tintColor = JSColor(89, 180, 49);
    [bottomBar setBarTintColor:JSColor(78, 78, 78)];
    self.bottomBar = bottomBar;
    
    self.bottomBar.alpha = 1.0;
    [self.videoContainerView addSubview:self.bottomBar];
    
    //bottom hud UIToolBar内容
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.spaceItem = spaceItem;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return-"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.backBtn = backBtn;
    
    UIBarButtonItem *fullScreenBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fullScreen"] style:UIBarButtonItemStyleBordered target:self action:@selector(setCurrentFullScreen:)];
    self.fullScreenBtn = fullScreenBtn;
    
    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = 20;
    self.fixedSpaceItem = fixedSpaceItem;
    
    [self.bottomBar setItems:@[self.fixedSpaceItem, self.backBtn, self.spaceItem, self.fullScreenBtn, self.fixedSpaceItem] animated:NO];
}

/**
 *  添加底部指示器
 */
- (void) addBottomBarSecond
{
    UIToolbar *bottomBarSecond = [[UIToolbar alloc] init];
    if ([self.videoType isEqualToString:@"3"]) {
        [bottomBarSecond setFrame:CGRectMake(0, (ScreenHeight- PointImageHeight)/2-44, ScreenWidth, 44)];
        

    }else{
        [bottomBarSecond setFrame:CGRectMake(0,  ScreenHeight-44-PointImageHeight, ScreenWidth, 44)];
    }
    bottomBarSecond.tintColor = JSColor(89, 180, 49);
    [bottomBarSecond setBarTintColor:JSColor(78, 78, 78)];
    self.bottomBarSecond = bottomBarSecond;
    
    [self.videoContainerView addSubview:self.bottomBarSecond];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.spaceItem = spaceItem;
    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = 20;
    self.fixedSpaceItem = fixedSpaceItem;
    UIBarButtonItem *backBtnCourseware = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return-"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.backBtnCourseware = backBtnCourseware;
    
    UIBarButtonItem *fullScreenBtnCourseware = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fullScreen"] style:UIBarButtonItemStyleBordered target:self action:@selector(setCurrentFullScreen:)];
    self.fullScreenBtnCourseware = fullScreenBtnCourseware;
    
    [self.bottomBarSecond setItems:@[self.fixedSpaceItem, self.backBtnCourseware, self.spaceItem, self.fullScreenBtnCourseware, self.fixedSpaceItem] animated:NO];
}

/**
 *  隐藏底部指示器
 */
- (void) hideBottomBar
{
    self.topBar.hidden = !self.topBar.hidden;
    self.bottomBar.hidden = !self.bottomBar.hidden;
    self.bottomBarSecond.hidden = !self.bottomBarSecond.hidden;
}

/**
 *  返回
 */
- (void)back:(UIBarButtonItem *) btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  切换视频
 *  @param courseVideo 是否是直播视频
 *  默认是直播视频、不是课件视频
 *  如果是直播、则courseVideo为YES
 *  如果是课件、则courseVideo为NO
 */
- (void)exchangeVideoCourseware:(BOOL) courseVideo
{

}

/**
 *  设置全屏
 */
- (void)setCurrentFullScreen:(UIBarButtonItem *) item
{
    if ([item isEqual:self.fullScreenBtn])
    {
        self.courseVideoMainScreen = YES;
    }
    else if ([item isEqual:self.fullScreenBtnCourseware])
    {
        self.courseVideoMainScreen = NO;
    }
    
    if (self.isFullScreen)
    {
        self.videoContainerView.transform = CGAffineTransformIdentity;
        self.videoContainerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - PointImageHeight);
        self.courseVideoController.view.hidden = NO;
        self.coursewareController.view.hidden  = NO;
        //控制条
        self.topBar.frame = CGRectMake(0, 0, ScreenWidth, 44);
        self.bottomBar.frame = CGRectMake(0,  (ScreenHeight-PointImageHeight)/2 - 44, ScreenWidth, 44);
        
        if (self.isCourseVideoMainScreen)
        {
            self.courseVideoController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2 - PointImageHeight/2);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)100*NSEC_PER_MSEC), dispatch_get_main_queue(),^{
                self.courseVideoController.frameView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2 - PointImageHeight/2);
            });
            self.courseVideoController.frameView.contentMode = UIViewContentModeScaleAspectFit;
            
            
            if ([self.videoType isEqualToString:@"4"]) {
                self.coursewareController.view.frame = CGRectMake(0, ScreenHeight/2 - PointImageHeight/2, ScreenWidth, ScreenHeight/2 - PointImageHeight/2);
                self.coursewareController.frameView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2 - PointImageHeight/2);
                self.coursewareController.frameView.contentMode = UIViewContentModeScaleAspectFit;
                [self.coursewareController play];
            }

        }
        else
        {
            
            self.coursewareController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2 - PointImageHeight/2);
            self.coursewareController.frameView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2 - PointImageHeight/2);
            self.coursewareController.frameView.contentMode = UIViewContentModeScaleAspectFit;
            
            self.courseVideoController.view.frame = CGRectMake(0, ScreenHeight/2 - PointImageHeight/2, ScreenWidth, ScreenHeight/2 - PointImageHeight/2);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)200*NSEC_PER_MSEC), dispatch_get_main_queue(),^{
                self.courseVideoController.frameView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2 - PointImageHeight/2);
            });

            self.courseVideoController.frameView.contentMode = UIViewContentModeScaleAspectFit;
            [self.courseVideoController play];
        }
        
        self.fullScreen = NO;
        self.scrollView.hidden = NO;
    }
    else
    {
        [self.videoContainerView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        self.videoContainerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        //控制条
        self.topBar.frame = CGRectMake(0, 0, ScreenHeight, 44);
        self.bottomBar.frame = CGRectMake(0, ScreenWidth-44, ScreenHeight, 44);
        
        if (self.isCourseVideoMainScreen)
        {
            //暂停节省资源、且为全屏切换做准备。
            //[self.coursewareController pause];
            if ([self.videoType isEqualToString:@"4"]) {
                self.coursewareController.view.hidden = YES;
                self.coursewareController.view.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
                self.coursewareController.frameView.frame =  CGRectMake(0, 0, ScreenHeight, ScreenWidth);
                
            }
            
            self.courseVideoController.view.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)200*NSEC_PER_MSEC), dispatch_get_main_queue(),^{
                self.courseVideoController.frameView.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
            });

        }
        else
        {
            //暂停节省资源、且为全屏切换做准备。
            //[self.courseVideoController pause];
            self.courseVideoController.view.hidden = YES;
            self.courseVideoController.view.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
            self.courseVideoController.frameView.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
            
            self.coursewareController.view.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)200*NSEC_PER_MSEC), dispatch_get_main_queue(),^{
                self.coursewareController.frameView.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
            });
        }
        
        self.fullScreen = YES;
        self.scrollView.hidden = YES;
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

/**
 *  添加打点图片
 */
-(void)setupScrollImageView
{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.videoContainerView.frame), ScreenWidth, PointImageHeight);
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 10);
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    int scrollContentWidth = 0;
    for (int i=0; i<self.playbackPointArray.count; i++)
    {
        JSPlaybackPointVO *playbackPointVO = self.playbackPointArray[i];
        
        CGFloat imgX = i*self.view.frame.size.width / 5;
        
        UIView *viewContainer = [[UIView alloc]initWithFrame:CGRectMake(imgX, 0, self.view.frame.size.width / 5, PointImageHeight)];
        viewContainer.contentMode = UIViewContentModeCenter;
        viewContainer.userInteractionEnabled = YES;
        
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(5, 5, self.view.frame.size.width / 5 - 10, PointImageHeight-8);
        [btn addTarget:self action:@selector(scrollBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewContainer addSubview:btn];
        [self.scrollBtnArray addObject:btn];
        [self.scrollView addSubview:viewContainer];
        
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:playbackPointVO.pic] forState:UIControlStateNormal];
        
        scrollContentWidth = imgX + self.view.frame.size.width / 5 - 10;
        self.scrollView.contentSize = CGSizeMake(scrollContentWidth, 0);
    }
    
    
}

-(void)scrollBtnDidClick:(UIButton *)btn
{
    JSPlaybackPointVO *pointVo = [self.playbackPointArray objectAtIndex:btn.tag];
    
    self.selectedButton.selected = NO;
    self.selectedButton.superview.layer.borderColor = [UIColor clearColor].CGColor;
    self.selectedButton.superview.layer.borderWidth = 0;
    
    btn.selected = YES;
    btn.superview.layer.borderColor = [UIColor greenColor].CGColor;
    btn.superview.layer.borderWidth = 2;
    self.selectedButton = btn;
    
    //显示控制Bar并且开始计时隐藏
    self.topBar.hidden = NO;
    self.bottomBar.hidden = NO;
    self.bottomBarSecond.hidden = NO;
    [self touchesBegan:nil withEvent:nil];
    
    NSLog(@"--------pointVo:%ld", (long)pointVo.time);
    if (self.isPlayingBoth)
    {
        //如果任意一个缓冲中，则无效。
        //如果任意一个缓冲中，则无效。
        if([self.videoType isEqualToString:@"4"]){
            if ([self.courseVideoController.activityIndicatorView isAnimating] || [self.coursewareController.activityIndicatorView isAnimating])
            {
                [MBProgressHUD showError:@"正在缓冲中。。。请您耐心等待！"];
            }
            else
            {
                [self.courseVideoController setMoviePosition:(long)pointVo.time];
                [self.coursewareController setMoviePosition:(long)pointVo.time];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)2000*NSEC_PER_MSEC), dispatch_get_main_queue(),^{
                    [self.courseVideoController play];
                    [self.coursewareController play];
                });
            }
            
        }
        
        if ([self.courseVideoController.activityIndicatorView isAnimating]) {
            [MBProgressHUD showError:@"正在缓冲中。。。请您耐心等待！"];
        }else{
            [self.courseVideoController setMoviePosition:(long)pointVo.time];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)2000*NSEC_PER_MSEC), dispatch_get_main_queue(),^{
                [self.courseVideoController play];
            });
        }
    }
}

@end

