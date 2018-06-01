//
//  CurriculumCell.m
//  ClassRoom
//
//  Created by he chao on 6/27/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "MyClassCell.h"
#import "MyClassBoard.h"

@implementation MyClassCell

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
    [self.contentView addSubview:imgLine];
    
    imgBg = [BeeUIImageView spawn];
    imgBg.frame = CGRectMake(imgLine.right+2, 10, 293, 69);
    imgBg.contentMode = UIViewContentModeScaleToFill;
    imgBg.image = IMAGESTRING(@"list_content_bg");
    [self.contentView addSubview:imgBg];
    
    lbTitle = [BaseLabel initLabel:@"计算机网络工程" font:FONT(17) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lbTitle.frame = CGRectMake(imgBg.left+18, imgBg.top+8, imgBg.width-30, 25);
    [self.contentView addSubview:lbTitle];
    
    imgTime = [BeeUIImageView spawn];
    imgTime.frame = CGRectMake(lbTitle.left, lbTitle.bottom, 17, 30);
    imgTime.image = IMAGESTRING(@"time");
    [self.contentView addSubview:imgTime];
    
    lbTime = [BaseLabel initLabel:@"2013.12-2014.6" font:FONT(14) color:RGB(40, 40, 40) textAlignment:NSTextAlignmentLeft];
    lbTime.frame = CGRectMake(imgTime.right+5, imgTime.top, 200, imgTime.height);
    [self.contentView addSubview:lbTime];
    
    lbCount = [BaseLabel initLabel:@"共15节" font:FONT(14) color:lbTime.textColor textAlignment:NSTextAlignmentRight];
    lbCount.frame = CGRectMake(imgBg.right-10-100, lbTime.top, 100, lbTime.height);
    [self.contentView addSubview:lbCount];
    
    imgMine = [BeeUIImageView spawn];
    imgMine.frame = CGRectMake(imgBg.right-49, imgBg.top, 47, 26);
    imgMine.image = IMAGESTRING(@"mine");
    [self.contentView addSubview:imgMine];
}

- (void)load{
    imgLine.image = [IMAGESTRING(@"list_left_line") stretchableImageWithLeftCapWidth:0 topCapHeight:36];
    lbTitle.text = self.dictCurriculum[@"courseName"];
    lbTime.text = [NSString stringWithFormat:@"%@~%@",[DataUtils getFormatTime:self.dictCurriculum[@"beginDate"]],[DataUtils getFormatTime:self.dictCurriculum[@"endDate"]]];
    lbCount.text = [NSString stringWithFormat:@"共%@节",self.dictCurriculum[@"courseCharacters"]];
    
    for (UIView *view in self.contentView.subviews) {
        if (view.tag == 9527) {
            [view removeFromSuperview];
        }
    }
    if (self.isSelected) {
        imgBg.frame = CGRectMake(imgLine.right+2, 10, 293, 69+50*[self.dictCurriculum[@"courseChar"] count]);
//        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(imgBg.left+14, imgBg.top+69, imgBg.width-24, 230-69-10)];
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(imgBg.left+14, imgBg.top+69, imgBg.width-24, 69+50*[self.dictCurriculum[@"courseChar"] count])];
        [self loadCurriculumList:vi];
        vi.tag = 9527;
        [self.contentView addSubview:vi];
    }
    else {
        imgBg.frame = CGRectMake(imgLine.right+2, 10, 293, 69);
    }
    imgBg.image = [IMAGESTRING(@"list_content_bg") stretchableImageWithLeftCapWidth:0 topCapHeight:26];
    
    imgMine.hidden = YES;
//    if (!isTeacher) {
        if ([self.dictCurriculum[@"isMyCourse"] boolValue]) {
            imgMine.hidden = NO;
        }
//    }
}

- (void)loadCurriculumList:(UIView *)vi{
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.frame = CGRectMake(0, 0, vi.width, 1);
    line.backgroundColor = RGB(59, 164, 40);
    [vi addSubview:line];
    
    int count = [self.dictCurriculum[@"courseChar"] count];
    for (int i = 0; i < count; i++) {
        NSDictionary *dictSelCourse = self.dictCurriculum[@"courseChar"][i];
        BaseLabel *lbIndex = [BaseLabel initLabel:[NSString stringWithFormat:@"%@ %@ 第%@节",[dictSelCourse[@"teachTime"] substringFromIndex:5],dictSelCourse[@"weekDay"],dictSelCourse[@"orderNumChar"]] font:FONT(14) color:lbTime.textColor textAlignment:NSTextAlignmentLeft];
        lbIndex.frame = CGRectMake(4, 50*i, 200, 50);
        [vi addSubview:lbIndex];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:lbIndex.text];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(0, 175, 247) range:NSMakeRange(6, 2)];
        lbIndex.attributedText = str;
        
        BeeUIButton *btnPlay = [BeeUIButton spawn];
        [btnPlay setImage:IMAGESTRING(@"btn_play") forState:UIControlStateNormal];
        btnPlay.frame = CGRectMake(vi.width - 100, 50*i +5, 25, 25);
        [btnPlay addSignal:MyClassBoard.PLAY forControlEvents:UIControlEventTouchUpInside object:self.dictCurriculum[@"courseChar"][i]];
        [vi addSubview:btnPlay];
        
        BaseLabel *playLabel = [BaseLabel initLabel:@"视频" font:FONT(14) color:lbTime.textColor textAlignment:NSTextAlignmentLeft];
        playLabel.frame = CGRectMake(btnPlay.x, 50 * i +25, 50, 25);
        [vi addSubview:playLabel];
        
        BeeUIButton *btnDown = [BeeUIButton spawn];
        btnDown.frame = CGRectMake(btnPlay.right+30, 50*i + 5, 25, 25);
        [btnDown setImage:IMAGESTRING(@"btn_download") forState:UIControlStateNormal];
        [btnDown addSignal:MyClassBoard.DOWNLOAD forControlEvents:UIControlEventTouchUpInside object:self.dictCurriculum[@"courseChar"][i]];
        [vi addSubview:btnDown];
        
        BaseLabel *downloadLabel = [BaseLabel initLabel:@"课件" font:FONT(14) color:lbTime.textColor textAlignment:NSTextAlignmentLeft];
        downloadLabel.frame = CGRectMake(btnDown.x, 50 * i +25, 50, 25);
        [vi addSubview:downloadLabel];
        
        if (i < count-1) {
            BeeUIImageView *line = [BeeUIImageView spawn];
            line.frame = CGRectMake(45, 50+50*i, vi.width-45, 0.5);
            line.backgroundColor = RGB(219, 219, 219);
            [vi addSubview:line];
        }
    }
}

@end
