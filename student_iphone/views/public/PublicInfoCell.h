//
//  PublicInfoCell.h
//  ClassRoom
//
//  Created by he chao on 14-6-22.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicBoard.h"

@interface PublicInfoCell : UITableViewCell{
    AvatarView *avatar;
    MojiFaceView *content,*commentContent[5];
    BaseLabel *labelName,*labelTime,*labelComment,*allComment;
    BeeUIImageView *photo[9];
}
@property (nonatomic, strong) NSMutableDictionary *dictInfo;
@property (nonatomic, strong) PublicBoard *board;

- (void)initSelf;
- (void)load;

AS_SIGNAL(PHOTO_FULL)
@end
