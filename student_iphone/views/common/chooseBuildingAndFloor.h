//
//  chooseBuildingAndFloor.h
//  teacher_iphone
//
//  Created by jyd on 16/6/1.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"

@protocol chooseBuildingAndFloorDeledate <NSObject>
@optional
-(void)sureBtnClickWithClassroomId:(NSString *)classroomId;
@end

@class ChooseViewController;
@class chooseBtn;
@class ChooseFloorBoard;
@class ChooseClassroomBoard;

@interface chooseBuildingAndFloor : BaseBoard<UITextFieldDelegate>
{
    BeeUITextField *field[3];
}
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *buildingLable;
@property (nonatomic,strong) UILabel *floorLable;
@property (nonatomic,strong) UILabel *classroomLable;

@property (nonatomic,strong) BeeUIButton *sureBtn;

@property (nonatomic,strong) chooseBtn *buildingBtn;
@property (nonatomic,strong) chooseBtn *floorBtn;
@property (nonatomic,strong) chooseBtn *classroomBtn;

@property (nonatomic,strong) ChooseViewController *chooseController;
@property (nonatomic,strong) ChooseFloorBoard *chooseFloor;
@property (nonatomic,strong) ChooseClassroomBoard *chooseClass;
@property (nonatomic,copy) NSString *classroomId;

@property (nonatomic,weak) id<chooseBuildingAndFloorDeledate> deledate;

@end
