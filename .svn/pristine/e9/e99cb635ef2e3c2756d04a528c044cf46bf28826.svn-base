//
//  chooseBuildingAndFloor.m
//  teacher_iphone
//
//  Created by jyd on 16/6/1.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "chooseBuildingAndFloor.h"
#import "chineseString.h"
#import "chooseBtn.h"
#import "ChooseViewController.h"
#import "DictBuilding.h"
#import "ChooseFloorBoard.h"
#import "DictFloor.h"
#import "ChooseClassroomBoard.h"
#import "DictClassroom.h"
@interface chooseBuildingAndFloor()<ChooseViewControllerDeledate,ChooseFloorBoardDeledate,ChooseClassroomBoardDeledate>
{
    //<#@private var#>
    NSMutableArray *arrayClassrooms;
    NSMutableDictionary *dictClassroom;
    
     NSMutableDictionary *dictSchool;
}
AS_SIGNAL(DONE)
AS_SIGNAL(CHOOSE_BUILDING)
AS_SIGNAL(CHOOSE_FLOOR)
AS_SIGNAL(CHOOSE_CLASSROOM)
@end


@implementation chooseBuildingAndFloor
DEF_SIGNAL(DONE)

DEF_SIGNAL(CHOOSE_BUILDING)
DEF_SIGNAL(CHOOSE_FLOOR)
DEF_SIGNAL(CHOOSE_CLASSROOM)

