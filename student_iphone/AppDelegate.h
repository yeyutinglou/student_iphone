//
//  AppDelegate.h
//  ClassRoom
//
//  Created by he chao on 14-6-16.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
///add by liuhui
@class  SingalLetonButton;
@class chooseBuildingAndFloor;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,MKMapViewDelegate>{
    CLLocationManager *locationManager;
    MKMapView *mapView;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableDictionary *dictFace;

@property (assign, nonatomic) BOOL isOnClassMode; //是否已经是跟屏模式
@property (assign, nonatomic) BOOL isWhiteBoardMode;//是否已经是白板模式
@property (assign, nonatomic) BOOL isTestMode;//是否已经是测验模式
@property (assign, nonatomic) BOOL isQuestionMode;//是否已经是提问模式
@property (nonatomic, assign) BOOL isScreenShots;//是否截图
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL isQuestion;//是否已经是PPT提问模式
@property (nonatomic, copy) NSString *examRecordId;
-(void)startLocation;

@property (nonatomic, strong) SingalLetonButton *btn;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong)  chooseBuildingAndFloor *chooseView;

@end
