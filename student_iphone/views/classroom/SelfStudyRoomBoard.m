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
//  SelfStudyRoomBoard.m
//  student_iphone
//
//  Created by he chao on 14/11/15.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "SelfStudyRoomBoard.h"
#import "SelfStudyRoomCell.h"
#import "ClassRoomMapBoard.h"

#pragma mark -

@interface SelfStudyRoomBoard()<UIPickerViewDataSource,UIPickerViewDelegate>
{
	//<#@private var#>
    __weak IBOutlet UIView *filterView;
    __weak IBOutlet UITableView *myTableView;
    __weak IBOutlet UIButton *btnBegin;
    __weak IBOutlet UIButton *btnEnd;
    NSMutableArray *arrayTime,*arrayClassRoom;
    NSMutableDictionary *dictBeginTime,*dictEndTime;
    
    UIView *customPicker;
    UIPickerView *pickView;
    
    BOOL isBegin;
}
AS_SIGNAL(PICKVIEW_CANCEL)
AS_SIGNAL(PICKVIEW_OK)
AS_SIGNAL(PICKVIEW_SHOW)
AS_SIGNAL(LOCATION)
@end

@implementation SelfStudyRoomBoard
DEF_SIGNAL(PICKVIEW_CANCEL)
DEF_SIGNAL(PICKVIEW_OK)
DEF_SIGNAL(PICKVIEW_SHOW)
DEF_SIGNAL(LOCATION)

- (void)load
{
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    [self showNaviBar];
    [self showBackBtn];
    self.title = @"自习室";
    [self loadContent];
    [self getCourseTime];
    [self createPickerView];
    [btnBegin setTitle:@"请选择" forState:UIControlStateNormal];
    [btnEnd setTitle:@"请选择" forState:UIControlStateNormal];
    
    myTableView.frame = CGRectMake(0, myTableView.top, kWidth, kHeight-myTableView.top-64);
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

ON_SIGNAL2(SelfStudyRoomBoard, signal) {
    if ([signal is:SelfStudyRoomBoard.PICKVIEW_CANCEL]) {
        [UIView animateWithDuration:0.3 animations:^{
            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewWidth, customPicker.height);
        } completion:^(BOOL finished) {
            customPicker.hidden = YES;
            myTableView.userInteractionEnabled = YES;
        }];
    }
    else if ([signal is:SelfStudyRoomBoard.PICKVIEW_OK]) {
        [UIView animateWithDuration:0.3 animations:^{
            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewWidth, customPicker.height);
        } completion:^(BOOL finished) {
            customPicker.hidden = YES;
            myTableView.userInteractionEnabled = YES;
        }];
        
        [myTableView reloadData];
    }
    else if ([signal is:SelfStudyRoomBoard.PICKVIEW_SHOW]) {
        myTableView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            customPicker.hidden = NO;
            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-customPicker.height, self.viewWidth, customPicker.height);
        } completion:^(BOOL finished) {
            
        }];
        [pickView reloadAllComponents];
    }
    else if ([signal is:SelfStudyRoomBoard.LOCATION]){
        ClassRoomMapBoard *board = [[ClassRoomMapBoard alloc] init];
        board.classRoomDict = signal.object;
        [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
    }
}


- (void)createPickerView{
    pickView = [[UIPickerView alloc] init];
    
    customPicker = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewWidth, pickView.height+44)];
    [self.view addSubview:customPicker];
    
    pickView.frame = CGRectMake(0, 44, self.viewWidth, pickView.height);
    pickView.dataSource = self;//委托当前viewController获取数据
    pickView.delegate = self;//委托当前viewController展示数据
    [pickView setShowsSelectionIndicator:YES];
    pickView.tag = 10001;
    pickView.backgroundColor = [UIColor whiteColor];
    [customPicker addSubview:pickView];
    customPicker.hidden = YES;
    
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 44)];
    toolbar.backgroundColor = RGB(245, 245, 245);
    BaseButton *btnCancel = [BaseButton spawn];
    btnCancel.frame = CGRectMake(0, 0, 60, 44);
    [btnCancel setTitleFont:FONT(18)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:RGB(104, 102, 116) forState:UIControlStateNormal];
    [btnCancel addSignal:SelfStudyRoomBoard.PICKVIEW_CANCEL forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:btnCancel];
    
    BaseButton *btnOK = [BaseButton spawn];
    btnOK.frame = CGRectMake(self.viewWidth-60, 0, 60, 44);
    [btnOK setTitle:@"确认" forState:UIControlStateNormal];
    [btnOK setTitleFont:FONT(18)];
    [btnOK setTitleColor:RGB(86, 184, 152) forState:UIControlStateNormal];
    [btnOK addSignal:SelfStudyRoomBoard.PICKVIEW_OK forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:btnOK];
    
    [customPicker addSubview:toolbar];
    
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.frame = CGRectMake(0, 0, self.viewWidth, 0.5);
    line.backgroundColor = RGB(188, 186, 193);
    [customPicker addSubview:line];
}

