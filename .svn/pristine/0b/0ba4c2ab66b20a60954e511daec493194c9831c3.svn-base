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
//  PostImage.m
//  Walker
//
//  Created by he chao on 4/9/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "PostImage.h"

#pragma mark -

@implementation PostImage

- (void)load{
    [super load];
    currentPostIndex = 0;
    arrayPicInfo = [[NSMutableArray alloc] init];
}

- (void)postImages{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/common/upload_pic.action"]].PARAM(@"bisType",[NSString stringWithFormat:@"%d",self.type]).FILE(@"file",UIImageJPEGRepresentation(self.arrayImages[currentPostIndex], 0.5)/*UIImagePNGRepresentation(self.arrayImages[currentPostIndex])*/);
    if (_dictInfo) {
        request.PARAM(@"publicOrgId",_dictInfo[@"id"]);
    }
    BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hasLogin"] boolValue];
    if (hasLogin && kUserInfo[@"id"]) {
        request.PARAM(@"id",kUserInfo[@"id"]);
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    }
    
    request.tag = 9527;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        //[[BeeUITipsCenter sharedInstance] dismissTips];
        //NETWORK_ERROR
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
        [self postError];
    }
    else if (request.succeed)
    {
        //[[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                [arrayPicInfo addObject:json[@"result"]];
                if (currentPostIndex==self.arrayImages.count-1) {
                    [self postSuccess];
                }
                else {
                    currentPostIndex++;
                    [self postImages];
                }
            }
                break;
            default:
            {
                [self postError];
                //[[BeeUITipsCenter sharedInstance] presentFailureTips:json[@"ERRMSG"]];
            }
                break;
        }
    }
}

- (void)postError{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"上传图片失败，是否重试？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [myAlertView show];
}

- (void)postFailed{
    if (self.mainCtrl) {
        [self.mainCtrl performSelector:@selector(uploadImageFailed)];
    }
    
}

- (void)postSuccess{
    if (self.mainCtrl) {
        [self.mainCtrl performSelector:@selector(uploadImageSuccess:) withObject:arrayPicInfo];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self postImages];
    }
    else {
        [self postFailed];
    }
}

- (void)uploadImageFailed{
}

- (void)uploadImageSuccess:(id)data{
}


@end
