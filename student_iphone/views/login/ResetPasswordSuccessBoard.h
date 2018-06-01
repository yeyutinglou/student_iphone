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
//  ResetPasswordSuccessBoard.h
//  Walker
//
//  Created by he chao on 3/12/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface ResetPasswordSuccessBoard : BaseBoard
@property (nonatomic, strong) NSString *strPhone;
@property (nonatomic, strong) NSString *strPassword;
AS_SIGNAL(LOGIN)
@end