- (IBAction)touchBeginBtn:(id)sender {
    if (!arrayTime) {
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"正在获取自习室时间表，请稍后"];
        return;
    }
    isBegin = YES;
    [self sendUISignal:SelfStudyRoomBoard.PICKVIEW_SHOW];
}

- (IBAction)touchEndBtn:(id)sender {
    if (!arrayTime) {
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"正在获取自习室时间表，请稍后"];
        return;
    }
    isBegin = NO;
    [self sendUISignal:SelfStudyRoomBoard.PICKVIEW_SHOW];
}

- (IBAction)touchFilterBtn:(id)sender {
    if (!dictBeginTime) {
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请选择开始时间"];
        return;
    }
    if (!dictEndTime) {
        [[BeeUITipsCenter sharedInstance] presentFailureTips:@"请选择结束时间"];
        return;
    }
    
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/studyroom/search_study_room.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"beginNum",dictBeginTime[@"teachTimeCode"]).PARAM(@"endNum",dictEndTime[@"teachTimeCode"]).PARAM(@"dateStr",_strDate);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9528;
}

- (void)loadContent{
}

- (void)getCourseTime{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/common/get_course_time.action"]].PARAM(@"id",kUserInfo[@"id"]);
    request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {

        NETWORK_ERROR
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {

        id json = [request.responseString mutableObjectFromJSONString];
        NSLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                if (request.tag == 9527) {
                    arrayTime = json[@"result"];
                }
                else if (request.tag == 9528) {
                    arrayClassRoom = json[@"result"];
                    [myTableView reloadData];
                }
            }
                break;
            case 1:
            {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:json[@"ERRMSG"]];
            }
                break;
            case 2:
            {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"没有更多查询结果"];
            }
                break;
                
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayClassRoom.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayClassRoom[section][@"classRoomInfo"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *d = arrayClassRoom[indexPath.section][@"classRoomInfo"][indexPath.row];
    CGFloat height = kStrHeight(d[@"freeTime"], kFont(17), kWidth-73-20);//21
    return 66-21+height;
    //return 66;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    [vi addBoard:UIViewBorderTop borderWidth:20 borderColor:HEX_RGB(0xe4e4e4).CGColor];
    [vi addBoard:UIViewBorderBottom borderWidth:0.5 borderColor:HEX_RGB(0xe4e4e4).CGColor];
    vi.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary *dict = arrayClassRoom[section][@"teachBuildInfo"];
    
    BaseLabel *lb = [BaseLabel initLabel:dict[@"teachBuildName"] font:kFont(15) color:[UIColor grayColor] textAlignment:NSTextAlignmentLeft];
    lb.frame = CGRectMake(20, 20, 200, 40);
    [vi addSubview:lb];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(100, 20, 40, 40)];
    icon.contentMode = UIViewContentModeCenter;
    icon.image = IMAGESTRING(@"zuobiao");
    [vi addSubview:icon];
    
    [vi makeTappable:SelfStudyRoomBoard.LOCATION withObject:dict];
    
    return vi;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelfStudyRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelfStudyRoomCell"];
    [cell loadContent:arrayClassRoom[indexPath.section][@"classRoomInfo"][indexPath.row]];
    return cell;
}

#pragma mark - pickerview delegate
//数据源方法 指定pickerView有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//此数据源方法 指定每个表盘有几条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrayTime.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return isBegin?arrayTime[row][@"beginTime"]:arrayTime[row][@"endTime"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (isBegin) {
        dictBeginTime = arrayTime[row];
        [btnBegin setTitle:dictBeginTime[@"beginTime"] forState:UIControlStateNormal];
    }
    else {
        dictEndTime = arrayTime[row];
        [btnEnd setTitle:dictEndTime[@"endTime"] forState:UIControlStateNormal];
    }
}

@end
