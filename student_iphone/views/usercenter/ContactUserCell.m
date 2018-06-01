//
//  ContactUserCell.m
//  ClassRoom
//
//  Created by he chao on 7/15/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "ContactUserCell.h"

@implementation ContactUserCell

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
    icon.frame = CGRectMake(self.width-50, 0, 50, 50);
    [self addSubview:icon];
}
- (void)load{
    [avatar setImageWithURL:kImage100(self.dictContact[@"picUrl"]) placeholderImage:IMAGESTRING(@"default_avatar")];
    name.text = self.dictContact[@"nickName"];
//    if (isTeacher && !self.isSearch) {
//        icon.hidden = YES;
//    }
//    else {
        switch ([self.dictContact[@"friendStatus"] intValue]) {
            case 0:
            {
                icon.image = IMAGESTRING(@"add1");
                icon.hidden = NO;
            }
                break;
            case 1:
            {
                icon.image = IMAGESTRING(@"added");
                icon.hidden = NO;
            }
                break;
            case 2:
            {
                icon.hidden = YES;
            }
                break;
                
            default:
                break;
        }
//    }
    //name.text = self.dictContact[@"nickName"];
    
    //[avatar setImageWithURL:kImage100(self.dictContact[@"picUrl"]) placeholderImage:IMAGESTRING(@"friend_send_reuqest_avatar")];
}

@end
