//
//  TeacherListView.h
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherListView : UIView<UITableViewDelegate,UITableViewDataSource>{
    UITableView *myTableView;
    NSMutableArray *arrayTeacher;
    BeeUITextField *search;
}
- (void)refresh;
- (void)loadContent;
- (void)hideKeyboard;

AS_SIGNAL(SEARCH)

@end
