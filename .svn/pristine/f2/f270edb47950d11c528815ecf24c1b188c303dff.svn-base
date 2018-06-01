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
//  PostImage.h
//  Walker
//
//  Created by he chao on 4/9/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "Bee_Model.h"

#pragma mark -

typedef enum {
	PostImageTypeAvatar = 1,
    PostImageTypePublic,
    PostImageTypePublicInfo,
    PostImageTypeNote,
} PostImageType;

@interface PostImage : BeeModel{
    int currentPostIndex;
    NSMutableArray *arrayPicInfo;
}
@property (nonatomic, strong) NSMutableArray *arrayImages;
@property (nonatomic, assign) PostImageType type;
@property (nonatomic, strong) NSMutableDictionary *dictInfo;
@property (nonatomic, strong) id mainCtrl;

- (void)postImages;

@end
