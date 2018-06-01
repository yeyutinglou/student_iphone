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
//  ResetPasswordBoard.h
//  Walker
//
//  Created by he chao on 3/12/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface ResetPasswordBoard : BaseBoard{
    BeeUITextField *field[2];
}
@property (nonatomic, strong) NSString *strPhone,*strCode;
AS_SIGNAL(SET)
@end
