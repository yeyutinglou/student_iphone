//
//  PaintViewController.h
//  student_ipad
//
//  Created by nsc on 15/1/18.
//  Copyright (c) 2015年 leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintView.h"
#import "BaseViewController.h"

@interface PaintViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak)  IBOutlet PaintView* paintView;
@property (nonatomic,weak)  IBOutlet UIButton* openBt;
@property (nonatomic,weak)  IBOutlet UIView* backView;
@property (nonatomic,weak)  IBOutlet UIButton* eraseBt;
@property (nonatomic,weak)  IBOutlet UIButton* colorBt;
@property (nonatomic,weak)  IBOutlet UIButton* widthBt;
@property (nonatomic,weak)  IBOutlet UIButton* deleteBt;
//@property (nonatomic,weak) NSString *label;
//@property (nonatomic,assign)int Segment;

@property (nonatomic, strong) NSMutableDictionary *subDic;
@property (nonatomic, strong) NSMutableDictionary *infoDic;

@property (nonatomic, strong) NSString *teamLabel,*stuId;
@property (nonatomic, strong) NSString *label;

- (void)showWhiteBoardDetail:(PaintViewController *)paintVc;
- (void)clearBg;

- (void)initPaitBoard;
//comment by zhaojian
//-(void)myLineFinallyRemove;
@end
