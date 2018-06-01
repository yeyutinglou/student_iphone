//
//  ClassRoomMapBoard.m
//  teacher_iphone
//
//  Created by gaoyi on 14/12/13.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "ClassRoomMapBoard.h"

@interface ClassRoomMapBoard ()

@end

@implementation ClassRoomMapBoard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    self.title = @"地图";
//    dictSelCourse = self.dictCourse;
//    [self showMenuBtn];
    [self loadMap];
//
//    [self showStarInfo];
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
//    [self getCourseNote:dictSelCourse[@"id"]];
//    [myTableView reloadData];
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


- (void)loadMap
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //        [self.locationManager startUpdatingLocation];
    if(IOS8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self creatLocation];
    

    
    myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.viewHeight)];
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
    [self.view addSubview:myMapView];
    
//    if ([CLLocationManager locationServicesEnabled])
        //                && (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusNotDetermined))
//    {

//    }

    
    float latitude = [self.classRoomDict[@"classroomLatitude"]?self.classRoomDict[@"classroomLatitude"]:self.classRoomDict[@"latitude"] floatValue];
    float longitude = [self.classRoomDict[@"classroomLongitude"]?self.classRoomDict[@"classroomLongitude"]:self.classRoomDict[@"longitude"] floatValue];
    
    CLLocationCoordinate2D center;//= CLLocationCoordinate2DMake(latitude, locationManager);
    center.latitude = latitude;
    center.longitude = longitude;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [myMapView setRegion:region animated:YES];
    
    MKPointAnnotation *bokan = [[MKPointAnnotation alloc] init];
    bokan.coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)latitude, (CLLocationDegrees)longitude);
    bokan.title = self.classRoomDict[@"classroomName"]?self.classRoomDict[@"classroomName"]:self.classRoomDict[@"teachBuildName1"];
//    bokan.subtitle = @"努力学习";
    [myMapView addAnnotation:bokan];
    [myMapView selectAnnotation:bokan animated:YES];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    } else {
        static NSString *identifier = @"mapAnnotation";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        annotationView.annotation = annotation;
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
        return annotationView;

    }
}

- (void)creatLocation
{
    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self.locationManager startUpdatingLocation];
    }
    else {
        NSLog(@"请开启定位功能！");
       
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 获取到的用户位置
    NSLog(@"MKUserLocation: %.4f, %.4f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
    // 移动显示区域
//    [mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.033, 0.033)) animated:YES];
//    
//    // 对用户位置标注视图
//    [mapView selectAnnotation:userLocation animated:YES];
}

// Core Location定位回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations)
    {
        CLLocation *location = [locations lastObject];
        NSLog(@"Core Location: %.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude);
        
        // 保存用户位置
        
        // 设置地图视图显示用户位置
        myMapView.showsUserLocation = YES;
    }
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Core Location: location failed.");
    [manager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
