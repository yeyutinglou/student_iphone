//
//  ChooseClassroomBoard.h
//  teacher_iphone
//
//  Created by jyd on 16/6/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "BaseBoard.h"
#import "Bee.h"
@class DictClassroom;
@protocol ChooseClassroomBoardDeledate <NSObject>
@optional
-(void)didSelectRowWithDictClass:(DictClassroom *)dict;

@end

@interface ChooseClassroomBoard : BaseBoard{
    UITableView *tableClassroomView;
    
}
@property (nonatomic,strong)NSArray *classroomArray;
@property (nonatomic,strong) DictClassroom *classrom;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,weak) id<ChooseClassroomBoardDeledate> deledate;

@end

