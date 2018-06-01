//
//  AppDelegate.m
//  ClassRoom
//
//  Created by he chao on 14-6-16.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainBoard.h"
#import "ChooseRulerBoard.h"
#import "LLXGeoTransform.h"
#import "SocketData.h"
#import "QuestionBoard.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    sleep(2);
    [self loadData];
    
    [[MessageRequest sharedInstance] setModel:NO];
    //[BeeLogger sharedInstance].showLevel = NO;
    //[BeeLogger sharedInstance].
    
    [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
    [BeeUINavigationBar setBackgroundImage:[[UIImage imageNamed:@"navi_bg"] stretchableImageWithLeftCapWidth:1 topCapHeight:0]];
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    //self.window.rootViewController = self.viewController;
    //self.window.rootViewController = [BeeUIStack stack:@"root" firstBoard:[HomePageBoard sharedInstance]];
    
    //self.window.rootViewController = [BeeUIStack stack:@"root" firstBoard:[MainBoard sharedInstance]];
    [self startLocation];
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hasLogin"] boolValue];
    if (hasLogin) {
        [self getUserInfo];
        self.window.rootViewController = [BeeUIStack stack:@"root" firstBoard:[MainBoard sharedInstance]];
    }
    else {
        self.window.rootViewController = [BeeUIStack stack:@"root" firstBoard:[[ChooseRulerBoard alloc] init]];
    }
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = [[QuestionBoard alloc] init];
//    
//    mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
//    mapView.delegate = self;
//    mapView.showsUserLocation = YES;
    [self.window makeKeyAndVisible];
    
    //[self checkVer];
    
    return YES;
}

///获取用户信息

-(void)getUserInfo
{
    NSString *url = [NSString stringWithFormat:@"%@app/user/get_myself_user_info.action",kSchoolUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:kUserInfo[@"sessionId"] forHTTPHeaderField:@"sessionId"];
    [manager POST:url parameters:@{@"id":kUserId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([STATUS_SUCCESS isEqualToString:responseObject[@"STATUS"]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject[@"result"] JSONString] forKey:@"userInfo"];
        }
        
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
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
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"有新版本可供下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            [myAlertView show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JYDLog(@"%@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        //NSString *url = @"https://itunes.apple.com/us/app/tu-you/id886515399?l=zh&ls=1&mt=8";
        NSString *url = @"itms-services://?action=download-manifest&url=https://dn-1jiaoshi.qbox.me/studentIphone.plist";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
            [locationManager requestAlwaysAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
    else
    {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,否则无法签到成功,请到设置->隐私,打开轻新课堂定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        
    }
    
}


- (void)loadData{
    [[NSUserDefaults standardUserDefaults] setObject:@"key" forKey:@"questionCode"];
    [[NSUserDefaults standardUserDefaults] setObject:@"key" forKey:@"examRecordId"];
    NSString *txt = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"face" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [txt componentsSeparatedByString:@"\r\n"];
    self.dictFace = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSString *temp = [array objectAtIndex:i];
        NSArray *tempArray = [temp componentsSeparatedByString:@","];
        [self.dictFace setObject:[tempArray objectAtIndex:0] forKey:[tempArray objectAtIndex:1]];
    }
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:@"longitude"];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"%f     %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] forKey:@"longitude"];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    NSLog(@"=========%@",locations);
    CLLocation *newLocation = locations[0];
    CLLocation *new = [LLXGeoTransform locationTransformStarndardLocation:newLocation];
    CLLocationCoordinate2D oldCoordinate = new.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",oldCoordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",oldCoordinate.longitude] forKey:@"longitude"];
    
    
    
    [manager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self heartbeat];}];
    if (backgroundAccepted)
    {
        NSLog(@"backgrounding accepted");
    }
}

- (void)heartbeat
{
    [[SocketData sharedInstance] keeplive];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] clearKeepAliveTimeout];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self startLocation];
    [[MainBoard sharedInstance] getSignTime];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
