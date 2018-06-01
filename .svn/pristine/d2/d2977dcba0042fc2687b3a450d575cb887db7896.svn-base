//
//  CommentCell.m
//  ClassRoom
//
//  Created by he chao on 6/24/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "CommentCell.h"
#import "CommentListBoard.h"

@implementation CommentCell

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
    
    comment = [[MojiFaceView alloc] init];
    [self addSubview:comment];
    
    time = [BaseLabel initLabel:@"" font:FONT(13) color:RGB(102, 102, 102) textAlignment:NSTextAlignmentLeft];
    [self addSubview:time];
    
    _delete = [BaseLabel initLabel:@"删除" font:FONT(13) color:time.textColor textAlignment:NSTextAlignmentCenter];
    [self addSubview:_delete];
}

- (void)load{
    NSString *avatarUrl = self.type==1?self.dictComment[@"commentUserPicUrl"]:self.dictComment[@"userPicUrl"];
    [avatar setImageWithURL:kImage100(avatarUrl) placeholderImage:IMAGESTRING(@"default_avatar")];
    comment.frame = CGRectMake(avatar.right+10, avatar.top, 240, [self.dictComment[@"commentHeight"] floatValue]);
    NSMutableArray *arrayComment  = [[DataUtils sharedInstance] getMessageArray:self.dictComment[@"content"]];
    NSString *strName = [NSString stringWithFormat:@"%@:",self.type==1?self.dictComment[@"commentUserName"]:self.dictComment[@"userNickName"]];
    [arrayComment insertObject:strName atIndex:0];
    comment.commentName = strName;
    [comment showMessage:arrayComment width:240];
    
    time.frame = CGRectMake(comment.left, comment.bottom, 200, 20);
    time.text = [DataUtils getMessageTime:self.dictComment[@"createDate"]];
    
    _delete.frame = CGRectMake(260, time.top, 60, time.height);
    _delete.hidden = YES;
    NSString *strUid = self.type==1?self.dictComment[@"commentUserId"]:self.dictComment[@"userId"];
    if ([strUid intValue]==[kUserInfo[@"id"] intValue]) {
        _delete.hidden = NO;
        [_delete makeTappable:CommentListBoard.ALERT withObject:self.dictComment];
    }
}

@end
