//
//  ChooseViewController.h
//  teacher_iphone
//
//  Created by jyd on 16/6/2.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
@class DictBuilding;

@protocol ChooseViewControllerDeledate <NSObject>
@optional
-(void)didSelectRowWithDict:(DictBuilding *)dict;

@end

@interface ChooseViewController : BaseBoard {

    UITableView *tableBuildingView;
}
@property (nonatomic,strong)NSArray *buildingArray;
@property (nonatomic,strong) DictBuilding *building;
@property (nonatomic,weak) id<ChooseViewControllerDeledate> deledate;

@end
