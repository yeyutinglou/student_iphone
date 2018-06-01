//
//  CheckinCell.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "CheckinCell.h"
#import "CheckinBoard.h"

@implementation CheckinCell

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
    for (int i = 0; i < 4; i++) {
        btn[i] = [BeeUIButton spawn];
        btn[i].frame = CGRectMake(i*320/4.0, 0, 320/4.0, 320/4.0);
        [btn[i] setBackgroundImage:[IMAGESTRING(@"uncheckin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
        [self addSubview:btn[i]];
        
        avatar[i] = [AvatarView initFrame:CGRectMake(20+btn[i].left, 10, 40, 40) image:IMAGESTRING(@"demo_icon1") borderColor:[UIColor clearColor]];
        [self addSubview:avatar[i]];
        
        name[i] = [BaseLabel initLabel:@"张学友" font:FONT(13) color:RGB(45, 45, 45) textAlignment:NSTextAlignmentCenter];
        [self addSubview:name[i]];
        
        imgCheck[i] = [BeeUIImageView spawn];
        imgCheck[i].image = IMAGESTRING(@"check");
        [self addSubview:imgCheck[i]];
    }
}

- (void)load{
    for (int i = 0; i < 4; i++) {
        CGSize sz = [name[i].text sizeWithFont:name[i].font byHeight:16];
        name[i].frame = CGRectMake(btn[i].left+(80-sz.width -5)/2.0, avatar[i].bottom, sz.width +10, 16);
        imgCheck[i].frame = CGRectMake(name[i].right, name[i].top, 11, name[i].height);
        switch (i) {
            case 0:
            {
                [avatar[i] setImageWithURL:kImage100(self.dictUser0[@"stuPicUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                name[i].text = self.dictUser0[@"stuName"];
                if ([self.dictUser0[@"signStatus"] boolValue]) {
                    imgCheck[i].hidden = NO;
                    [btn[i] setBackgroundImage:[IMAGESTRING(@"checkin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
                }
                else {
                    imgCheck[i].hidden = YES;
                    [btn[i] setBackgroundImage:[IMAGESTRING(@"uncheckin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
                }
                [btn[i] addSignal:CheckinBoard.CHECK_IN forControlEvents:UIControlEventTouchUpInside object:self.dictUser0];
                //[btn[i] addSignal:StudentListBoard.DETAIL forControlEvents:UIControlEventTouchUpInside object:self.dictUser0];
            }
                break;
            case 1:
            {
                if (self.dictUser1) {
                    btn[i].hidden = NO;
                    avatar[i].hidden = NO;
                    name[i].hidden = NO;
                    
                    [avatar[i] setImageWithURL:kImage100(self.dictUser1[@"stuPicUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                    name[i].text = self.dictUser1[@"stuName"];
                    if ([self.dictUser1[@"signStatus"] boolValue]) {
                        imgCheck[i].hidden = NO;
                        [btn[i] setBackgroundImage:[IMAGESTRING(@"checkin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
                    }
                    else {
                        imgCheck[i].hidden = YES;
                        [btn[i] setBackgroundImage:[IMAGESTRING(@"uncheckin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
                    }
                    [btn[i] addSignal:CheckinBoard.CHECK_IN forControlEvents:UIControlEventTouchUpInside object:self.dictUser1];
                    //[btn[i] addSignal:StudentListBoard.DETAIL forControlEvents:UIControlEventTouchUpInside object:self.dictUser1];
                }
                else {
                    btn[i].hidden = YES;
                    avatar[i].hidden = YES;
                    imgCheck[i].hidden = YES;
                    name[i].hidden = YES;
                }
            }
                break;
            case 2:
            {
                if (self.dictUser2) {
                    btn[i].hidden = NO;
                    avatar[i].hidden = NO;
                    name[i].hidden = NO;
                    
                    [avatar[i] setImageWithURL:kImage100(self.dictUser2[@"stuPicUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                    name[i].text = self.dictUser2[@"stuName"];
                    if ([self.dictUser2[@"signStatus"] boolValue]) {
                        imgCheck[i].hidden = NO;
                        [btn[i] setBackgroundImage:[IMAGESTRING(@"checkin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
                    }
                    else {
                        imgCheck[i].hidden = YES;
                        [btn[i] setBackgroundImage:[IMAGESTRING(@"uncheckin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
                    }
                    [btn[i] addSignal:CheckinBoard.CHECK_IN forControlEvents:UIControlEventTouchUpInside object:self.dictUser2];
                    //[btn[i] addSignal:StudentListBoard.DETAIL forControlEvents:UIControlEventTouchUpInside object:self.dictUser2];
                }
                else {
                    btn[i].hidden = YES;
                    avatar[i].hidden = YES;
                    imgCheck[i].hidden = YES;
                    name[i].hidden = YES;
                }
            }
                break;
            case 3:
            {
                if (self.dictUser3) {
                    btn[i].hidden = NO;
                    avatar[i].hidden = NO;
                    name[i].hidden = NO;
                    
                    [avatar[i] setImageWithURL:kImage100(self.dictUser3[@"stuPicUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                    name[i].text = self.dictUser3[@"stuName"];
                    if ([self.dictUser3[@"signStatus"] boolValue]) {
                        imgCheck[i].hidden = NO;
                        [btn[i] setBackgroundImage:[IMAGESTRING(@"checkin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
                    }
                    else {
                        imgCheck[i].hidden = YES;
                        [btn[i] setBackgroundImage:[IMAGESTRING(@"uncheckin_bg") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
                    }
                    [btn[i] addSignal:CheckinBoard.CHECK_IN forControlEvents:UIControlEventTouchUpInside object:self.dictUser3];
                    //[btn[i] addSignal:StudentListBoard.DETAIL forControlEvents:UIControlEventTouchUpInside object:self.dictUser3];
                }
                else {
                    btn[i].hidden = YES;
                    avatar[i].hidden = YES;
                    imgCheck[i].hidden = YES;
                    name[i].hidden = YES;
                }
            }
                break;
                
            default:
                break;
        }
    }

}

@end
