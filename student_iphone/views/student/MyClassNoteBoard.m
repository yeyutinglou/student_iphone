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
//  MyClassNoteBoard.m
//  ClassRoom
//
//  Created by he chao on 14-6-26.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "MyClassNoteBoard.h"
#import "ClassNoteCell.h"

#pragma mark -

@interface MyClassNoteBoard()
{
	//<#@private var#>
}
@end

@implementation MyClassNoteBoard
DEF_SIGNAL(NAVI_BACK)

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 20)];
        vi.backgroundColor = [UIColor blackColor];
        [self.view addSubview:vi];
    }
    
    self.view.backgroundColor = RGB(242, 242, 242);
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

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL2(MyClassNoteBoard, signal) {
    if ([signal is:MyClassNoteBoard.NAVI_BACK]) {
        [self.stack popBoardAnimated:YES];
    }
}

- (void)loadContent{
    BeeUIImageView *naviBar = [BeeUIImageView spawn];
    naviBar.frame = CGRectMake(0, IOS7_OR_LATER?20:0, self.viewWidth, 44);
    naviBar.image = IMAGESTRING(@"navi_bar2");
    naviBar.userInteractionEnabled = YES;
    [self.view addSubview:naviBar];
    
    BeeUIButton *btnBack = [BeeUIButton spawn];
    btnBack.frame = CGRectMake(0, 0, 44, 44);
    [btnBack setImage:IMAGESTRING(@"navi_back") forState:UIControlStateNormal];
    [btnBack addSignal:MyClassNoteBoard.NAVI_BACK forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:btnBack];
    
    
    BeeUIImageView *imgCover = [BeeUIImageView spawn];
    imgCover.frame = CGRectMake(0, IOS7_OR_LATER?20:0, self.viewWidth, 165);
    imgCover.image = IMAGESTRING(@"demo_icon2");
    //[self.view addSubview:imgCover];
    [self.view insertSubview:imgCover belowSubview:naviBar];
    
    
    AvatarView *avatar = [AvatarView initFrame:CGRectMake(0, 0, 80, 80) image:IMAGESTRING(@"demo_icon3") borderColor:[UIColor whiteColor]];
    avatar.center = CGPointMake(160, 80);
    [imgCover addSubview:avatar];
    
    BaseLabel *name = [BaseLabel initLabel:@"Leon" font:FONT(16) color:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    name.frame = CGRectMake(avatar.right+10, avatar.top, 200, avatar.height);
    [imgCover addSubview:name];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, naviBar.bottom, self.viewWidth, self.viewHeight-naviBar.bottom)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    myTableView.tableHeaderView = imgCover;
    myTableView.tableFooterView = [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[ClassNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell load];
    return cell;
}

@end
