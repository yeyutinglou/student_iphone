//
//  SchoolPublicCell.m
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "SchoolPublicCell.h"
#import "PublishBoard.h"
#import "PublicIntroBoard.h"
#import "CommentListBoard.h"
#import "SchoolPublicView.h"

@implementation SchoolPublicCell



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
    avatar = [AvatarView initFrame:CGRectMake(15, 10, 40, 40) image:IMAGESTRING(@"demo_icon1") borderColor:[UIColor clearColor]];
    [self addSubview:avatar];
    
    title = [BaseLabel initLabel:@"Title" font:FONT(14) color:RGB(60, 60, 60) textAlignment:NSTextAlignmentLeft];
    title.numberOfLines = 0;
    title.frame = CGRectMake(avatar.right+10, avatar.top, 200, 25);
    [self addSubview:title];
    
    description = [BaseLabel initLabel:@"Description" font:FONT(12) color:RGB(173, 173, 173) textAlignment:NSTextAlignmentLeft];
    description.numberOfLines = 0;
    description.frame = CGRectMake(title.left, title.bottom, title.width, 25);
    [self addSubview:description];
    
    labelStatus = [BaseButton initBaseBtn:IMAGESTRING(@"public_publish") highlight:nil];//[BaseLabel initLabel:@"" font:FONT(14) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    labelStatus.frame = CGRectMake(252, 0, 60, 60);
    [self addSubview:labelStatus];
}

- (void)load{
    [avatar setImageWithURL:_dictPublic[@"picUrl"] placeholderImage:IMAGESTRING(@"default_avatar")];
    title.text = self.dictPublic[@"name"];
    description.text = self.dictPublic[@"description"];
    labelStatus.hidden = NO;
    if ([self.dictPublic[@"createUserId"] integerValue]==[kUserInfo[@"id"] integerValue]) {
        labelStatus.backgroundImage = IMAGESTRING(@"public_publish");
        [labelStatus setImage:IMAGESTRING(@"public_publish") forState:UIControlStateNormal];
        [labelStatus addSignal:SchoolPublicView.PUBLISH forControlEvents:UIControlEventTouchUpInside object:self.dictPublic];
    }
    else {
        if ([self.dictPublic[@"inPublicOrgStatus"] boolValue]) {
            [labelStatus setImage:IMAGESTRING(@"public_cancel") forState:UIControlStateNormal];
            [labelStatus addSignal:SchoolPublicView.CANCEL forControlEvents:UIControlEventTouchUpInside object:self.dictPublic];
        }
        else {
            [labelStatus setImage:IMAGESTRING(@"public_attention") forState:UIControlStateNormal];
            [labelStatus addSignal:SchoolPublicView.ATTENTION forControlEvents:UIControlEventTouchUpInside object:self.dictPublic];
        }
        
        if ([_dictPublic[@"publicOrgType"] intValue]==2) {
            labelStatus.hidden = YES;
        }
    }
}

@end