-(void)load{

}
- (void)unload
{
}
ON_CREATE_VIEWS( signal )
{ self.view.userInteractionEnabled = YES;

    [self loadContent];
    
}
ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
   
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}
ON_SIGNAL2(chooseBuildingAndFloor, signal){
    if ([signal is:chooseBuildingAndFloor.CHOOSE_BUILDING]) {
        if (field[0].text.length != 0) {
            field[0].text = nil;
        }
        if (field[1].text.length != 0) {
            field[1].text  = nil;
        }
        if (field[2].text.length != 0) {
            field[2].text  = nil;
        }
        //显示选择楼宇的tableview
        self.chooseController = [[ChooseViewController alloc] init];
        self.chooseController.deledate = self;
        self.chooseController.view.frame = CGRectMake(30, 30, 200, 200);
        self.chooseController.view.layer.borderWidth = 0.5;
        self.chooseController.view.layer.cornerRadius = 8;
        self.chooseController.view.clipsToBounds = YES;
        [self.view insertSubview:self.chooseController.view aboveSubview:[self.view.subviews lastObject]];
        }

    else if ([signal is:chooseBuildingAndFloor.CHOOSE_FLOOR]){
        if (field[0].text.length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请先选择楼宇" ];
            return;
        }
        if (field[1].text.length != 0) {
            field[1].text  = nil;
        }

        if (field[2].text.length != 0) {
            field[2].text  = nil;
        }
        //显示选择楼层的tableview
        self.chooseFloor = [[ChooseFloorBoard alloc] init];
        self.chooseFloor.deledate = self;
        self.chooseFloor.view.frame = CGRectMake(30, 30, 200, 200);
        self.chooseFloor.view.layer.borderWidth = 0.5;
        self.chooseFloor.view.layer.cornerRadius = 8;
        self.chooseFloor.view.clipsToBounds = YES;
        [self.view insertSubview:self.chooseFloor.view aboveSubview:[self.view.subviews lastObject]];
        
        
    }
    else if ([signal is:chooseBuildingAndFloor.CHOOSE_CLASSROOM]){
        if (field[1].text.length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请先选择楼层" ];
            return ;
        }
        if (field[2].text.length != 0) {
            field[2].text  = nil;
        }

        //显示选择教室的tableview
        self.chooseClass = [[ChooseClassroomBoard alloc] init];
        self.chooseClass.deledate = self;
        self.chooseClass.view.frame = CGRectMake(30, 30, 200, 200);
        self.chooseClass.view.layer.borderWidth = 0.5;
        self.chooseClass.view.layer.cornerRadius = 8;
        self.chooseClass.view.clipsToBounds = YES;
        [self.view insertSubview:self.chooseClass.view aboveSubview:[self.view.subviews lastObject]];

        }
    else if([signal is:chooseBuildingAndFloor.DONE]){
        if (field[2].text.length == 0) {
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"请选择教室" ];
            return ;
        }
        if ([self.deledate respondsToSelector:@selector(sureBtnClickWithClassroomId:)]) {
            [self.deledate sureBtnClickWithClassroomId:self.classroomId];
        }

    }

}
///ChooseViewControllerDeledate的代理方法
-(void)didSelectRowWithDict:(DictBuilding *)dict{
    
    field[0].text = dict.name;
    [self.chooseController.view removeFromSuperview];
  
}
///ChooseFloorBoardDeledate的代理方法
-(void)didSelectRowWithDictFloor:(DictFloor *)dict{
    field[1].text = dict.name;
    [self.chooseFloor.view removeFromSuperview];
    
}
///ChooseClassroomBoardDeledate的代理方法
-(void)didSelectRowWithDictClass:(DictClassroom *)dict{
    field[2].text = dict.name;
    ///拿到教室的ID
    self.classroomId = dict.ID;
    [self.chooseClass.view removeFromSuperview];
    
}
-(void)loadContent{
    
    CGFloat padding = 10;
    CGFloat height = 40;
     CGFloat width = 240;
    NSArray *titles = @[@"  选择楼宇楼层",@"选择楼宇",@"选择楼层",@"选择教室"];
    //创建lable
    self.titleLable =[self setupLableWithTitle:titles[0]];
    self.titleLable.backgroundColor = RGB(236, 236, 236);
    self.titleLable.textColor = RGB(0, 178, 56);
    self.titleLable.frame = CGRectMake(0, 0, self.width, height);
    
    self.buildingLable = [self setupLableWithTitle:titles[1]];
    self.buildingLable.frame = CGRectMake(padding, self.titleLable.bottom+padding, width, height);
    self.floorLable = [self setupLableWithTitle:titles[2]];
    self.classroomLable = [self setupLableWithTitle:titles[3]];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.buildingLable];
    [self.view addSubview:self.floorLable];
    [self.view addSubview:self.classroomLable];
    
    ///创建完成按钮并且添加信号DONE
    self.sureBtn = [BeeUIButton  buttonWithType:UIButtonTypeCustom];
    [self.sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.sureBtn setTitleFont:[UIFont systemFontOfSize:16]];
    [self.sureBtn setTitleColor:RGB(0, 178, 56) forState:UIControlStateNormal];
    self.sureBtn.frame = CGRectMake(width-40, 0, 40, height);
    [self.sureBtn addSignal:chooseBuildingAndFloor.DONE forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureBtn];

    
    //创建文本框
    for (int i = 0; i < 3; i++) {
        field[i] = [BeeUITextField spawn];//[[UITextField alloc] init];
        field[i].backgroundImage = [UIImage imageNamed:@"矩形-37"];
        field[i].layer.borderColor = RGB(192, 202, 205).CGColor;
        field[i].layer.borderWidth = 1;
        field[i].delegate = self;
        field[i].leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        field[i].leftViewMode = UITextFieldViewModeAlways;
        field[i].textColor = [UIColor grayColor];
        field[i].tag = i;
        field[i].font = [UIFont systemFontOfSize:16];
        field[i].rightViewMode = UITextFieldViewModeAlways;
        ///添加选择楼宇按钮
        self.buildingBtn = [chooseBtn buttonWithType:UIButtonTypeCustom];
        self.buildingBtn.frame = CGRectMake(0, 0, 40, 40);
        [self.buildingBtn addSignal:chooseBuildingAndFloor.CHOOSE_BUILDING forControlEvents:UIControlEventTouchUpInside];
        [self.buildingBtn setImage:[UIImage imageNamed:@"形状-1"]];
        field[0].rightView = self.buildingBtn;
        ///添加选择楼层按钮
        self.floorBtn = [chooseBtn buttonWithType:UIButtonTypeCustom];
        self.floorBtn.frame = CGRectMake(0, 0, 40, 40);
        [self.floorBtn addSignal:chooseBuildingAndFloor.CHOOSE_FLOOR forControlEvents:UIControlEventTouchUpInside];
        [self.floorBtn setImage:[UIImage imageNamed:@"形状-1"]];
        field[1].rightView = self.floorBtn;
        ///添加选择教室按钮
        self.classroomBtn = [chooseBtn buttonWithType:UIButtonTypeCustom];
        self.classroomBtn.frame = CGRectMake(0, 0, 40, 40);
        [self.classroomBtn addSignal:chooseBuildingAndFloor.CHOOSE_CLASSROOM forControlEvents:UIControlEventTouchUpInside];
        [self.classroomBtn setImage:[UIImage imageNamed:@"形状-1"]];
        field[2].rightView = self.classroomBtn;
        ///设置文本框的尺寸
        field[0].frame = CGRectMake(self.buildingLable.left, self.buildingLable.bottom, self.buildingLable.width, height);
        self.floorLable.frame = CGRectMake(field[0].left, field[0].bottom+padding,field[0].width,  height);
         field[1].frame = CGRectMake(self.floorLable.left, self.floorLable.bottom, self.buildingLable.width, height);
        
        self.classroomLable.frame = CGRectMake(field[1].left, field[1].bottom+padding,field[1].width,  height);
         field[2].frame = CGRectMake(self.classroomLable.left, self.classroomLable.bottom, self.classroomLable.width, height);
        [self.view addSubview:field[i]];
    }
}
-(UILabel *)setupLableWithTitle:(NSString *)title{
    UILabel *lable = [[UILabel alloc] init];
    lable.text = title;
    lable.textColor = RGB(89, 221, 137);
    lable.font = [UIFont systemFontOfSize:16];
    return lable;
}

///点击文本框不能编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}
@end
