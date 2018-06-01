//
//  ContactUserCell.h
//  ClassRoom
//
//  Created by he chao on 7/15/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUserCell : UITableViewCell{
    AvatarView *avatar;
    BaseLabel *name;
    BeeUIImageView *icon;
}

@property (nonatomic, strong) NSMutableDictionary *dictContact;
@property (nonatomic, assign) BOOL isSearch;

- (void)initSelf;
- (void)load;

@end
