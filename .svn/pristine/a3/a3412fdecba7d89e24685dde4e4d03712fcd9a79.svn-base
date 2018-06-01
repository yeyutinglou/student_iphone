//
//  ClassDetailCell.h
//  ClassRoom
//
//  Created by he chao on 14-6-30.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassDetailBoard;

@interface ClassDetailCell : UITableViewCell{
    AvatarView *avatar;
    MojiFaceView *commentContent[5];
    BaseLabel *name,*time,*content,*del,*comment,*heartCount,*allComment;
    BeeUIImageView *photo[9],*heart;
    VoiceView *voiceView;
}
@property (nonatomic, strong) NSMutableDictionary *dictNote;
@property (nonatomic, strong) ClassDetailBoard *board;

- (void)initSelf;
- (void)load;

AS_SIGNAL(PHOTO_FULL)

@end
