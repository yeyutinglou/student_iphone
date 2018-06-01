//
//  AboutBoard.m
//  student_iphone
//
//  Created by jyd on 16/1/14.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "AboutBoard.h"
#import "JYDCheckUpdate.h"
@interface AboutBoard ()
{
    UIAlertView *versionAlert;
    UIAlertView *cachesAlert;
}
@end

@implementation AboutBoard
DEF_SIGNAL(NOTIFITION)
DEF_SIGNAL(VERSION)
DEF_SIGNAL(CACHES)
- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    self.title = @"关于轻新课堂";
    [self loadContent];
    
    //appStore版本需要
    btnNotifition.hidden = YES;
    btnCheckVersion.hidden = YES;
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
    
}

ON_SIGNAL2( AboutBoard, signal )
{
    if ([signal is:AboutBoard.NOTIFITION]) {
        
    }
    else if ([signal is:AboutBoard.VERSION]) {
       // [self checkVer];
        NSDictionary *dictSchool = [[NSUserDefaults standardUserDefaults] objectForKey:@"school"];
        if (dictSchool) {
            [JYDCheckUpdate checkVerBySchoolCode:dictSchool[@"schoolCode"] appType:3 systemType:2 machineType:1];
        }
    }
    else if ([signal is:AboutBoard.CACHES]) {
        [self clearCaches];
    }
    
}

/**
 *  检查版本更新
 */
- (void)checkVer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://app.qxketang.com/download/ios/student/studentIphone_version_ios.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        JYDLog(@"%@", responseObject);
        NSString *tmpStr  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        tmpStr = [tmpStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if (tmpStr == nil || [tmpStr isEqualToString:@""])
        {
            return;
        }
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[tmpStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDict objectForKey:@"CFBundleVersion"];
        JYDLog(@"CFBundleVersion:%@", appVersion);
        
        NSString *onlineVersion = jsonDict[@"INFO"][@"version"];
        if (onlineVersion && [onlineVersion floatValue]>[appVersion floatValue])
        {
            versionAlert = [[UIAlertView alloc] initWithTitle:nil message:@"有新版本可供下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            [versionAlert show];
        }else{
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"已是最新版本"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JYDLog(@"%@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        if (alertView == versionAlert) {
            NSString *url = @"itms-services://?action=download-manifest&url=https://dn-1jiaoshi.qbox.me/studentIphone.plist";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else{
            [self removeAllObjectsWithfilePath:[BeeFileCache sharedInstance].cachePath];
        }
       
    }
}
///清除缓存
-(void)clearCaches{
    float caches = [self folderSizeAtPath:[BeeFileCache sharedInstance].cachePath];
    if (caches == 0.00) {
        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"无缓存"];
    }else{
        cachesAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%.2fM",caches] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
        [cachesAlert show];
    }
    
}
- (void)removeAllObjectsWithfilePath:(NSString *)filePath
{
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
}
    



//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (void)loadContent{
    myScrollView = [BeeUIScrollView spawn];
    myScrollView.frame = self.viewBound;//CGRectMake(0, 0, self.viewWidth, self.viewHeight-44);
    [self.view addSubview:myScrollView];
    BeeUIImageView *imageView = [BeeUIImageView spawn];
    [imageView setFrame:CGRectMake(kWidth/2-50, 10, 100, 100)];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 50;
    imageView.image = [UIImage imageNamed:@"ios120"];
    [myScrollView addSubview:imageView];
    
     NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    BaseLabel *label = [BaseLabel initLabel:[NSString stringWithFormat:@"当前版本 V%@",version] font:FONT(13) color:RGB(117, 213, 73) textAlignment:NSTextAlignmentCenter ];
    label.frame = CGRectMake(kWidth/2-50, imageView.bottom, 100, 40);
    [myScrollView addSubview:label];
    NSArray *arrayTitle = @[@"版本信息",@"检查新版本",@"清缓存"];
    for (int i = 0; i < 3; i++) {
        BaseButton *btn = [BaseButton initBaseBtn:IMAGESTRING(@"setting_btn") highlight:IMAGESTRING(@"setting_btn_pre")];
        btn.frame = CGRectMake(10, 150, 300, 60);
        [myScrollView addSubview:btn];
        
        BaseLabel *label = [BaseLabel initLabel:arrayTitle[i] font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(20, 0, 200, 60);
        [btn addSubview:label];
        
        switch (i) {
            case 0:
            {
                btnNotifition = btn;
                btnNotifition.frame = CGRectMake(btn.left, 150, btn.width, btn.height);
                [btnNotifition addSignal:AboutBoard.NOTIFITION forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 1:
            {
                btnCheckVersion = btn;
                btnCheckVersion.frame = CGRectMake(btn.left, btnNotifition.bottom, btn.width, btn.height);
                [btnCheckVersion addSignal:AboutBoard.VERSION forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 2:
            {
                btnClearCaches = btn;
                btnClearCaches.frame = CGRectMake(btn.left, btnCheckVersion.bottom, btn.width, btn.height);
                [btnClearCaches addSignal:AboutBoard.CACHES forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
        
        BeeUIImageView *imgArrow = [BeeUIImageView spawn];
        imgArrow.frame = CGRectMake(btn.width-25, 0, 25, 60);
        imgArrow.image = IMAGESTRING(@"arrow");
        [btn addSubview:imgArrow];
    }
    

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end