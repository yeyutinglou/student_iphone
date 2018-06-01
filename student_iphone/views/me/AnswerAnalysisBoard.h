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
//  AnswerAnalysisBoard.h
//  student_iphone
//
//  Created by he chao on 15/3/24.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface AnswerAnalysisBoard : BaseBoard

@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString *answerRecordId,*examRecordId;
@end
