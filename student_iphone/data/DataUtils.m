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
//  DataUtils.m
//  Walker
//
//  Created by he chao on 14-4-20.
//    Copyright (c) 2014年 leon. All rights reserved.
//

#import "DataUtils.h"
#import "AppDelegate.h"

#pragma mark -

@implementation DataUtils

DEF_SINGLETON(DataUtils)


+ (BOOL)isValidPhone:(NSString *)strPhone{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:strPhone] == YES)
        || ([regextestcm evaluateWithObject:strPhone] == YES)
        || ([regextestct evaluateWithObject:strPhone] == YES)
        || ([regextestcu evaluateWithObject:strPhone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (NSString *)getMessageTime:(NSString *)strTime{
    if (strTime.length>14) {
        strTime = [strTime substringToIndex:14];
    }
    
    if (strTime.length==0) {
        return nil;
    }
    /*NSString * format = @"yyyy-MM-dd HH:mm:ss z";
     NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
     [formatter setDateFormat:format];
     [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
     
     date = [formatter dateFromString:(NSString *)self];*/
    //NSString *format = @"yyyyMMdd HH:mm:ss";
    NSString *format = @"yyyyMMdd HH:mm";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSDate *dateMessage = [formatter dateFromString:strTime];
    NSTimeInterval t = [dateMessage timeIntervalSinceNow];
    double fabsT = fabs(t);
    int day = fabsT/(24*3600);
    int hour = fabsT/(3600)-day*24;
    int min = fabsT/60-day*24*60-hour*60;
    //long s = fabsT-day*24*3600-hour*3600-min*60;
    if (day>0) {
        return [NSString stringWithFormat:@"%d天前",day];
    }
    else if (hour>0){
        return [NSString stringWithFormat:@"%d小时前",hour];
    }
    else if (min>0) {
        return [NSString stringWithFormat:@"%d分钟前",min];
    }
    else {
        return @"刚刚";
    }
    return nil;
}

+ (NSString *)getChatTime:(NSString *)strTime{
    if (strTime.length==0) {
        return nil;
    }
    NSString *format = @"yyyyMMdd HH:mm:ss";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSDate *dateMessage = [formatter dateFromString:strTime];
    
    NSString *format2 = @"yyyy-MM-dd HH:mm:ss";
    [formatter setDateFormat:format2];
    
    return [formatter stringFromDate:dateMessage];
}

+ (NSString *)getFormatTime:(NSString *)strTime{
    if (strTime.length==0) {
        return nil;
    }
    NSString *format = @"yyyyMMdd";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSDate *dateMessage = [formatter dateFromString:strTime];
    
    NSString *format2 = @"yyyy.MM.dd";
    [formatter setDateFormat:format2];
    
    return [formatter stringFromDate:dateMessage];
}

- (void)setJoinActivity:(NSString *)strId{
    strActivityId = strId;
}

- (NSString *)getJoinId{
    return strActivityId;
}

- (NSMutableArray *)getMessageArray:(NSString *)strMessage{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getMessageRange:strMessage :array];
    return array;
}



- (void)getMessageRange:(NSString *)message :(NSMutableArray *)array{
    if (message.length==0) {
        return;
    }
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *faces = delegate.dictFace;
    NSArray *arrayFaces = faces.allKeys;
    
    NSRange range = [message rangeOfString:FACE_NAME_HEAD];
    if (range.length>0) {
        if (range.location>0) {
            //            if (array.count>0) {
            //                NSString *lastString = [array lastObject];
            //                if ([[lastString substringFromIndex:lastString.length-1] isEqualToString:FACE_NAME_END]) {
            //                    [array replaceObjectAtIndex:(array.count-1) withObject:[NSString stringWithFormat:@"%@%@",lastString,[message substringToIndex:range.location]]];
            //                }
            //            }
            [array addObject:[message substringToIndex:range.location]];
            message = [message substringFromIndex:range.location];
            
            if (message.length>FACE_NAME_LEN) {
                BOOL isFind = NO;
                for (int i = 0; i < arrayFaces.count; i++) {
                    NSRange temp = [message rangeOfString:arrayFaces[i]];
                    if (temp.length>0 && temp.location==0) {
                        isFind = YES;
                        [array addObject:arrayFaces[i]];
                        message = [message substringFromIndex:temp.length];
                        [self getMessageRange:message :array];
                        break;
                    }
                }
                
                if (!isFind) {
                    [array addObject:@"["];
                    message = [message substringFromIndex:1];
                    [self getMessageRange:message :array];
                }
            }
            else if (message.length>0){
                [array addObject:message];
            }
        }
        else {
            if (message.length>FACE_NAME_LEN) {
                BOOL isFind = NO;
                for (int i = 0; i < arrayFaces.count; i++) {
                    NSRange temp = [message rangeOfString:arrayFaces[i]];
                    if (temp.length>0 && temp.location==0) {
                        isFind = YES;
                        [array addObject:arrayFaces[i]];
                        message = [message substringFromIndex:temp.length];
                        [self getMessageRange:message :array];
                        break;
                    }
                }
                
                if (!isFind) {
                    [array addObject:@"["];
                    message = [message substringFromIndex:1];
                    [self getMessageRange:message :array];
                }
            }
            else if (message.length>0){
                [array addObject:message];
            }
        }
    }
    else {
        [array addObject:message];
    }
}

- (CGFloat)getContentSize:(NSMutableArray *)arrayContent width:(CGFloat)width{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *dictFace = delegate.dictFace;
    
    CGFloat upX;
    
    CGFloat upY;
    
    CGFloat lastPlusSize;
    
    CGFloat viewWidth;
    
    CGFloat viewHeight;
    
    BOOL isLineReturn;
    
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    
    isLineReturn = NO;
    
    upX = VIEW_LEFT;
    upY = 0;
    
    for (int index = 0; index < [arrayContent count]; index++) {
        
        NSString *str = [arrayContent objectAtIndex:index];
        if ( [str hasPrefix:FACE_NAME_HEAD] && [str hasSuffix:FACE_NAME_END] ) {
            
            //NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
            //NSString *imageName = [dictFace valueForKey:str];
            NSString *imagePath = [dictFace valueForKey:str];//[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            
            if ( imagePath ) {
                
                if ( upX > ( width - kFaceWidth ) ) {
                    
                    isLineReturn = YES;
                    
                    upX = VIEW_LEFT;
                    upY += VIEW_LINE_HEIGHT;
                }
                
                upX += kFaceWidth;
                
                lastPlusSize = kFaceWidth;
            }
            else {
                
                for ( int index = 0; index < str.length; index++) {
                    
                    NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                    
                    CGSize size = [character sizeWithFont:font
                                        constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                    
                    if ( upX > ( width - kFaceWidth ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = VIEW_LEFT;
                        upY += VIEW_LINE_HEIGHT;
                    }
                    
                    upX += size.width;
                    
                    lastPlusSize = size.width;
                }
            }
        }
        else {
            
            for ( int index = 0; index < str.length; index++) {
                
                NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                
                CGSize size = [character sizeWithFont:font
                                    constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                
                if ( upX > ( width - kFaceWidth ) ) {
                    
                    isLineReturn = YES;
                    
                    upX = VIEW_LEFT;
                    upY += VIEW_LINE_HEIGHT;
                }
                
                upX += size.width;
                
                lastPlusSize = size.width;
            }
        }
    }
    
    if ( isLineReturn ) {
        
        viewWidth = width + VIEW_LEFT * 2;
    }
    else {
        
        viewWidth = upX + VIEW_LEFT;
    }
    
    viewHeight = upY + VIEW_LINE_HEIGHT + VIEW_TOP;
    return viewHeight;
//    NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake( viewWidth, viewHeight )];
//    NSLog(@"%@",sizeValue);
}

@end
