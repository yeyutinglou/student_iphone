//
//  ChatCell.h
//  ClassRoom
//
//  Created by he chao on 14-6-24.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MojiView.h"

@interface ChatCell : UITableViewCell{
    BeeUILabel *lbName,*lbContent,*lbTime,*lbEnterNote;
    AvatarView *imgAvatar,*imgPhoto,*imgContent;
    MojiView *mojiView;
}
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, assign) BOOL isFriendChat;
@property (nonatomic, strong) NSMutableDictionary *dictMessage;

- (void)initSelf;
- (void)load;


@end
