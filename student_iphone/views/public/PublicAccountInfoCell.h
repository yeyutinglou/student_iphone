//
//  PublicAccountInfoCell.h
//  ClassRoom
//
//  Created by he chao on 6/23/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicAccountInfoListBoard;

@interface PublicAccountInfoCell : UITableViewCell{
    BaseLabel *labelName,*labelTime,*labelContent,*labelComment,*allComment;
    BeeUIImageView *imgPhoto[9];
    MojiFaceView *content,*commentContent[5];
    BeeUIImageView *photo[9];
}
@property (nonatomic, strong) NSMutableDictionary *dictInfo;
@property (nonatomic, strong) PublicAccountInfoListBoard *board;

AS_SIGNAL(PHOTO_FULL)

- (void)initSelf;
- (void)load;
@end
