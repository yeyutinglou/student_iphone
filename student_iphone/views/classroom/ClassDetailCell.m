//
//  ClassDetailCell.m
//  ClassRoom
//
//  Created by he chao on 14-6-30.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "ClassDetailCell.h"
#import "ClassDetailBoard.h"

@implementation ClassDetailCell
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
    
    name = [BaseLabel initLabel:@"Leon lai" font:FONT(15) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:name];
    
    time = [BaseLabel initLabel:@"50分钟前" font:FONT(12) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
    [self addSubview:time];
    
    content = [BaseLabel initLabel:@"各种秒杀各种秒杀各种秒杀各种秒杀各种秒杀各种秒杀各种秒杀各种秒杀各种秒杀各种秒杀" font:FONT(14) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
    [self addSubview:content];
    
    voiceView = [[VoiceView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.contentView addSubview:voiceView];
    
    for (int i = 0; i < 9; i++) {
        photo[i] = [BeeUIImageView spawn];
        photo[i].frame = CGRectMake(avatar.right+10+(i%3)*55, avatar.top+30+(i/3)*55, 50, 50);
        photo[i].image = IMAGESTRING(@"demo_icon3");
        photo[i].contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:photo[i]];
    }
    
    del = [BaseLabel initLabel:@"删除" font:FONT(14) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentCenter];
    del.frame = CGRectMake(190, 0, 45, 40);
    [self addSubview:del];
    
    comment = [BaseLabel initLabel:@"评论" font:FONT(14) color:del.textColor textAlignment:NSTextAlignmentLeft];
    comment.frame = CGRectMake(del.right, del.top, 50, del.height);
    [self addSubview:comment];
    
    heart = [BeeUIImageView spawn];
    heart.image = IMAGESTRING(@"heart_red");
    heart.frame = CGRectMake(comment.right -10, 0, 22, 40);
    [self addSubview:heart];
    
    heartCount = [BaseLabel initLabel:@"" font:FONT(14) color:del.textColor textAlignment:NSTextAlignmentLeft];
    heartCount.frame = CGRectMake(heart.right, 0, 35, 40);
    [self addSubview:heartCount];
    
    for (int i = 0; i < 5; i++) {
        
        commentContent[i] = [[MojiFaceView alloc] init];//[BaseLabel initLabel:@"" font:FONT(13) color:content.textColor textAlignment:NSTextAlignmentLeft];
        [self addSubview:commentContent[i]];
    }
    
    allComment = [BaseLabel initLabel:@"查看全部评论" font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:allComment];
}

- (void)load{
    float y = 0;
    float bottom = 0;
    
    if ( [self.dictNote[@"isTeacher"] intValue] == 1) {
        name.textColor = RGB(233, 60, 0);
        name.text = [NSString stringWithFormat:@"%@老师",self.dictNote[@"userNickName"]];
    }else{
        name.text = self.dictNote[@"userNickName"];
        name.textColor = [UIColor blackColor];
    }
    if ([kUserInfo[@"id"] intValue]==[self.dictNote[@"userId"] intValue]){
        name.textColor = RGB(4, 186, 44);
    }

    time.text = [DataUtils getMessageTime:self.dictNote[@"createDate"]];
    [avatar setImageWithURL:self.dictNote[@"userPicUrl"] placeholderImage:nil];
    
    
    
    CGSize szName = [name.text sizeWithFont:name.font byHeight:200];
    name.frame = CGRectMake(avatar.right+10, avatar.top, szName.width, 20);
    time.frame = CGRectMake(name.right+10, name.top+3, 200, 17);

    if ([self.dictNote[@"voiceRecordUrl"] length]>0) {
        content.hidden = YES;

        voiceView.frame = CGRectMake(name.left, name.bottom+10, 300, 32);
        [voiceView loadData:self.dictNote];
        voiceView.hidden = NO;
        
        y = voiceView.bottom;
    }
    else {
        content.hidden = NO;
        content.text = self.dictNote[@"content"];
        CGSize szContent = [content.text sizeWithFont:content.font byWidth:240];
        content.frame = CGRectMake(name.left, name.bottom+5, 240, szContent.height);
        
        voiceView.hidden = YES;
        
        y = content.bottom;
    }
    
    bottom = y;
    
    if ([kUserInfo[@"id"] intValue]==[self.dictNote[@"userId"] intValue]) {
        del.hidden = NO;
        [del makeTappable:ClassDetailBoard.DEL_ALERT withObject:self.dictNote];
    }
    else {
        del.hidden = YES;
    }
    
    for (int i = 0; i < 9; i++) {
        photo[i].hidden = YES;
    }
    
    for (int i = 0; (i < [self.dictNote[@"pics"] count]) && i<9; i++)
    //for (int i = 0; i < [self.dictNote[@"pics"] count]; i++)
    {
        NSMutableDictionary *dictPic = self.dictNote[@"pics"][i];
        photo[i].frame = CGRectMake(photo[i].left, y+10+(i/3)*55, 50, 50);
        photo[i].hidden = NO;
        [photo[i] setImageWithURL:kImage100(dictPic[@"url"]) placeholderImage:IMAGESTRING(@"default_img")];
        [photo[i] makeTappable:ClassDetailCell.PHOTO_FULL withObject:[NSNumber numberWithInt:i]];
        bottom = photo[i].bottom;
    }
    
    
    if ([self.dictNote[@"praiseNum"] integerValue]>0) {
        heartCount.text = self.dictNote[@"praiseNum"];
        heartCount.hidden = NO;
    }
    else {
        heartCount.hidden = YES;
    }
    for (int i = 0; i < 5; i++) {
        commentContent[i].hidden = YES;
    }
    allComment.hidden = YES;
    int commentNum = [self.dictNote[@"commentNum"] intValue];
    if (commentNum>0) {
        comment.text = [NSString stringWithFormat:@"评论%@",self.dictNote[@"commentNum"]];
        int max = 5;
        if (commentNum<=max) {
            max = commentNum;
        }
        for (int i = 0; i < max; i++) {
            NSMutableDictionary *dictComment = self.dictNote[@"comments"][i];
            commentContent[i].hidden = NO;
            
            NSMutableArray *arrayComment  = [[DataUtils sharedInstance] getMessageArray:dictComment[@"content"]];
            [arrayComment insertObject:[NSString stringWithFormat:@"%@:",dictComment[@"commentUserName"]] atIndex:0];
            commentContent[i].frame = CGRectMake(name.left, i==0?(bottom+6):commentContent[i-1].bottom, 240, [dictComment[@"commentHeight"] floatValue]);
            commentContent[i].commentName = [NSString stringWithFormat:@"%@:",dictComment[@"commentUserName"]];
            [commentContent[i] showMessage:arrayComment width:commentContent[i].width];
        }
        
        if (commentNum>5) {
            allComment.hidden = NO;
            allComment.frame = CGRectMake(name.left, commentContent[4].bottom+5, 200, 30);
            [allComment makeTappable:ClassDetailBoard.COMMENT_ALL withObject:self.dictNote];
            [self addSubview:allComment];
        }
    }
    else {
        comment.text = @"评论";
    }
    [comment makeTappable:ClassDetailBoard.COMMENT withObject:self.dictNote];
    
    [heart makeTappable:ClassDetailBoard.LIKE withObject:self.dictNote];
    [heartCount makeTappable:ClassDetailBoard.LIKE withObject:self.dictNote];
}

ON_SIGNAL2(ClassDetailCell, signal){
    if ([signal is:ClassDetailCell.PHOTO_FULL]) {
        int index = [signal.object intValue];
        [self.board showFullImage:self.dictNote[@"pics"] imgV:photo[index] index:index];
    }
}

@end
