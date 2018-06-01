//
//  WrongCell.h
//  student_iphone
//
//  Created by he chao on 14/11/16.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imgPoint;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *countNum;

- (void)loadContent:(NSMutableDictionary *)dict;
@end
