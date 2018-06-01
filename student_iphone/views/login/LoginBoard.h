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
//  LoginBoard.h
//  ClassRoom
//
//  Created by he chao on 7/5/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface LoginBoard : BaseBoard<UITextFieldDelegate>{
    UITextField *field[2];
}

@property (nonatomic, strong) NSMutableDictionary *dictUser;

//add by zhaojian 2015-08-12
@property (strong, nonatomic) NSMutableDictionary *dictSchool;

AS_SIGNAL(DONE)
AS_SIGNAL(FORGET)
AS_SIGNAL(APPEAL)
@end
