//
//  WDefault.h
//  Walker
//
//  Created by he chao on 3/10/14.
//  Copyright (c) 2014 leon. All rights reserved.
//

#ifndef Walker_WDefault_h
#define Walker_WDefault_h

#import "DataUtils.h"
#import "MessageRequest.h"
#import "MessageDB.h"
#import "ChatDB.h"
#import "AttributedLabel.h"
#import "SVPullToRefresh.h"
#import "MojiView.h"
#import "MojiFaceView.h"
#import "VoiceView.h"
#import <CoreTelephony/CoreTelephonyDefines.h>
#import "AsyncSocket.h"

#define  NETWORK_ERROR {\
[BeeUIAlertView showMessage:@"网络不给力，请检查网络" cancelTitle:@"确定"];\
}

//#import "MessageModel.h"
//#import "ChatDB.h"
//#import "MessageDB.h"
//#import "DataUtils.h"
//#import "LoginBoard.h"

#import "UIView+Border.h"

#define kTipLoading [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在加载"];

#define RGBCOLOR(_R_, _G_, _B_) [UIColor colorWithRed:(CGFloat)(_R_)/255.0f green: (CGFloat)(_G_)/255.0f blue: (CGFloat)(_B_)/255.0f alpha: 1.0f]

#define kGrayColor RGBCOLOR(166,166,166)
#define kHeaderColor RGB(95, 219, 247)

#define kFont(_SIZE) [UIFont systemFontOfSize:_SIZE]
#define kBoldFont(_SIZE) [UIFont boldSystemFontOfSize:_SIZE]
#define FONT(_SIZE) [UIFont systemFontOfSize:_SIZE]
#define BOLDFONT(_SIZE) [UIFont boldSystemFontOfSize:_SIZE]
#define IMAGESTRING(_STRING) [UIImage imageFromString:_STRING]

#define kBadge @"badge"
#define isDebug YES
#define kBaseUrl @"http://app.qxketang.com/"//isDebug?@"http://111.204.62.1:8096/":@"http://www.qingxinketang.com/app_global/"//

#define kGoldUrl @"http://192.168.3.249:8081/"
#define kSchoolUrl [[NSUserDefaults standardUserDefaults] valueForKey:@"school"][@"schoolServiceURL"]
#define kVeUrl [[NSUserDefaults standardUserDefaults] valueForKey:@"school"][@"veURL"]
//http://127.0.0.1:88/ve/webservices/app_qxkt.shtml?method=getMenu
#define kVideoType @"webservices/app_qxkt.shtml?method=getMenu"

//add by zhaojian 2015-08-14
#define kSchoolVerificationType [[NSUserDefaults standardUserDefaults] valueForKey:@"school"][@"verificationType"]

#define kAppKey @"8CDD8F305A1F8BFA36876EDD9B89F5F0"
#define kUserInfo [[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] mutableObjectFromJSONString]
#define kStrTrim(STRING)  [STRING stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] 
#define kUuid [[NSUserDefaults standardUserDefaults] valueForKey:@"uuid"]
#define INTTOSTRING(_INT) [NSString stringWithFormat:@"%d",_INT]
#define kImage100(URL) [NSString stringWithFormat:@"%@",URL]
#define kImage150(URL) [NSString stringWithFormat:@"%@_z150x150",URL]
#define pageSize 10
#define kGetChatTime 5
#define kMessageTime 20

#define kStrWidth(_STR,_FONT,_HEIGHT) [_STR sizeWithFont:_FONT byHeight:_HEIGHT].width
#define kStrHeight(_STR,_FONT,_WIDTH) [_STR sizeWithFont:_FONT byWidth:_WIDTH].height


#define isTeacher [[[NSUserDefaults standardUserDefaults] valueForKey:@"teacher"] boolValue]

#pragma mark face

#define kSocketServer @"210.14.140.60"


#define FACE_NAME_HEAD  @"["
#define FACE_NAME_END @"]"
#define FACE_NAME_LEN 3
#define kFaceWidth 18
#define kFaceHeight 18
#define VIEW_WIDTH_MAX      200

#define VIEW_LEFT 0
#define VIEW_RIGHT 0
#define VIEW_TOP 0
#define VIEW_LINE_HEIGHT    24

#define kUserId kUserInfo[@"id"]

#define kDownloadType [[NSUserDefaults standardUserDefaults] objectForKey:@"downloadType"]

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


// 请求结果类型
#define STATUS_SUCCESS @"0" // 成功
#define STATUS_FAILURE @"1" // 失败
#define STATUS_EMPTY @"2" // 空结果

#define kIsCreate [[NSUserDefaults standardUserDefaults] boolForKey:@"isCreate"]

//兑吧
#define kDBAPP_KEY @"4QZTGFZwujD4JYZehrgP96sjxMv9"
#define kDBAPP_SECRECT @"35X3UgpYCfQNsP14GnvhVw7AyZrq"


//保存缓存
#define kSaveCache(_DATA,_KEY) [[BeeFileCache sharedInstance] setObject:[_DATA JSONString] forKey:[NSString stringWithFormat:@"%@_%@",kUserId,_KEY]]
//取缓存
#define kGetCache(_KEY) [[[BeeFileCache sharedInstance] objectForKey:[NSString stringWithFormat:@"%@_%@",kUserId,_KEY]] mutableObjectFromJSONData]

#define kSaveCommenCache(_DATA,_KEY) [[BeeFileCache sharedInstance] setObject:[_DATA JSONString] forKey:[NSString stringWithFormat:@"%@",_KEY]]

#define kGetCommenCache(_KEY) [[[BeeFileCache sharedInstance] objectForKey:[NSString stringWithFormat:@"%@",_KEY]] mutableObjectFromJSONData]

#define kGetControllerByStoryBoard(_strController) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:_strController]

#endif
