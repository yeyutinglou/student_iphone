//
//  RankingHeadView.h
//  student_iphone
//
//  Created by jyd on 15/8/19.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RankingHeadDelegate <NSObject>
-(void)howAcquireMoreGlod;
@end
@interface RankingHeadView : UIView
@property (strong, nonatomic) IBOutlet UILabel *goldLabel;
@property (strong, nonatomic) IBOutlet UILabel *nowSortLabel;
@property (strong, nonatomic) IBOutlet UILabel *hisSortLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameGoldLabel;
@property (nonatomic, weak) id<RankingHeadDelegate> delegate;
@end
