//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  SignupBoard.h
//  ClassRoom
//
//  Created by he chao on 7/5/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface SignupBoard : BaseBoard<UITextFieldDelegate>{
    UITextField *field[4];
    BaseLabel *time;
    int count;
    
    //add by zhaojian 2015-10-08
    BaseButton *btnCode;
}

@property (nonatomic, strong) NSMutableDictionary *dictUser;

//add by zhaojian 2015-08-12
@property (strong, nonatomic) NSMutableDictionary *dictSchool;

AS_SIGNAL(DONE)
AS_SIGNAL(CODE)
AS_SIGNAL(HIDE)
@end
