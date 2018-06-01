//
//  StudentListView.h
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentListView : UIView<UITableViewDelegate,UITableViewDataSource>{
    UITableView *myTableView;
    NSMutableArray *arrayStudent;
    BeeUITextField *search;
    NSMutableDictionary *dictSelUser;
    NSIndexPath *selIndexPath;
}

- (void)refresh;
- (void)loadContent;
- (void)hideKeyboard;

AS_SIGNAL(SEARCH)
AS_SIGNAL(ADD)

@end
