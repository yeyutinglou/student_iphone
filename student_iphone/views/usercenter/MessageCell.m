//
//  MessageCell.m
//  ClassRoom
//
//  Created by he chao on 14-6-25.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

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
    
    imgAvatar = [AvatarView initFrame:CGRectMake(10, 10, 40, 40) image:nil borderColor:[UIColor grayColor]];
    [self addSubview:imgAvatar];
    
    lbName = [BaseLabel initLabel:@"刘德华" font:FONT(18) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lbName.frame = CGRectMake(imgAvatar.right+10, 10, 200, 20);
    [self addSubview:lbName];
    
    lbContent = [BaseLabel initLabel:@"我们成为好友了，开始对话吧！" font:FONT(13) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    lbContent.frame = CGRectMake(imgAvatar.right+10, 35, 200, 20);
    [self addSubview:lbContent];
    
    lbTime = [BaseLabel initLabel:@"今天下午2:00" font:FONT(13) color:RGB(143,143,143) textAlignment:NSTextAlignmentRight];
    lbTime.frame = CGRectMake(0, 13, 310, 15);
    [self addSubview:lbTime];
    
    btnAccept = [BaseButton initBaseBtn:IMAGESTRING(@"friend_accept") highlight:IMAGESTRING(@"friend_accept_selected") text:@"接受" textColor:[UIColor whiteColor] font:FONT(16)];
    btnAccept.hidden = YES;
    btnAccept.frame = CGRectMake(255, 15, 45, 30);
    //    [btnAccept addSignal:FriendBoard.AGREE forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAccept];
    
    imgMark = [BeeUIImageView spawn];
    imgMark.frame = CGRectMake(34, 5, 8, 8);
    imgMark.image = IMAGESTRING(@"friend_new");
    [imgAvatar addSubview:imgMark];
    
    lbBadge = [BeeUILabel spawn];
    lbBadge.frame = CGRectMake(imgAvatar.left+32, imgAvatar.top+4, 12, 12);
    lbBadge.backgroundColor = [UIColor colorWithPatternImage:IMAGESTRING(@"friend_badge")];
    //lbBadge.backgroundImage = IMAGESTRING(@"friend_badge");
    lbBadge.font = FONT(10);
    lbBadge.text = @"9";
    lbBadge.textColor = [UIColor whiteColor];
    [self addSubview:lbBadge];
}

- (void)load{
    btnAccept.hidden = YES;
    lbTime.hidden = NO;
    imgMark.hidden = YES;
    lbBadge.hidden = YES;
    
    [imgAvatar setImageWithURL:kImage100(self.dictMessage[@"sendPic"]) placeholderImage:IMAGESTRING(@"friend_send_reuqest_avatar")];
    //imgAvatar.url = self.dictMessage[@"sendPic"];
    lbName.text = self.dictMessage[@"friendName"];
    lbContent.text = self.dictMessage[@"newMessage"];
    if ([self.dictMessage[@"msgContentType"] intValue]==2) {
        lbContent.text = @"[图片]";
    }
    lbBadge.text = self.dictMessage[@"unReadCount"];
    if ([self.dictMessage[@"unReadCount"] intValue]>0) {
        lbBadge.hidden = NO;
    }
    if (![self.dictMessage[@"sendDate"] isKindOfClass:[NSNull class]]) {
        lbTime.text = [DataUtils getMessageTime:self.dictMessage[@"sendDate"]];
    }
    switch ([self.dictMessage[@"msgType"] intValue]) {
        case -2:
        {
            lbTime.hidden = NO;
            btnAccept.hidden = YES;
        }
            break;
        case 1:
        {
            lbTime.hidden = NO;
            btnAccept.hidden = YES;
        }
            break;
        case 3:
        {
            lbTime.hidden = NO;
            btnAccept.hidden = NO;
            btnAccept.userInteractionEnabled = NO;
            //[btnAccept addSignal:FriendBoard.ACCEPT_REQUEST forControlEvents:UIControlEventTouchUpInside object:self.dictMessage];
        }
            break;
        case 9:
        {
            lbTime.hidden = NO;
            btnAccept.hidden = YES;
            lbContent.text = @"我们成为好友了，开始对话吧!";
        }
            break;
            
        default:
            break;
    }
    btnAccept.hidden = YES;
    
}


@end
