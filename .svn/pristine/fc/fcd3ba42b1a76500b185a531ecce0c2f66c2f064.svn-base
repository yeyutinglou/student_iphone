//
//  ResourceDownload.m
//  teacher_ipad
//
//  Created by he chao on 1/15/15.
//  Copyright (c) 2015 leon. All rights reserved.
//

#import "ResourceDownload.h"
#import "MBProgressHUD+MJ.h"
@interface ResourceDownload(){
    NSString *strResource;
}

@end

@implementation ResourceDownload
//DEF_SINGLETON(ResourceDownload)

- (void)downloadResource:(NSString *)requestUrl{
    [MBProgressHUD showMessage:@"正在加载"];
    strResource = requestUrl;
    [self GET:strResource];
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        //NETWORK_ERROR
        [MBProgressHUD hideHUD];
        [BeeUIAlertView showMessage:@"资源加载失败，请检查网络或者资源是否存在!" cancelTitle:@"确定"];
        [[BeeUITipsCenter sharedInstance] dismissTips];
        
        if (_delegate && [_delegate respondsToSelector:@selector(downloadFailed:)]) {
            [_delegate downloadFailed:strResource];
        }
    }
    else if (request.succeed)
    {
        [MBProgressHUD hideHUD];
        [[BeeUITipsCenter sharedInstance] dismissTips];
        NSString *strKey = [strResource MD5];
        [[BeeFileCache sharedInstance] setObject:request.responseData forKey:strKey];
        if (_delegate && [_delegate respondsToSelector:@selector(downloadSuccess:)]) {
            [_delegate downloadSuccess:strResource];
        }
    }
}

@end
