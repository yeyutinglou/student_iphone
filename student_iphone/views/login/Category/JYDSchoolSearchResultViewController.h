//
//  JYDSchoolSearchResultViewController.h
//  teacher_ipad
//
//  Created by jyd on 15/7/16.
//  Copyright (c) 2015年 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYDSchoolSearchResultViewController : UITableViewController

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) NSArray *schoolArray;

@property (nonatomic, strong) NSMutableArray *resultSchools;

@end
