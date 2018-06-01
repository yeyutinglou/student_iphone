//
//  MessageView.h
//  ClassRoom
//
//  Created by he chao on 14-6-24.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView<UITableViewDelegate,UITableViewDataSource>{
    UITableView *myTableView;
    NSMutableArray *arrayMessage;
}

- (void)loadContent;
- (void)loadMessage;

@end
