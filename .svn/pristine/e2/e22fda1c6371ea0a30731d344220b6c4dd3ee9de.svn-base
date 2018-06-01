//
//  SchoolPublicView.h
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicBoard;


@interface SchoolPublicView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *myTableView;
    NSMutableArray *arrayPublic;
    NSMutableDictionary *dictPublic;
}
@property (nonatomic, strong) PublicBoard *publicBoard;

- (void)refresh;
- (void)loadContent;
- (void)getPublicOrgList;

AS_SIGNAL(ATTENTION)
AS_SIGNAL(CANCEL)
AS_SIGNAL(PUBLISH)

@end
