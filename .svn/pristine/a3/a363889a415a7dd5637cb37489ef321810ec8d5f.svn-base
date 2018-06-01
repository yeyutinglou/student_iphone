//
//  StudentCell.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "StudentCell.h"
#import "StudentListBoard.h"

@implementation StudentCell

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
        btn[i] = [BaseButton initBaseBtn:IMAGESTRING(@"add_friend") highlight:IMAGESTRING(@"add_friend_pre")];
        [btn[i] setBackgroundImage:[IMAGESTRING(@"add_friend") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
        [btn[i] setBackgroundImage:[IMAGESTRING(@"add_friend_pre") stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateHighlighted];
        btn[i].frame = CGRectMake(i*320/4.0, 0, 320/4.0, 320/4.0);
        [self addSubview:btn[i]];
        
        avatar[i] = [AvatarView initFrame:CGRectMake(20+btn[i].left, 10, 40, 40) image:IMAGESTRING(@"demo_icon1") borderColor:[UIColor clearColor]];
        [self addSubview:avatar[i]];
        
        name[i] = [BaseLabel initLabel:@"张学友" font:FONT(14) color:RGB(45, 45, 45) textAlignment:NSTextAlignmentCenter];
        [self addSubview:name[i]];
        
        imgStatus[i] = [BeeUIImageView spawn];
        imgStatus[i].image = IMAGESTRING(@"add1");
        [self addSubview:imgStatus[i]];
    }
}

- (void)load{
    for (int i = 0; i < 4; i++) {
//        CGSize sz = [name[i].text sizeWithFont:name[i].font byHeight:16];
//        name[i].frame = CGRectMake(btn[i].left+(80-sz.width)/2.0, avatar[i].bottom, sz.width, 16);
        CGSize sz = [name[i].text sizeWithFont:name[i].font byWidth:80];
        name[i].frame = CGRectMake(btn[i].frame.origin.x, avatar[i].bottom, 80, sz.height);
        imgStatus[i].frame = CGRectMake(avatar[i].right-5, avatar[i].top-5, 18, 18);
        switch (i) {
            case 0:
            {
                [avatar[i] setImageWithURL:kImage100(self.dictUser0[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                name[i].text = self.dictUser0[@"nickName"];
                if ([self.dictUser0[@"friendStatus"] boolValue]) {
                    imgStatus[i].image = IMAGESTRING(@"added");
                    imgStatus[i].userInteractionEnabled = NO;
                }
                else {
                    imgStatus[i].image = IMAGESTRING(@"add1");
                    imgStatus[i].userInteractionEnabled = YES;
                    
                    [imgStatus[i] makeTappable:StudentListBoard.ADD withObject:self.dictUser0];
                }
                [btn[i] addSignal:StudentListBoard.DETAIL forControlEvents:UIControlEventTouchUpInside object:self.dictUser0];
            }
                break;
            case 1:
            {
                if (self.dictUser1) {
                    btn[i].hidden = NO;
                    avatar[i].hidden = NO;
                    imgStatus[i].hidden = NO;
                    name[i].hidden = NO;
                    
                    [avatar[i] setImageWithURL:kImage100(self.dictUser1[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                    name[i].text = self.dictUser1[@"nickName"];
                    if ([self.dictUser1[@"friendStatus"] boolValue]) {
                        imgStatus[i].image = IMAGESTRING(@"added");
                        imgStatus[i].userInteractionEnabled = NO;
                    }
                    else {
                        imgStatus[i].image = IMAGESTRING(@"add1");
                        imgStatus[i].userInteractionEnabled = YES;
                        
                        [imgStatus[i] makeTappable:StudentListBoard.ADD withObject:self.dictUser1];
                    }
                    [btn[i] addSignal:StudentListBoard.DETAIL forControlEvents:UIControlEventTouchUpInside object:self.dictUser1];
                }
                else {
                    btn[i].hidden = YES;
                    avatar[i].hidden = YES;
                    imgStatus[i].hidden = YES;
                    name[i].hidden = YES;
                }
            }
                break;
            case 2:
            {
                if (self.dictUser2) {
                    btn[i].hidden = NO;
                    avatar[i].hidden = NO;
                    imgStatus[i].hidden = NO;
                    name[i].hidden = NO;
                    
                    [avatar[i] setImageWithURL:kImage100(self.dictUser2[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                    name[i].text = self.dictUser2[@"nickName"];
                    if ([self.dictUser2[@"friendStatus"] boolValue]) {
                        imgStatus[i].image = IMAGESTRING(@"added");
                        imgStatus[i].userInteractionEnabled = NO;
                    }
                    else {
                        imgStatus[i].image = IMAGESTRING(@"add1");
                        imgStatus[i].userInteractionEnabled = YES;
                        
                        [imgStatus[i] makeTappable:StudentListBoard.ADD withObject:self.dictUser2];
                    }
                    [btn[i] addSignal:StudentListBoard.DETAIL forControlEvents:UIControlEventTouchUpInside object:self.dictUser2];
                }
                else {
                    btn[i].hidden = YES;
                    avatar[i].hidden = YES;
                    imgStatus[i].hidden = YES;
                    name[i].hidden = YES;
                }
            }
                break;
            case 3:
            {
                if (self.dictUser3) {
                    btn[i].hidden = NO;
                    avatar[i].hidden = NO;
                    imgStatus[i].hidden = NO;
                    name[i].hidden = NO;
                    
                    [avatar[i] setImageWithURL:kImage100(self.dictUser3[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
                    name[i].text = self.dictUser3[@"nickName"];
                    if ([self.dictUser3[@"friendStatus"] boolValue]) {
                        imgStatus[i].image = IMAGESTRING(@"added");
                        imgStatus[i].userInteractionEnabled = NO;
                    }
                    else {
                        imgStatus[i].image = IMAGESTRING(@"add1");
                        imgStatus[i].userInteractionEnabled = YES;
                        
                        [imgStatus[i] makeTappable:StudentListBoard.ADD withObject:self.dictUser3];
                    }
                    [btn[i] addSignal:StudentListBoard.DETAIL forControlEvents:UIControlEventTouchUpInside object:self.dictUser3];
                }
                else {
                    btn[i].hidden = YES;
                    avatar[i].hidden = YES;
                    imgStatus[i].hidden = YES;
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
