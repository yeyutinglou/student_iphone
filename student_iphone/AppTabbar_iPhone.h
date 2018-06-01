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
//  AppTabbar_iPhone.h
//  Walker
//
//  Created by he chao on 3/10/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "Bee.h"

//AS_PACKAGE(BeePackage_UI,AppTabbar_iPhone, tabbar)

@interface AppTabbar_iPhone : BeeUICell

//AS_SINGLETON(AppTabbar_iPhone)

- (void)deselectAll;

- (void)selectTab0;
- (void)selectTab1;
- (void)selectTab2;
- (void)selectTab3;
- (void)selectTab4;

@end
