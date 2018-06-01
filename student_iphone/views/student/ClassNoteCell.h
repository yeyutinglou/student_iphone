//
//  ClassNoteCell.h
//  ClassRoom
//
//  Created by he chao on 14-6-26.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudentHomePageBoard;
@class CourseNoteBoard;
@interface ClassNoteCell : UITableViewCell{
    BeeUIImageView *imgLine,*imgBg,*imgHeart,*imgSeperate,*imgDel;
    BaseLabel *lbTitle,*lbContent,*lbTime,*lbComment,*lbLikeCount,*lbDel,*lbNote,*lbNoteOwner;
    BeeUIImageView *photo[9];
    VoiceView *voiceView;
}

@property (nonatomic, strong) NSMutableDictionary *dictNote;
@property (nonatomic, strong) StudentHomePageBoard *board;
@property (nonatomic, strong) CourseNoteBoard *courseNoteBoard;
@property (nonatomic, assign) BOOL isCourseNote;

- (void)initSelf;
- (void)load;

AS_SIGNAL(PHOTO_FULL)
@end
