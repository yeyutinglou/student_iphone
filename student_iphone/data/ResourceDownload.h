//
//  ResourceDownload.h
//  teacher_ipad
//
//  Created by he chao on 1/15/15.
//  Copyright (c) 2015 leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResourceDownloadDelegate<NSObject>

@optional
- (void)downloadSuccess:(NSString *)strResourceName;
- (void)downloadFailed:(NSString *)strResourceName;

@end

@interface ResourceDownload : NSObject{
}

@property (nonatomic, assign) id <ResourceDownloadDelegate> delegate;

//AS_SINGLETON(ResourceDownload)

- (void)downloadResource:(NSString *)requestUrl;
@end
