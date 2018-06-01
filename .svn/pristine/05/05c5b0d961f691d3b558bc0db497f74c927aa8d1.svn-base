//
//  PublicAccountInfoCell.m
//  ClassRoom
//
//  Created by he chao on 6/23/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "PublicAccountInfoCell.h"
#import "PublicAccountInfoListBoard.h"

@implementation PublicAccountInfoCell
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
    
    labelTime = [BaseLabel initLabel:@"2014-04-04 11:00" font:FONT(12) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
    //labelTime.frame = CGRectMake(0, avatar.top, 240, avatar.height);
    [self addSubview:labelTime];
    
    labelContent = [BaseLabel initLabel:@"有5位个发链接佛I啊道具gio哎哦伏I哦啊佛I啊啦时间覅哎哦哎啊额日哦I提哦热体哦额如图购I热U凸" font:FONT(14) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
    //labelContent.frame = CGRectMake(10, imgAvatar.bottom+10, 300, 0);
    //CGSize sz = [labelContent.text sizeWithFont:labelContent.font byWidth:labelContent.width];
    //labelContent.frame = CGRectMake(labelContent.left, labelContent.top, labelContent.width, sz.height);
    [self addSubview:labelContent];
    
    labelComment = [BaseLabel initLabel:@"评论" font:FONT(13) color:RGB(52, 115, 183) textAlignment:NSTextAlignmentCenter];
    labelComment.frame = CGRectMake(self.width-60, 0, 60, 38);
    [self addSubview:labelComment];
    
    content = [[MojiFaceView alloc] initWithFrame:CGRectMake(60, 80, 200, 150)];
    [self addSubview:content];
    
    for (int i = 0; i < 5; i++) {
        commentContent[i] = [[MojiFaceView alloc] init];//[BaseLabel initLabel:@"" font:FONT(13) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
        [self addSubview:commentContent[i]];
    }
    
    for (int i = 0; i < 9; i++) {
        photo[i] = [BeeUIImageView spawn];
        photo[i].frame = CGRectMake(25+(i%3)*55, 30+(i/3)*55, 50, 50);
        photo[i].image = IMAGESTRING(@"demo_icon3");
        photo[i].contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:photo[i]];
    }
    
    allComment = [BaseLabel initLabel:@"查看全部评论" font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:allComment];
}

- (void)load{
//    CGSize sz = [labelName.text sizeWithFont:labelName.font byHeight:20];
//    labelName.frame = CGRectMake(labelName.left, labelName.top, sz.width, 20);
    
    labelTime.text = [DataUtils getMessageTime:self.dictInfo[@"createDate"]];
    labelTime.frame = CGRectMake(25, 5, 200, 17);
    
    NSMutableArray *arrayContent = [[DataUtils sharedInstance] getMessageArray:self.dictInfo[@"content"]];
    content.frame = CGRectMake(labelTime.left, labelTime.bottom+6, 270, [self.dictInfo[@"contentHeight"] floatValue]);
    [content showMessage:arrayContent width:270];
    
    float y = 0;
    float bottom = 0;
    
    y = content.bottom;
    bottom = y;
    
    for (int i = 0; i < 9; i++) {
        photo[i].hidden = YES;
    }
    
    for (int i = 0; i < [self.dictInfo[@"pics"] count]; i++) {
        NSMutableDictionary *dictPic = self.dictInfo[@"pics"][i];
        photo[i].frame = CGRectMake(photo[i].left, y+(i/3)*55, 50, 50);
        photo[i].hidden = NO;
        [photo[i] setImageWithURL:kImage100(dictPic[@"url"]) placeholderImage:IMAGESTRING(@"default_img")];
        [photo[i] makeTappable:PublicAccountInfoCell.PHOTO_FULL withObject:[NSNumber numberWithInt:i]];
        
        bottom = photo[i].bottom;
    }
    
    [labelComment makeTappable:PublicAccountInfoListBoard.COMMENT withObject:self.dictInfo];
    
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
            commentContent[i].frame = CGRectMake(labelTime.left, i==0?(bottom+6):commentContent[i-1].bottom, 240, [dictComment[@"commentHeight"] floatValue]);
            commentContent[i].commentName = [NSString stringWithFormat:@"%@:",dictComment[@"userNickName"]];
            [commentContent[i] showMessage:arrayComment width:commentContent[i].width];
        }
        
        if (commentNum>5) {
            allComment.hidden = NO;
            allComment.frame = CGRectMake(content.left, commentContent[4].bottom+5, 270, 30);
            [allComment makeTappable:PublicAccountInfoListBoard.COMMENT_ALL withObject:self.dictInfo];
            [self addSubview:allComment];
        }
    }
}

ON_SIGNAL2(PublicAccountInfoCell, signal) {
    if ([signal is:PublicAccountInfoCell.PHOTO_FULL]) {
        int index = [signal.object intValue];
        [self.board showFullImage:self.dictInfo[@"pics"] imgV:photo[index] index:index];
    }
}


@end
