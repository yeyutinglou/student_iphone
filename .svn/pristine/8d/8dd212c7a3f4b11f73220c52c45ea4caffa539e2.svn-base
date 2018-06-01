//
//  JYDCheckUpdate.m
//  JSmaster
//
//  Created by jyd on 16/4/12.
//  Copyright © 2016年 JYD. All rights reserved.
//

#import "JYDCheckUpdate.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

static NSDictionary *updateJsonDict;

@interface JYDCheckUpdate ()

@end

@implementation JYDCheckUpdate

/**
 *  检查版本更新
 *  ?schoolCode=D6CE345D16274335A0E50EBFD9210453&appType=3&systemType=2&machineType=1
 */
+ (void)checkVerBySchoolCode:(NSString *)schoolCode
                     appType:(int)appTypeParam
                  systemType:(int)systemTypeParam
                 machineType:(int)machineTypeParam
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"schoolCode"]   = schoolCode;
    params[@"appType"]      = [NSString stringWithFormat:@"%d", appTypeParam];//1领导 2老师端 3学生端
    params[@"systemType"]   = [NSString stringWithFormat:@"%d", systemTypeParam];//1 android 2 ios
    params[@"machineType"]  = [NSString stringWithFormat:@"%d", machineTypeParam];//1手机2 pad
    
    [manager POST:@"http://app.qxketang.com/app/download/get_app_version.action" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        /**
         * 获取内容示例
         *{
         "STATUS": "0",
         "INFO": {
         "productName": "",
         "pubDate": "",
         "version": "3.0",
         "desc": "",
         "versionDesc": "3.0",
         "updateContent": "3.0",
         "url": "itms-services://?action=download-manifest&amp;url=https://dn-1jiaoshi.qbox.me/Student3.0.plist",
         "mustUpdate": "0"
         }
         }
         */
        
        NSString *tmpStr  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        tmpStr = [tmpStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if (tmpStr == nil || [tmpStr isEqualToString:@""])
        {
            [MBProgressHUD showError:@"更新接口返回数据JSON解析失败!"];
            return;
        }
        
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[tmpStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        updateJsonDict = jsonDict;
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDict objectForKey:@"CFBundleVersion"];
        NSLog(@"CFBundleVersion:%@", appVersion);
        
        NSString *onlineVersion = jsonDict[@"INFO"][@"version"];
        
        if (onlineVersion && [onlineVersion floatValue]>[appVersion floatValue])
        {
            //强制更新
            if ([jsonDict[@"INFO"][@"mustUpdate"] isEqualToString:@"1"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新版本可供下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                alert.tag = 10000;
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 10001;
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000)
    {
        if (buttonIndex==1)
        {
            [self sureToUpdate];
        }
    }
    else if(alertView.tag == 10001)
    {
        [self sureToUpdate];
    }
}

-(void)sureToUpdate
{
    //@"itms-services://?action=download-manifest&url=https://dn-1jiaoshi.qbox.me/JSmaster.plist";
    NSString *url = updateJsonDict[@"INFO"][@"url"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
