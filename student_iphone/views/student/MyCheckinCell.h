//
//  MyCheckinCell.h
//  ClassRoom
//
//  Created by he chao on 14-6-26.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCheckinCell : UITableViewCell{
    BaseLabel *name,*teacher,*classroom,*time,*date[200],*count_uncheck;
    //AttributedLabel *count_uncheck;
    UIView *viewCheckin;
    BeeUIImageView *imgStatus[200],*line[200];
}

@property (nonatomic, strong) NSMutableDictionary *dictCourse;
- (void)initSelf;
- (void)load;
@end
