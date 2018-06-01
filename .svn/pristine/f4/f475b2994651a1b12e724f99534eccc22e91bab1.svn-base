//
//  WrongCell.m
//  student_iphone
//
//  Created by he chao on 14/11/16.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "WrongCell.h"

@implementation WrongCell

- (void)awakeFromNib {
    // Initialization code
    _countNum.frame = CGRectMake(kWidth-200, _countNum.top, 180, _countNum.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadContent:(NSMutableDictionary *)dict{
    
    _name.text = dict[@"examName"];
    NSString *strError = [NSString stringWithFormat:@"%@",dict[@"errorNum"]];
    NSString *strContent = [NSString stringWithFormat:@"共%@道错题",strError];//@"共5道错题";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strContent];
    [str addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x808080) range:NSMakeRange(0, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x4bac40) range:NSMakeRange(1,strError.length)];
    [str addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x808080) range:NSMakeRange(strError.length+1,strContent.length-1-strError.length)];
    _countNum.attributedText = str;
}

@end
