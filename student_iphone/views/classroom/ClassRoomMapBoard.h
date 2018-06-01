//
//  ClassRoomMapBoard.h
//  teacher_iphone
//
//  Created by gaoyi on 14/12/13.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "BaseBoard.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ClassRoomMapBoard : BaseBoard<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *myMapView;

}

@property (nonatomic,strong) NSDictionary *classRoomDict;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end
