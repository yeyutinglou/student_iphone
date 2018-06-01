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
//  PublicBoard.m
//  ClassRoom
//
//  Created by he chao on 6/17/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "PublicBoard.h"
#import "AppDelegate.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#pragma mark -

@interface PublicBoard()
{
	//<#@private var#>
}
@end

@implementation PublicBoard
DEF_SIGNAL(INFO)
DEF_SIGNAL(PUBLIC)
DEF_SIGNAL(CREATE)

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
    self.title = @"公众号";
    [self loadContent];
    [self showMenuBtn];
    
    [self observeNotification:@"newPublicInfo"];
//    NSMutableArray *kk = [[NSMutableArray alloc] init];
//    [self getMessageRange:@"jhjkhkjhkjhkjhjkhjkhjkhkjhlkhkljhkjlhkjlhjklhjklghjkgjkgjkhjlkhjklhkjlhjklhjklhljkhlasdasdf[胜利]dsds[哭]z[哭][玫瑰]sdsddssd[妈[妈妈][" :kk];
//    NSLog(@"%@",kk);
//    [self getContentSize:kk];
}

ON_NOTIFICATION(notification){
    if ([notification is:@"newPublicInfo"]) {
        [segment setSelectedSegmentIndex:0];
        [self sendUISignal:PublicBoard.INFO];
        [viewPublicInfo refresh];
    }
}


- (void)getMessageRange:(NSString *)message :(NSMutableArray *)array{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
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



- (void)getContentSize:(NSMutableArray *)arrayContent{
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
            NSString *imageName = [dictFace valueForKey:str];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            
            if ( imagePath ) {
                
                if ( upX > ( VIEW_WIDTH_MAX - kFaceWidth ) ) {
                    
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
                    
                    if ( upX > ( VIEW_WIDTH_MAX - kFaceWidth ) ) {
                        
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
                
                if ( upX > ( VIEW_WIDTH_MAX - kFaceWidth ) ) {
                    
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
        
        viewWidth = VIEW_WIDTH_MAX + VIEW_LEFT * 2;
    }
    else {
        
        viewWidth = upX + VIEW_LEFT;
    }
    
    viewHeight = upY + VIEW_LINE_HEIGHT + VIEW_TOP;
    
    NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake( viewWidth, viewHeight )];
    NSLog(@"%@",sizeValue);
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (viewSchoolPublic) {
        [viewSchoolPublic refresh];
    }
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [popupView removeFromSuperview];
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL2(PublicBoard, signal){
    if ([signal is:PublicBoard.INFO]) {
        if (!viewPublicInfo) {
            viewPublicInfo = [[PublicInfoView alloc] initWithFrame:CGRectMake(0, 50, self.viewWidth, self.viewHeight-50-50-(IOS7_OR_LATER?64:44))];
            [viewPublicInfo loadContent];
            viewPublicInfo.publicBoard = self;
        }
        [self.view addSubview:viewPublicInfo];
        [viewPublicInfo refresh];
        
        if (viewCreate) {
            [viewCreate hideKeyboard];
        }
    }
    else if ([signal is:PublicBoard.PUBLIC]) {
        if (!viewSchoolPublic) {
            viewSchoolPublic = [[SchoolPublicView alloc] initWithFrame:CGRectMake(0, 50, self.viewWidth, self.viewHeight-50-50-(IOS7_OR_LATER?64:44))];
            [viewSchoolPublic loadContent];
            viewSchoolPublic.publicBoard = self;
        }
        [self.view addSubview:viewSchoolPublic];
        [viewSchoolPublic refresh];
        if (viewCreate) {
            [viewCreate hideKeyboard];
        }
    }
    else if ([signal is:PublicBoard.CREATE]) {
        if (!viewCreate) {
            viewCreate = [[CreateAccountView alloc] initWithFrame:CGRectMake(0, 50, self.viewWidth, self.viewHeight-50-50-(IOS7_OR_LATER?64:44))];
            [viewCreate loadContent];
            viewCreate.publicBoard = self;
        }
        [self.view addSubview:viewCreate];
    }
}

- (void)loadContent{
    
    segment = [BeeUISegmentedControl spawn];
    [segment addTitle:@"公众号信息" signal:PublicBoard.INFO];
    [segment addTitle:@"校园公众号" signal:PublicBoard.PUBLIC];
    [segment addTitle:@"申请公众号" signal:PublicBoard.CREATE];
    
    segment.tintColor = RGB(117, 213, 73);
    segment.frame = CGRectMake((self.viewWidth-260)/2.0, 10, 260, 30);
    [segment setSelectedSegmentIndex:0];
    [self.view addSubview:segment];
    
    [self sendUISignal:PublicBoard.INFO];
}

#pragma mark - full image
- (void)showFullImage:(NSArray *)pics imgV:(BeeUIImageView *)imgV index:(int)index{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < [pics count]; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:pics[i][@"url"]]; // 图片路径
        //photo.strDescription = arrayPhotos[i][@"description"];
        if (i==index) {
            photo.srcImageView = imgV;
        }
        
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
