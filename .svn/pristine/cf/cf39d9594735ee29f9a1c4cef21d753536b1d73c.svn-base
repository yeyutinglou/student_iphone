//
//  PersonalCenterCell.m
//  student_iphone
//
//  Created by jyd on 15/8/19.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "PersonalCenterCell.h"
@interface PersonalCenterCell ()
{
    IBOutlet UILabel *name;
    
    IBOutlet UILabel *gold;
}
@end
@implementation PersonalCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCellWithDic:(NSDictionary *)dic{
    name.text = dic[@"name"];
    gold.text = [NSString stringWithFormat:@"+%@金币",dic[@"integralScore"]];
}
@end
