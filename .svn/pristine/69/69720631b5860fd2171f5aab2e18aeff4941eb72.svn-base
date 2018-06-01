//
//  NotesCell.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "NotesCell.h"

@implementation NotesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initSelf{
    source = [BaseLabel initLabel:@"教务处" font:BOLDFONT(16) color:RGB(73, 172, 28) textAlignment:NSTextAlignmentLeft];
    source.frame = CGRectMake(18, 10, 200, 20);
    [self addSubview:source];
    
    BeeUIImageView *eye = [BeeUIImageView spawn];
    eye.frame = CGRectMake(230, source.top, 30, 20);
    eye.image = IMAGESTRING(@"eye");
    [self addSubview:eye];
    
    count = [BaseLabel initLabel:@"10000" font:FONT(15) color:RGB(121, 121, 121) textAlignment:NSTextAlignmentLeft];
    count.frame = CGRectMake(eye.right, source.top, 100, 20);
    [self addSubview:count];
    
    time = [BaseLabel initLabel:@"2014-04-04 11:11" font:FONT(13) color:count.textColor textAlignment:NSTextAlignmentLeft];
    time.frame = CGRectMake(source.left, source.bottom, 200, 15);
    [self addSubview:time];
    
    bg = [BeeUIImageView spawn];
    bg.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:bg];
    
    title = [BaseLabel initLabel:@"端午节各种标题端午节各种标题端午节各种标题端午节各种标题" font:BOLDFONT(16) color:RGB(38, 38, 38) textAlignment:NSTextAlignmentLeft];
    [self addSubview:title];
    
    content = [BaseLabel initLabel:@"各种内容各种内容各种内容各种内容各种内容各种内容各种内容各种内容各种内容各种内容" font:FONT(13) color:count.textColor textAlignment:NSTextAlignmentLeft];
    [self addSubview:content];
}

- (void)load{
    bg.frame = CGRectMake(9, time.bottom+5, self.width-18, [self.dictNote[@"height"] floatValue]-55);
    bg.image = [IMAGESTRING(@"noti_bg") stretchableImageWithLeftCapWidth:5 topCapHeight:8];
    
    source.text = self.dictNote[@"academySign"];
    count.text = self.dictNote[@"visitCount"];
    title.text = self.dictNote[@"title"];
    time.text = self.dictNote[@"createDate"];
    content.text = self.dictNote[@"description"];
    
    CGSize szTitle = [title.text sizeWithFont:title.font byWidth:bg.width-16];
    title.frame = CGRectMake(bg.left+8, bg.top+8, bg.width-16, szTitle.height);
    
    CGSize szContent = [content.text sizeWithFont:content.font byWidth:bg.width-16];
    content.frame = CGRectMake(title.left, title.bottom+5, title.width, szContent.height);
}

@end
