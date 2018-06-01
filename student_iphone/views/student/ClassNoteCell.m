//
//  ClassNoteCell.m
//  ClassRoom
//
//  Created by he chao on 14-6-26.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "ClassNoteCell.h"
#import "StudentHomePageBoard.h"
#import "CourseNoteBoard.h"

@implementation ClassNoteCell
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
    imgLine = [BeeUIImageView spawn];
    imgLine.frame = CGRectMake(4, 0, 13, 1000);
    imgLine.contentMode = UIViewContentModeScaleToFill;
    imgLine.image = IMAGESTRING(@"list_left_line");
    [self addSubview:imgLine];
    
    imgBg = [BeeUIImageView spawn];
    imgBg.frame = CGRectMake(imgLine.right+2, 10, 293, 210);
    imgBg.contentMode = UIViewContentModeScaleToFill;
    imgBg.image = IMAGESTRING(@"list_content_bg");
    [self addSubview:imgBg];
    
    lbTitle = [BaseLabel initLabel:@"计算机网络工程" font:FONT(16) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lbTitle.frame = CGRectMake(imgBg.left+18, imgBg.top+8, imgBg.width-30, 20);
    [self addSubview:lbTitle];
    
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.backgroundColor = RGB(190, 190, 190);
    line.frame = CGRectMake(imgBg.left+13, lbTitle.bottom+5, 270, 0.5);
    [self addSubview:line];
    
    lbContent = [BaseLabel initLabel:@"各种内容" font:FONT(13) color:RGB(83, 83, 83) textAlignment:NSTextAlignmentLeft];
    lbContent.frame = CGRectMake(lbTitle.left, line.bottom+5, lbTitle.width, 20);
    [self addSubview:lbContent];
    
    imgSeperate = [BeeUIImageView spawn];
    
    imgSeperate.backgroundColor = RGB(190, 190, 190);
    [self addSubview:imgSeperate];
    
    lbTime = [BaseLabel initLabel:@"30分钟前" font:FONT(11) color:RGB(83, 83, 83) textAlignment:NSTextAlignmentLeft];
    [self addSubview:lbTime];
    
    lbComment = [BaseLabel initLabel:@"评论" font:lbTime.font color:RGB(83, 83, 83) textAlignment:NSTextAlignmentLeft];
    [self addSubview:lbComment];
    
    lbNote = [BaseLabel initLabel:@"笔记" font:lbTime.font color:lbTime.textColor textAlignment:NSTextAlignmentLeft];
    [self addSubview:lbNote];
    
    lbNoteOwner = [BaseLabel initLabel:@"张三三" font:lbTime.font color:RGB(28,112,191) textAlignment:NSTextAlignmentRight];
    [self addSubview:lbNoteOwner];
    
    lbDel = [BaseLabel initLabel:@"删除" font:lbTime.font color:RGB(83, 83, 83) textAlignment:NSTextAlignmentLeft];
    [self addSubview:lbDel];
    
    imgHeart = [BeeUIImageView spawn];
    imgHeart.image = IMAGESTRING(@"heart_red");
    [self addSubview:imgHeart];
    
    imgDel = [BeeUIImageView spawn];
    imgDel.image = IMAGESTRING(@"del");
    [self addSubview:imgDel];
    
    lbLikeCount = [BaseLabel initLabel:@"1000" font:lbTime.font color:RGB(83, 83, 83) textAlignment:NSTextAlignmentLeft];
    [self addSubview:lbLikeCount];
    
    for (int i = 0; i < 9; i++) {
        photo[i] = [BeeUIImageView spawn];
        photo[i].frame = CGRectMake(50+(i%3)*55, lbContent.top+30+(i/3)*55, 50, 50);
        photo[i].image = IMAGESTRING(@"demo_icon3");
        photo[i].contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:photo[i]];
    }
    voiceView = [[VoiceView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self addSubview:voiceView];
}

