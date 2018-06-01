//
//  ChatCell.m
//  ClassRoom
//
//  Created by he chao on 14-6-24.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "ChatCell.h"


@implementation ChatCell

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
    lbEnterNote = [BeeUILabel spawn];
    lbEnterNote.font = FONT(12);
    lbEnterNote.textColor = [UIColor whiteColor];
    lbEnterNote.backgroundColor = RGB(206, 206, 206);
    lbEnterNote.layer.cornerRadius = 2;
    lbEnterNote.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lbEnterNote];
    
    lbTime = [BeeUILabel spawn];
    lbTime.frame = CGRectMake(90, 5, 140, 20);
    lbTime.font = FONT(12);
    lbTime.textColor = [UIColor blackColor];
    lbTime.backgroundColor = RGB(206, 206, 206);//[UIColor lightGrayColor];
    lbTime.layer.cornerRadius = 5;
    lbTime.textAlignment = NSTextAlignmentCenter;
    lbTime.text = @"Kings of Leon";
    [self addSubview:lbTime];
    
    imgAvatar = [AvatarView initFrame:CGRectMake(10, 10, 40, 40) image:nil borderColor:[UIColor grayColor]];//[BeeUIImageView spawn];
    imgAvatar.contentMode = UIViewContentModeScaleToFill;
    imgAvatar.frame = CGRectMake(10, 10, 40, 40);
    imgAvatar.image = IMAGESTRING(@"friend_avatar_bg");
    imgAvatar.clipsToBounds = YES;
    [self addSubview:imgAvatar];
    
    lbName = [BeeUILabel spawn];
    lbName.frame = CGRectMake(imgAvatar.right+3, 5, 200, 20);
    lbName.font = FONT(14);
    lbName.textColor = [UIColor blackColor];
    lbName.textAlignment = NSTextAlignmentLeft;
    lbName.text = @"Kings of Leon";
    [self addSubview:lbName];
    
    imgContent = [BeeUIImageView spawn];
    imgContent.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:imgContent];
    
    mojiView = [[MojiView alloc] init];
    //[mojiView setContent:@"hello [生气] this [哼哼] is [哎呀] Leon!!!"];
    mojiView.frame = CGRectMake(0, 0, mojiView.width, mojiView.height);
    [imgContent addSubview:mojiView];
    
    imgPhoto = [BeeUIImageView spawn];
    imgPhoto.frame = CGRectMake(15, 10, 70, 70);
    imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [imgContent addSubview:imgPhoto];
    /*
     NSString *strTitle = @"hello [生气] this [哼哼] is [哎呀] Leon!!!";
     lbContent = [BeeUILabel spawn];
     lbContent.frame = CGRectMake(lbName.left, lbName.bottom, 220, 20);
     lbContent.numberOfLines = 0;
     lbContent.textColor = [UIColor blackColor];
     lbContent.font = FONT(16);
     lbContent.textAlignment = NSTextAlignmentLeft;
     lbContent.text = strTitle;
     [self addSubview:lbContent];
     
     CGSize sz = [lbContent.text sizeWithFont:lbContent.font byWidth:lbContent.width];
     lbContent.frame = CGRectMake(lbContent.left, lbContent.top, sz.width+40, sz.height+20);
     lbContent.backgroundColor = [UIColor colorWithPatternImage:[IMAGESTRING(@"chat_other_bg") stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
     lbContent.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
     lbContent.backgroundImage = [IMAGESTRING(@"chat_other_bg") stretchableImageWithLeftCapWidth:10 topCapHeight:10];*/
}

