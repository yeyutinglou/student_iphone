//
//  SocketData.h
//  teacher_ipad
//
//  Created by he chao on 1/9/15.
//  Copyright (c) 2015 leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketData : NSObject

AS_SINGLETON(SocketData)

typedef enum{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
}SocketOfflineType;

@property (nonatomic, strong) NSMutableDictionary   *dictSocket;
@property (nonatomic, strong) NSString              *strGid,*strGroupName;//GID 老师的讲ID
@property (nonatomic, strong) NSTimer               *connectTimer; // 计时器

- (void)connectSocket:(NSString *)strHost port:(NSString *)strPort;
- (void)sendSocketData:(NSMutableDictionary *)dict;
- (void)connect;

//是否显示了测验结果---add by zhaojian
@property (nonatomic, assign) BOOL isTestResultShow;


- (void)keeplive;

@end
