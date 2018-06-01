//
//  PersonalCenterHeadView.h
//  student_iphone
//
//  Created by jyd on 15/8/19.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PersonalCenterDelegate<NSObject>
-(void)lookRankingHistory:(BOOL)isMine;
-(void)goLottery;
-(void)goExchange;
-(void)lookGlodRule;
@end
@interface PersonalCenterHeadView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *ranking;
@property (strong, nonatomic) IBOutlet UILabel *myGold;
@property (strong, nonatomic) IBOutlet UILabel *clubGold;
@property (strong, nonatomic) IBOutlet UILabel *leftLine;
@property (strong, nonatomic) IBOutlet UILabel *rightLine;
@property (strong, nonatomic) IBOutlet UILabel *nameMyGold;
@property (strong, nonatomic) IBOutlet UIButton *btnClubGold;
@property (nonatomic, weak) id <PersonalCenterDelegate> delegate;
@end
