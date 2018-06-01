//
//  ChooseFloorBoard.h
//  teacher_iphone
//
//  Created by jyd on 16/6/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "BaseBoard.h"
#import "Bee.h"
@class DictFloor;
@protocol ChooseFloorBoardDeledate <NSObject>
@optional
-(void)didSelectRowWithDictFloor:(DictFloor *)dict;

@end

@interface ChooseFloorBoard : BaseBoard{
    UITableView *tableFloorView;

}
@property (nonatomic,strong)NSArray *floorArray;
@property (nonatomic,strong) DictFloor *floor;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,weak) id<ChooseFloorBoardDeledate> deledate;

@end
