//
//  SelfStudyRoomCell.m
//  student_iphone
//
//  Created by he chao on 14/11/15.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "SelfStudyRoomCell.h"

@interface SelfStudyRoomCell(){
}

@end

@implementation SelfStudyRoomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadContent:(NSMutableDictionary *)dict{
    _classroom.text = dict[@"classroomName"];
    _time1.text = dict[@"freeTime"];
    _time1.numberOfLines = 0;
    CGFloat height = kStrHeight(_time1.text, _time1.font, kWidth-_time1.left-20);
    _time1.frame = CGRectMake(_time1.left, _time1.top, kWidth-_time1.left-20, height);
}

@end
