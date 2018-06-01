//
//  FriendContactCell.m
//  ClassRoom
//
//  Created by he chao on 14-6-25.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "FriendContactCell.h"

@implementation FriendContactCell

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
    avatar = [AvatarView initFrame:CGRectMake(10, 5, 40, 40) image:nil borderColor:[UIColor grayColor]];
    [self addSubview:avatar];
    
    name = [BaseLabel initLabel:@"刘德华" font:FONT(18) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    name.frame = CGRectMake(avatar.right+10, 0, 200, 50);
    [self addSubview:name];
    
    icon = [BeeUIImageView spawn];
    icon.frame = CGRectMake(self.width-60, 0, 60, 60);
    [self addSubview:icon];
}

- (void)load{    
    name.text = self.dictContact[@"nickName"];
    
    [avatar setImageWithURL:kImage100(self.dictContact[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
}

@end
