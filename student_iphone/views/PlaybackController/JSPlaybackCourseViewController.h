//
//  JSPlaybackCourseViewController.h
//  JSmaster
//
//  Created by jyd on 15/1/14.
//  Copyright (c) 2015年 JYD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSPlaybackCourseViewController : UIViewController

/**
 *  学校服务器地址
 */
@property (nonatomic, copy) NSString *schoolServerAddress;

/**
 *  打点信息服务器
 */
@property (nonatomic, copy) NSString *veServerAddress;

/**
 * 课程id，用来获取评价信息
 */
@property (nonatomic, copy) NSString *course_id;

/**
 * 老师id，用来保存评价信息
 */
@property (nonatomic, copy) NSString *teacher_id;

/**
 * 回放视频urls
 */
@property (nonatomic, copy) NSString *teacherUrl;
@property (nonatomic, copy) NSString *coursewareUrl;

/**
 * 回放视频对应的资源记录id
 */
@property (nonatomic, copy) NSString *resourceID;
/**
 *  视频类型
 */
@property (nonatomic, copy) NSString *videoType;

@property (nonatomic, copy) NSDictionary *dic;
@end
