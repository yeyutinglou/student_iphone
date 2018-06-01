//
//  JSPlaybackCourseVideoViewController.h
//  JSmaster
//
//  Created by jyd on 15/1/6.
//  Copyright (c) 2015年 JYD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KxMovieDecoder;

extern NSString * const JsPlaybackCourseVideoParameterMinBufferedDuration;    // Float
extern NSString * const JsPlaybackCourseVideoParameterMaxBufferedDuration;    // Float
extern NSString * const JsPlaybackCourseVideoParameterDisableDeinterlacing;   // BOOL


@protocol JSPlaybackCourseVideoDelegete <NSObject>

@optional
//切换当前视频和课件视图
-(void)exchangeVideoCourseware:(BOOL) courseVideo;
//隐藏底部控制条
-(void)hideBottomBar;
//更新顶部控制条数据
-(void)updateTopHud:(CGFloat) position duration:(CGFloat) duration type:(NSString *)type;

@end

@interface JSPlaybackCourseVideoViewController : UIViewController

+ (id) movieViewControllerWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters
                             audioEnabled:(BOOL)audioEnabled;

@property (readonly) BOOL playing;
@property (readwrite) BOOL audioEnabled;

- (void) play;
- (void) pause;
- (UIView *) frameView;
- (void) enableAudio: (BOOL) on;
- (void) setMoviePosition: (CGFloat) position;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, weak) id<JSPlaybackCourseVideoDelegete> delegete;

@end
