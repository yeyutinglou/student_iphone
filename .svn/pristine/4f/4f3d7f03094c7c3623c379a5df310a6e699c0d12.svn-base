//
//  RankingCell.m
//  student_iphone
//
//  Created by jyd on 15/8/19.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "RankingCell.h"
@interface RankingCell ()
{
    IBOutlet UILabel *sortLabel;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *intefralCountLabel;
}
@end
@implementation RankingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)loadCellWithDic:(NSDictionary *)dic{
    sortLabel.text = dic[@"sort"];
    nameLabel.text = dic[@"name"];
    intefralCountLabel.text = dic[@"integralCount"];
    if ([sortLabel.text isEqualToString:@"1"]) {
        sortLabel.textColor = nameLabel.textColor = intefralCountLabel.textColor = RGB(255, 0, 48);
    }else if ([sortLabel.text isEqualToString:@"2"]){
        sortLabel.textColor = nameLabel.textColor = intefralCountLabel.textColor = RGB(254, 127, 50);
    }else if ([sortLabel.text isEqualToString:@"3"]){
        sortLabel.textColor = nameLabel.textColor = intefralCountLabel.textColor = RGB(27, 214, 35);
    }
}
@end
