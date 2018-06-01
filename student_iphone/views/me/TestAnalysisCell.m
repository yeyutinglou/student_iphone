//
//  TestAnalysisCell.m
//  student_iphone
//
//  Created by he chao on 14/11/15.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "TestAnalysisCell.h"

@interface TestAnalysisCell(){
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *lbRate;
    __weak IBOutlet UILabel *lbDate;
    __weak IBOutlet UILabel *lbCount;
    __weak IBOutlet UILabel *lbRight;
    __weak IBOutlet UILabel *lbWrong;
    __weak IBOutlet UIImageView *imgBg;
    __weak IBOutlet UIImageView *line;
    __weak IBOutlet UIImageView *point;
    __weak IBOutlet UIImageView *rateBg;
}

@end

@implementation TestAnalysisCell

- (void)awakeFromNib {
    // Initialization code
    line.frame = CGRectMake(10, 0, 4, 120);
    line.backgroundColor = HEX_RGB(0xcccccc);
    
    point.frame = CGRectMake(6, 20, 12, 12);
    point.backgroundColor = HEX_RGB(0xcccccc);
    point.layer.cornerRadius = point.width/2.0;
    point.layer.masksToBounds = YES;
    point.layer.borderColor = self.backgroundColor.CGColor;
    point.layer.borderWidth = 2;
    
    imgBg.frame = CGRectMake(imgBg.left, imgBg.top, kWidth-imgBg.left-20, imgBg.height);
    rateBg.frame = CGRectMake(imgBg.right-rateBg.width-30, rateBg.top, rateBg.width, rateBg.height);
    lbRate.frame = CGRectMake(rateBg.right-lbRate.width-15, lbRate.top, lbRate.width, lbRate.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadContent:(NSMutableDictionary *)dict{
    
    
    name.text = dict[@"courseName"];
    lbRate.text = [NSString stringWithFormat:@"正确率:%@%%",dict[@"rightRatio"]];
    lbDate.text = [NSString stringWithFormat:@"%@-%@",dict[@"beginDate"],dict[@"endDate"]];
    lbCount.text = [NSString stringWithFormat:@"完成测验:%@套",dict[@"examNum"]];
    lbRight.text = [NSString stringWithFormat:@"%@题",dict[@"rightNum"]];
    lbWrong.text = [NSString stringWithFormat:@"%@题",dict[@"errorNum"]];
}

@end
