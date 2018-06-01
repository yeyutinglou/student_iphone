//
//  PreviewDataSource.m
//  ClassRoom
//
//  Created by he chao on 6/27/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "PreviewDataSource.h"

@implementation PreviewDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [NSURL fileURLWithPath:self.path];
}

@end
