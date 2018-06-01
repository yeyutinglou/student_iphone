//
//  TestDetailAnalysisCell.m
//  student_iphone
//
//  Created by he chao on 14/11/16.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "TestDetailAnalysisCell.h"

@interface TestDetailAnalysisCell()
{
    CGFloat  greenOriginTop;
}

@property (weak, nonatomic) IBOutlet UILabel *name;//测验名称

@property (weak, nonatomic) IBOutlet UILabel *total;//共5道试题

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UIView *green;

@property (weak, nonatomic) IBOutlet UIView *yellow;

@property (weak, nonatomic) IBOutlet UIView *red;

@end

@implementation TestDetailAnalysisCell

- (void)awakeFromNib
{
    // Initialization code
    greenOriginTop = _green.top;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)loadContent:(NSMutableDictionary *)dict
{
    _name.text = dict[@"examName"];
    
    _total.text = [NSString stringWithFormat:@"共%@道试题",dict[@"totalNum"]];
    
    _des.text = [NSString stringWithFormat:@"正确%@道，未做%@道，错误%@道",dict[@"correctNum"],dict[@"spaceNum"],dict[@"errorNum"]];
    
    if ([dict[@"totalNum"] isKindOfClass:[NSNull class]]
        || [dict[@"correctNum"] isKindOfClass:[NSNull class]]
        || [dict[@"spaceNum"] isKindOfClass:[NSNull class]]
        || [dict[@"errorNum"] isKindOfClass:[NSNull class]])
    {
        return;
    }
    CGFloat width = kWidth-_green.left-20;
    NSInteger total = [dict[@"totalNum"] integerValue];
    NSInteger right = [dict[@"correctNum"] integerValue];
    NSInteger space = [dict[@"spaceNum"] integerValue];
    NSInteger error = [dict[@"errorNum"] integerValue];
    
    _green.frame = CGRectMake(_green.left, greenOriginTop-10, 1.0*width*right/total, _green.height);
    _yellow.frame = CGRectMake(_green.right, greenOriginTop, 1.0*width*space/total, _green.height);
    _red.frame = CGRectMake(_yellow.right, greenOriginTop, 1.0*width*error/total, _green.height);
}

@end
