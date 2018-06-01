//
//  LLXGeoTransform.m
//
//  Created by liulixiang1988 on 13-11-22.
//  Copyright (c) 2013年 liulixiang1988. All rights reserved.
//

#import "LLXGeoTransform.h"
#import <MapKit/MapKit.h>

static const double a = 6378245.0;
static const double ee = 0.00669342162296594323;

@interface LLXGeoTransform ()
+(double)transformLat:(CLLocationCoordinate2D)coordinate;
+(double)transformLon:(CLLocationCoordinate2D)coordinate;
@end

@implementation LLXGeoTransform

+(CLLocation *) locationTransformStarndardLocation:(CLLocation*)standardLocation
{
    if ([LLXGeoTransform outOfChina: standardLocation ])
    {
        return standardLocation;
    }
    double dLat = [LLXGeoTransform transformLat:standardLocation.coordinate];
    double dLon = [LLXGeoTransform transformLon:standardLocation.coordinate];
    double radLat = standardLocation.coordinate.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    CLLocationCoordinate2D newCoordinate = CLLocationCoordinate2DMake(standardLocation.coordinate.latitude + dLat, standardLocation.coordinate.longitude + dLon);
    CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:newCoordinate
                                                            altitude:standardLocation.altitude
                                                  horizontalAccuracy:standardLocation.horizontalAccuracy
                                                    verticalAccuracy:standardLocation.verticalAccuracy
                                                              course:standardLocation.course
                                                               speed:standardLocation.speed
                                                           timestamp:standardLocation.timestamp];
    
    return newLocation;
}

+(BOOL)outOfChina:(CLLocation *)standardLoaction
{
    if (standardLoaction.coordinate.longitude < 72.004 || standardLoaction.coordinate.longitude > 137.8347)
        return true;
    if (standardLoaction.coordinate.latitude < 0.8293 || standardLoaction.coordinate.latitude > 55.8271)
        return true;
    return false;
}

+(double)transformLat:(CLLocationCoordinate2D)coordinate
{
    double x = coordinate.longitude - 105.0;
    double y = coordinate.latitude - 35.0;
    
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+(double)transformLon:(CLLocationCoordinate2D)coordinate
{
    double x = coordinate.longitude - 105.0;
    double y = coordinate.latitude - 35.0;
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

@end
