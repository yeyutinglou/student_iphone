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
//  ChangePhoneBoard.h
//  ClassRoom
//
//  Created by he chao on 14-7-17.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface ChangePhoneBoard : BaseBoard<UITextFieldDelegate>{
    BeeUITextField *field[3];
    BaseLabel *time;
    int count;
}

@property (nonatomic, strong) NSMutableDictionary *dictUser;
AS_SIGNAL(DONE)
AS_SIGNAL(CODE)
AS_SIGNAL(HIDE)
@end