- (void)load{
    
    int isMe = [self.dictMessage[@"sendUserId"] intValue]==[kUserInfo[@"id"] intValue];//rand()%2;
    BOOL isShowTime = [self.dictMessage[@"showTime"] boolValue];
    
    for (id element in mojiView.subviews) {
        [element removeFromSuperview];
    }
    [mojiView setContent:self.dictMessage[@"content"] maxWidth:150];
    [imgAvatar setImageWithURL:kImage100(self.dictMessage[@"sendUserPic"]) placeholderImage:IMAGESTRING(@"loading100")];
 
    lbName.text = self.dictMessage[@"sendUserName"];
    if (isShowTime) {
        lbTime.hidden = NO;
        lbTime.text = [DataUtils getChatTime:self.dictMessage[@"sendDate"]];
    }
    else {
        lbTime.hidden = YES;
    }

    
    if (isMe) {
        lbName.hidden = YES;
        imgAvatar.frame = CGRectMake(270, 10+(isShowTime?30:0), 40, 40);
        lbName.frame = CGRectMake(imgAvatar.right+3, 5+(isShowTime?30:0), 200, 20);
        imgContent.frame = CGRectMake(lbName.left+25, lbName.bottom-5, mojiView.width+35, mojiView.height+20);
        imgContent.image = [IMAGESTRING(@"chat_me_bg") stretchableImageWithLeftCapWidth:10 topCapHeight:15];
        mojiView.frame = CGRectMake(10, 10, mojiView.width, mojiView.height);
        
        imgContent.frame = CGRectMake(imgAvatar.left-3-imgContent.width, imgContent.top, imgContent.width, imgContent.height);
    }
    else {
        lbName.hidden = NO;
        if (self.isFriendChat) {
            lbName.hidden = YES;
        }
        imgAvatar.frame = CGRectMake(10, 10+(isShowTime?30:0), 40, 40);
        lbName.frame = CGRectMake(imgAvatar.right+3, 5+(isShowTime?30:0), 200, 20);
        imgContent.frame = CGRectMake(lbName.left, lbName.bottom, mojiView.width+35, mojiView.height+20);
        imgContent.image = [IMAGESTRING(@"chat_other_bg") stretchableImageWithLeftCapWidth:10 topCapHeight:15];
        mojiView.frame = CGRectMake(20, 10, mojiView.width, mojiView.height);
    }
    
    lbEnterNote.hidden = YES;
    imgAvatar.hidden = NO;
    imgContent.hidden = NO;
    switch ([self.dictMessage[@"contentType"] intValue]) {
        case 1:
        {
            mojiView.hidden = NO;
            imgPhoto.hidden = YES;
        }
            break;
        case 2:
        {
            mojiView.hidden = YES;
            imgPhoto.hidden = NO;
            imgContent.userInteractionEnabled = YES;
            [imgPhoto setImageWithURL:kImage100(self.dictMessage[@"content"]) placeholderImage:IMAGESTRING(@"loading100")];
            [imgPhoto makeTappable:ChatBoard.PHOTO_FULL withObject:self.dictMessage[@"content"]];
            
            imgContent.frame = CGRectMake(imgContent.left, imgContent.top, imgContent.width, 90);
            if (isMe) {
                imgContent.frame = CGRectMake(imgContent.right-110, imgContent.top, 110, 90);
                imgPhoto.frame = CGRectMake(15, 10, 70, 70);
            }
            else {
                imgContent.frame = CGRectMake(imgContent.left, imgContent.top, 110, 90);
                imgPhoto.frame = CGRectMake(20, 10, 70, 70);
            }
        }
            break;
        case 3:
        {
            //NSString *strContent = @"aldflkdsklf 加入群了";
            CGSize sz = [self.dictMessage[@"content"] sizeWithFont:lbEnterNote.font byHeight:20];
            lbEnterNote.text = self.dictMessage[@"content"];
            float width = sz.width+40;
            lbEnterNote.frame = CGRectMake((320-width)/2.0, 2+(lbTime.hidden?0:lbTime.bottom), width, 20);
            
            lbEnterNote.hidden = NO;
            //lbTime.hidden = YES;
            lbName.hidden = YES;
            lbContent.hidden = YES;
            imgAvatar.hidden = YES;
            imgContent.hidden = YES;
            imgPhoto.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    [imgContent addSubview:mojiView];
}


@end
