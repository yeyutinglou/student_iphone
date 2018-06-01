//
//  PublicInfoCell.m
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "PublicInfoCell.h"
#import "PublicInfoView.h"

@implementation PublicInfoCell
DEF_SIGNAL(PHOTO_FULL)

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
    avatar = [AvatarView initFrame:CGRectMake(10, 10, 40, 40) image:IMAGESTRING(@"demo_icon1") borderColor:[UIColor clearColor]];
    [self addSubview:avatar];
    
    labelName = [BaseLabel initLabel:@"疯狂的蜗牛" font:FONT(15) color:RGB(60, 60, 60) textAlignment:NSTextAlignmentLeft];
    labelName.frame = CGRectMake(avatar.right+10, 0, 200, avatar.height);
    [self addSubview:labelName];
    
    labelTime = [BaseLabel initLabel:@"2014-04-04 11:00" font:FONT(12) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
    labelTime.frame = CGRectMake(0, avatar.top, 240, avatar.height);
    [self addSubview:labelTime];
    
    
    content = [[MojiFaceView alloc] initWithFrame:CGRectMake(60, 80, 200, 150)];
    [self addSubview:content];
    
    labelComment = [BaseLabel initLabel:@"评论" font:FONT(13) color:RGB(52, 115, 183) textAlignment:NSTextAlignmentCenter];
    labelComment.frame = CGRectMake(self.width-60, 0, 60, 38);
    [self addSubview:labelComment];
    
    for (int i = 0; i < 9; i++) {
        photo[i] = [BeeUIImageView spawn];
        photo[i].frame = CGRectMake(avatar.right+10+(i%3)*55, avatar.top+30+(i/3)*55, 50, 50);
        photo[i].image = IMAGESTRING(@"demo_icon3");
        photo[i].contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:photo[i]];
    }
    
    for (int i = 0; i < 5; i++) {
        commentContent[i] = [[MojiFaceView alloc] init];//[BaseLabel initLabel:@"" font:FONT(13) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
        [self addSubview:commentContent[i]];
    }
    
    allComment = [BaseLabel initLabel:@"查看全部评论" font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:allComment];
}

- (void)load{
//    for (id element in content.subviews) {
//        [element removeFromSuperview];
//    }
//    
    float y = 0;
    float bottom = 0;
    
    [avatar setImageWithURL:kImage100(self.dictInfo[@"publicOrgPic"]) placeholderImage:IMAGESTRING(@"default_avatar")];
    labelName.text = self.dictInfo[@"publicOrgName"];
    labelTime.text = [DataUtils getMessageTime:self.dictInfo[@"createDate"]];//self.dictInfo[@"createDate"];
    
    CGSize sz = [labelName.text sizeWithFont:labelName.font byWidth:160];
    labelName.frame = CGRectMake(labelName.left, labelName.top, sz.width, 40);
    labelName.numberOfLines = 0;
    
    labelTime.frame = CGRectMake(labelName.right+5, labelName.top+12, labelTime.width, 17);

    NSMutableArray *arrayContent = [[DataUtils sharedInstance] getMessageArray:self.dictInfo[@"content"]];
    content.frame = CGRectMake(labelName.left, labelName.bottom+3, 240, [self.dictInfo[@"contentHeight"] floatValue]);
    [content showMessage:arrayContent width:240];
    
    [labelComment makeTappable:PublicInfoView.COMMENT withObject:self.dictInfo];
    
    y = content.bottom;
    bottom = y;
    
    for (int i = 0; i < 9; i++) {
        photo[i].hidden = YES;
    }
    
    for (int i = 0; i < [self.dictInfo[@"pics"] count]; i++) {
        NSMutableDictionary *dictPic = self.dictInfo[@"pics"][i];
        photo[i].frame = CGRectMake(photo[i].left, y+6+(i/3)*55, 50, 50);
        photo[i].hidden = NO;
        [photo[i] setImageWithURL:kImage100(dictPic[@"url"]) placeholderImage:IMAGESTRING(@"default_img")];
        //[photo[i] setImageWithURL:<#(NSURL *)#>]
        [photo[i] makeTappable:PublicInfoCell.PHOTO_FULL withObject:[NSNumber numberWithInt:i]];
        
        bottom = photo[i].bottom;
    }
    
    
    for (int i = 0; i < 5; i++) {
        commentContent[i].hidden = YES;
    }
    allComment.hidden = YES;
    int commentNum = [self.dictInfo[@"commentNum"] intValue];
    if (commentNum>0) {
        int max = 5;
        if (commentNum<=max) {
            max = commentNum;
        }
        for (int i = 0; i < max; i++) {
            NSMutableDictionary *dictComment = self.dictInfo[@"comments"][i];
            commentContent[i].hidden = NO;
            
            NSMutableArray *arrayComment  = [[DataUtils sharedInstance] getMessageArray:dictComment[@"content"]];
            [arrayComment insertObject:[NSString stringWithFormat:@"%@:",dictComment[@"userNickName"]] atIndex:0];
            commentContent[i].frame = CGRectMake(labelName.left, i==0?(bottom+6):commentContent[i-1].bottom, 240, [dictComment[@"commentHeight"] floatValue]);
            commentContent[i].commentName = [NSString stringWithFormat:@"%@:",dictComment[@"userNickName"]];
            [commentContent[i] showMessage:arrayComment width:commentContent[i].width];
        }
        
        if (commentNum>5) {
            allComment.hidden = NO;
            allComment.frame = CGRectMake(content.left, commentContent[4].bottom+5, 200, 30);
            [allComment makeTappable:PublicInfoView.COMMENT_ALL withObject:self.dictInfo];
            [self addSubview:allComment];
        }
    }
}

ON_SIGNAL2(PublicInfoCell, signal){
    if ([signal is:PublicInfoCell.PHOTO_FULL]) {
        int index = [signal.object intValue];
        [self.board showFullImage:self.dictInfo[@"pics"] imgV:photo[index] index:index];
    }
}

@end
