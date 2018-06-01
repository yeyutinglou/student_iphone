//
//  PublicInfoView.h
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVScrollPageViewController.h"
#import "FaceSelectView.h"
@class PublicBoard;

@interface PublicInfoView : UIView<UITableViewDataSource,UITableViewDelegate,CVScrollPageViewDeleage>{
    UITableView *myTableView;
    UIView *toolBar;
    BeeUITextView *field;
    CVScrollPageViewController *facePageCtrl;
    NSMutableArray *arrayPublicMsg;
    int pageOffset;
    NSMutableDictionary *dictSelPublicInfo;
    FaceSelectView *faceChooseView;
}
@property (nonatomic, strong) PublicBoard *publicBoard;

- (void)loadContent;
- (void)refresh;

AS_SIGNAL(COMMENT)
AS_SIGNAL(COMMENT_ALL)
AS_SIGNAL(FACE)
AS_SIGNAL(SEND)

@end
