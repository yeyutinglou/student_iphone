//
//  StarView.h
//  ClassRoom
//
//  Created by he chao on 8/2/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView{
    BeeUIImageView *star[5];
}

- (void)loadContent:(NSString *)score;

@end