- (void)load{
    lbTitle.text = self.dictNote[@"courseName"];
    
    imgLine.image = [IMAGESTRING(@"list_left_line") stretchableImageWithLeftCapWidth:0 topCapHeight:36];
    imgBg.frame = CGRectMake(imgBg.left,10, 293, [self.dictNote[@"height"] floatValue]-20);
    imgBg.image = [IMAGESTRING(@"list_content_bg") stretchableImageWithLeftCapWidth:0 topCapHeight:26];
    
    lbContent.text = self.dictNote[@"content"];//@"各种内容各种内容各种内容各种内容各种内容各种内容各种内容各种内容各种内容";
    CGSize sz = [lbContent.text sizeWithFont:lbContent.font byWidth:lbContent.width];
    lbContent.frame = CGRectMake(lbContent.left, lbContent.top, lbContent.width, sz.height);
    
    float y = 0;
    
    if ([self.dictNote[@"voiceRecordUrl"] length]>0) {
        lbContent.hidden = YES;
        
        voiceView.frame = CGRectMake(lbContent.left, lbContent.top, 300, 32);
        [voiceView loadData:self.dictNote];
        voiceView.hidden = NO;

        y = voiceView.bottom;
    }
    else {
        lbContent.hidden = NO;
        voiceView.hidden = YES;
        y = lbContent.bottom;
    }
    
    for (int i = 0; i < 9; i++) {
        photo[i].hidden = YES;
    }
    
    for (int i = 0; i < [self.dictNote[@"pics"] count]; i++) {
        NSMutableDictionary *dictPic = self.dictNote[@"pics"][i];
        photo[i].frame = CGRectMake(photo[i].left, y+10+(i/3)*55, 50, 50);
        photo[i].hidden = NO;
        [photo[i] setImageWithURL:kImage100(dictPic[@"url"]) placeholderImage:IMAGESTRING(@"default_img")];
        [photo[i] makeTappable:ClassNoteCell.PHOTO_FULL withObject:[NSNumber numberWithInt:i]];
        
        if (i == [self.dictNote[@"pics"] count]-1) {
            y = photo[i].bottom;
        }
        
    }
    
    imgSeperate.frame = CGRectMake(imgBg.left+13, y+5, 270, 0.5);
    
    lbTime.frame = CGRectMake(lbTitle.left, imgSeperate.bottom, 200, 25);
    lbTime.text = [DataUtils getMessageTime:self.dictNote[@"createDate"]];
    
    lbNote.frame = CGRectMake(120, lbTime.top, 23, lbTime.height);
    lbNoteOwner.frame = CGRectMake(lbNote.left-80, lbTime.top, 80, lbTime.height);
    lbNoteOwner.text = self.dictNote[@"userNickName"];
    
    imgDel.frame = CGRectMake(160, lbTime.top, 11, lbTime.height);
    lbDel.frame = CGRectMake(imgDel.right, imgDel.top, 50, imgDel.height);
    
    lbComment.frame = CGRectMake(205, lbTime.top, 60, lbTime.height);
    lbComment.text = [NSString stringWithFormat:@"评论%@",self.dictNote[@"commentNum"]];
    
    imgHeart.frame = CGRectMake(255, lbTime.top, 20, lbTime.height);
    lbLikeCount.frame = CGRectMake(imgHeart.right, lbTime.top, 200, lbTime.height);
    lbLikeCount.text = self.dictNote[@"praiseNum"];

    if ([self.dictNote[@"userId"] intValue]==[kUserId intValue]) {
        imgDel.hidden = NO;
        lbDel.hidden = NO;
        [imgDel makeTappable:self.isCourseNote?CourseNoteBoard.DEL_NOTE:StudentHomePageBoard.DEL_NOTE withObject:self.dictNote];
        [lbDel makeTappable:self.isCourseNote?CourseNoteBoard.DEL_NOTE:StudentHomePageBoard.DEL_NOTE withObject:self.dictNote];
    }
    else {
        imgDel.hidden = YES;
        lbDel.hidden = YES;
    }
    
    [imgHeart makeTappable:self.isCourseNote?CourseNoteBoard.LIKE_NOTE:StudentHomePageBoard.LIKE_NOTE withObject:self.dictNote];
    [lbLikeCount makeTappable:self.isCourseNote?CourseNoteBoard.LIKE_NOTE:StudentHomePageBoard.LIKE_NOTE withObject:self.dictNote];
    [lbComment makeTappable:self.isCourseNote?CourseNoteBoard.COMMENT:StudentHomePageBoard.COMMENT withObject:self.dictNote];
    
}

ON_SIGNAL2(ClassNoteCell, signal){
    if ([signal is:ClassNoteCell.PHOTO_FULL]) {
        int index = [signal.object intValue];
        if (self.isCourseNote) {
            [self.courseNoteBoard showFullImage:self.dictNote[@"pics"] imgV:photo[index] index:index];
        }
        else {
            [self.board showFullImage:self.dictNote[@"pics"] imgV:photo[index] index:index];
        }
    }
}

@end
