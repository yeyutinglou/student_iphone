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
//  VerifyBoard.m
//  ClassRoom
//
//  Created by he chao on 7/4/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "VerifyBoard.h"
#import "SignupBoard.h"
#import "LoginBoard.h"
#import "JYDSchoolChooseViewController.h"
#import "ChineseString.h"

#pragma mark -

@interface VerifyBoard()<UIPickerViewDataSource,UIPickerViewDelegate>
{
	//<#@private var#>
    UIView *customPicker;
    UIPickerView *pickView;
    BOOL isSelSchool;
    NSInteger num;
}
AS_SIGNAL(PICKVIEW_CANCEL)
AS_SIGNAL(PICKVIEW_OK)
AS_SIGNAL(PICKVIEW_SHOW)
@end

@implementation VerifyBoard
DEF_SIGNAL(VERIFY)
DEF_SIGNAL(HIDE)
DEF_SIGNAL(PICKVIEW_CANCEL)
DEF_SIGNAL(PICKVIEW_OK)
DEF_SIGNAL(PICKVIEW_SHOW)

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
    //[self showBackBtn];
    self.title = @"身份验证";
    [self loadContent];
    [self getSchoolList];
        //[self createPickerView];
    //[self getAcademyList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schoolDidChange:) name:@"JYDSchoolDidChangeNotification" object:nil];
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
    [self.navigationItem setHidesBackButton:YES];
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

ON_SIGNAL2(VerifyBoard, signal) {
    if ([signal is:VerifyBoard.VERIFY]) {
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",dictSchool[@"schoolServiceURL"],@"app/user/valid_user.action"]].PARAM(@"userType",@"1").PARAM(@"academyId",dictAcademy[@"id"]).PARAM(@"name",field[2].text).PARAM(@"stuNum",field[3].text);
       // request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        request.tag = 9529;
//        SignupBoard *board = [[SignupBoard alloc] init];
//        [self.stack pushBoard:board animated:YES];
        [[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在验证"];
    }
    else if ([signal is:VerifyBoard.PICKVIEW_CANCEL]) {
        [UIView animateWithDuration:0.3 animations:^{
            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewWidth, customPicker.height);
        } completion:^(BOOL finished) {
            customPicker.hidden = YES;
            myTableView.userInteractionEnabled = YES;
        }];
    }
    else if ([signal is:VerifyBoard.PICKVIEW_OK]) {
        [UIView animateWithDuration:0.3 animations:^{
            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewWidth, customPicker.height);
        } completion:^(BOOL finished) {
            customPicker.hidden = YES;
            myTableView.userInteractionEnabled = YES;
        }];
        
        [myTableView reloadData];
    }
    else if ([signal is:VerifyBoard.HIDE]) {
        [field[2] resignFirstResponder];
        [field[3] resignFirstResponder];
    }
    else if ([signal is:VerifyBoard.PICKVIEW_SHOW]) {
//        myTableView.userInteractionEnabled = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            customPicker.hidden = NO;
//            customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-customPicker.height, self.viewWidth, customPicker.height);
//        } completion:^(BOOL finished) {
//            if (isSelSchool) {
//                field[0].text = arraySchools[[pickView selectedRowInComponent:0]][@"schoolName"];
//            }else{
//                field[1].text = arrayAcademy[[pickView selectedRowInComponent:0]][@"name"];
//                dictAcademy = arrayAcademy[0];
//            }
//        }];
//        [pickView reloadAllComponents];
        
        //如果是选择学院
//        if (!isSelSchool) {
//            myTableView.userInteractionEnabled = NO;
//            [UIView animateWithDuration:0.3 animations:^{
//                customPicker.hidden = NO;
//                customPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-customPicker.height, self.viewWidth, customPicker.height);
//            } completion:^(BOOL finished) {
//                    field[1].text = arrayAcademy[[pickView selectedRowInComponent:0]][@"name"];
//                    dictAcademy = arrayAcademy[0];
//            }];
//            [pickView reloadAllComponents];
//            return;
//        }
        
        NSMutableArray *schoolArray = [[NSMutableArray alloc]init];
        
        //选择学院
        if (!isSelSchool) {
            for (int i = 0; i < [arrayAcademy count]; i++) {
                NSDictionary *dic = arrayAcademy[i];
                
                ChineseString *item = [[ChineseString alloc] init];
                item.hanzi = dic[@"name"];
                item.pinyinAllLetter = dic[@"name"];
                item.idStr = dic[@"id"];
                
                
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<item.hanzi.length;j++)
                {
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([item.hanzi characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                item.pinYin=pinYinResult;
                
                [schoolArray addObject:item];
            }
        }
        //选择学校
        else{
            for (int i = 0; i < [arraySchools count]; i++) {
                NSDictionary *dic = arraySchools[i];
                
                ChineseString *item = [[ChineseString alloc] init];
                item.hanzi = dic[@"schoolName"];
                item.pinyinAllLetter = dic[@"schoolName"];
                item.idStr = dic[@"schoolId"];
                
                
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<item.hanzi.length;j++)
                {
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([item.hanzi characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                item.pinYin=pinYinResult;
                
                [schoolArray addObject:item];
            }
        }
        

        NSArray  *sectionIndexTitlesArr = [ChineseString IndexArray:schoolArray];
        NSArray  *sectionArr     = [ChineseString LetterSortArray:schoolArray];
        
        JYDSchoolChooseViewController *vc = [[JYDSchoolChooseViewController alloc]init];
        if (!isSelSchool) {
            vc.title = @"选择学院";
        }else{
            vc.title = @"选择学校";
        }
        vc.schoolArray = schoolArray;
        vc.sectionIndexTitlesArr = sectionIndexTitlesArr;
        vc.sectionArr = sectionArr;
        if (vc.schoolArray.count == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"选学校时需要开启一下手机网络\n完成后即可用教室wifi" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
        }

        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nav animated:YES completion:nil];
    
    }
}

-(void)schoolDidChange:(NSNotification *)notification
{
    ChineseString *schoolStr = notification.userInfo[@"JYDSelectSchool"];
    
    //如果是选择学院
    if (!isSelSchool) {
        field[1].text = schoolStr.hanzi;
        
        for (NSDictionary *dictParam in arrayAcademy) {
            if ([schoolStr.idStr isEqualToString:dictParam[@"id"]]) {
                dictAcademy = dictParam;
                JYDLog(@"选中的学院:%@", dictAcademy);
                break;
            }
        }
    }
    else{
        field[0].text = schoolStr.hanzi;
        field[1].text = @"";
        
        for (NSDictionary *dictParam in arraySchools) {
            if ([schoolStr.idStr isEqualToString:dictParam[@"schoolId"]]) {
                dictSchool = dictParam;
                JYDLog(@"选中的学校:%@", dictSchool);
                [[NSUserDefaults standardUserDefaults] setObject:dictSchool forKey:@"school"];
                //根据学校获取学院列表
                [self getAcademyList];
                break;
            }
        }
    }

}

/**
 *  移除通知
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


ON_SIGNAL2(BeeUIPickerView, signal){
    if ([signal is:BeeUIPickerView.CONFIRMED]) {
        BeeUIPickerView *picker = signal.source;
        int index = [picker selectedRowInColumn:0];
        if (picker.tag==9527) {
            field[0].text = arraySchools[index][@"schoolName"];
            dictSchool = arraySchools[index];
            [[NSUserDefaults standardUserDefaults] setObject:dictSchool forKey:@"school"];
            [self getAcademyList];
        }
        else {
            field[1].text = arrayAcademy[index][@"name"];
            dictAcademy = arrayAcademy[index];
        }
    }
}

- (void)getSchoolList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kBaseUrl,@"app/common/school_list.action"]];
    //request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9527;
}

- (void)getAcademyList{
    BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",dictSchool[@"schoolServiceURL"],@"app/common/get_academy_list.action"]];
    //request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
    request.tag = 9528;
}

- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        NETWORK_ERROR
        //[[BeeUITipsCenter sharedInstance] presentFailureTips:@"加载失败"];
    }
    else if (request.succeed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        JYDLog(@"%@",json);
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                switch (request.tag) {
                    case 9527:
                    {
                        arraySchools = json[@"result"];
                        JYDLog(@"%@",arraySchools[0][@"schoolName"]);
                    }
                        break;
                    case 9528:
                    {
                        arrayAcademy = json[@"result"];
                        JYDLog(@"%@",arrayAcademy);
                    }
                        break;
                    case 9529:
                    {
                        if ([json[@"result"][@"validStatus"] boolValue]) {
                            LoginBoard *board = [[LoginBoard alloc] init];
                            board.dictUser = json[@"result"];
                             board.dictSchool = dictSchool;
                            [self.stack pushBoard:board animated:YES];
                        }
                        else {
                            SignupBoard *board = [[SignupBoard alloc] init];
                            board.dictUser = json[@"result"];
                             board.dictSchool = dictSchool;
                            [self.stack pushBoard:board animated:YES];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                break;
            case 2:
                break;
            case 110:
            {
                //[[LoginBoard sharedInstance] autoLogin];
            }
                break;
            default:
            {
                switch ([json[@"ERRCODE"] intValue]) {
                    case 110:
                    {
                        //[[LoginBoard sharedInstance] autoLogin];
                    }
                        break;
                        
                    default:
                    {
                        [[BeeUITipsCenter sharedInstance] presentFailureTips:json[@"ERRMSG"]];
                    }
                        break;
                }
            }
                break;
        }
    }
}

- (void)loadContent{

    if (IOS6_OR_LATER) {
        [self.view makeTappable:VerifyBoard.HIDE];
    }
    
    NSArray *titles = @[@"学校:",@"院系:",@"姓名:",@"学号:"];
    for (int i = 0; i < 4; i++) {
        BaseLabel *lb = [BaseLabel initLabel:titles[i] font:FONT(14) color:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        lb.frame = CGRectMake(20, 20+45*i, 100, 30);
        [self.view addSubview:lb];
        
        field[i] = [[UITextField alloc] init];
        field[i].tag = i;
        field[i].frame = CGRectMake(75, lb.top, 220, 30);
        field[i].layer.borderColor = [UIColor grayColor].CGColor;
        field[i].leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        field[i].leftViewMode = UITextFieldViewModeAlways;
        field[i].layer.cornerRadius = 3;
        field[i].delegate = self;
        field[i].contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field[i].layer.borderWidth = 0.5;
        [self.view addSubview:field[i]];
        
        if (i<2) {
            field[i].rightViewMode = UITextFieldViewModeAlways;
            BeeUIImageView *right = [BeeUIImageView spawn];
            right.image = IMAGESTRING(@"arrow1");
            right.frame = CGRectMake(0, 0, 30, 30);
            field[i].rightView = right;
        }
        if (i == 2) {
            field[i].returnKeyType = UIReturnKeyNext;
        }
        else if (i == 3) {
            field[i].returnKeyType = UIReturnKeyDone;
        }
    }
//    
//    field[2].text = isTeacher?@"安德烈":@"马静";
//    field[3].text = isTeacher?@"13069526953":@"1405010206";
//    field[2].text = isTeacher?@"安德烈":@"付荧玢";
//    field[3].text = isTeacher?@"13069526953":@"1405010223";
//    field[2].text = isTeacher?@"安德烈":@"包世雄";
//    field[3].text = isTeacher?@"13069526953":@"1405010205";
//    field[2].text = isTeacher?@"安德烈":@"李春华";
//    field[3].text = isTeacher?@"13069526953":@"0403050273";
    
    BaseButton *btnVerify = [BaseButton initBaseBtn:IMAGESTRING(@"btn1") highlight:nil text:@"身份验证" textColor:[UIColor whiteColor] font:FONT(24)];
    btnVerify.frame = CGRectMake(10, 210, 300, 40);
    [btnVerify addSignal:VerifyBoard.VERIFY forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnVerify];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag<2) {
        if (textField.tag==0) {
//            BeeUIPickerView *pickerView = [BeeUIPickerView spawn];
//            pickerView.tag = 9527;
//            for (int i = 0; i < arraySchools.count; i++) {
//                [pickerView addTitle:arraySchools[i][@"schoolName"]];
//            }
//            [pickerView showInViewController:self];
            isSelSchool = YES;
            [pickView reloadAllComponents];
            [self sendUISignal:VerifyBoard.PICKVIEW_SHOW];
        }
        else{
            if (!dictSchool) {
                [BeeUIAlertView showMessage:@"请先选择学校" cancelTitle:@"确定"];
                return NO;
            }
            isSelSchool = NO;
            [pickView reloadAllComponents];
            [self sendUISignal:VerifyBoard.PICKVIEW_SHOW];
            
//            BeeUIPickerView *pickerView = [BeeUIPickerView spawn];
//            pickerView.tag = 9528;
//            for (int i = 0; i < arrayAcademy.count; i++) {
//                [pickerView addTitle:arrayAcademy[i][@"name"]];
//            }
//            [pickerView showInViewController:self];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == field[2]) {
        [field[3] becomeFirstResponder];
    }
    else if (textField == field[3]){
        [field[3] resignFirstResponder];
    }
    return YES;
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
    [btnCancel addSignal:VerifyBoard.PICKVIEW_CANCEL forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:btnCancel];
    
    BaseButton *btnOK = [BaseButton spawn];
    btnOK.frame = CGRectMake(self.viewWidth-60, 0, 60, 44);
    [btnOK setTitle:@"确认" forState:UIControlStateNormal];
    [btnOK setTitleFont:FONT(18)];
    [btnOK setTitleColor:RGB(86, 184, 152) forState:UIControlStateNormal];
    [btnOK addSignal:VerifyBoard.PICKVIEW_OK forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:btnOK];
    
    [customPicker addSubview:toolbar];
    
    BeeUIImageView *line = [BeeUIImageView spawn];
    line.frame = CGRectMake(0, 0, self.viewWidth, 0.5);
    line.backgroundColor = RGB(188, 186, 193);
    [customPicker addSubview:line];
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
    switch (component) {
        case 0:
        {
            if (isSelSchool) {
                return arraySchools.count;
            }
            return arrayAcademy.count;
        }
            
        default:
            break;
    }
    return 0;
}

//此委托方法指定pickerView如何展示数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            if (isSelSchool) {
                return arraySchools[row][@"schoolName"];
            }
        }
            return arrayAcademy[row][@"name"];
            
        default:
            break;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            if (isSelSchool) {
                field[0].text = arraySchools[row][@"schoolName"];
                field[1].text = @"";
                dictSchool = arraySchools[row];
                [[NSUserDefaults standardUserDefaults] setObject:dictSchool forKey:@"school"];
                [self getAcademyList];
            }
            else {
                field[1].text = arrayAcademy[row][@"name"];
                dictAcademy = arrayAcademy[row];
            }
        
//            selProvince = row;
//            selCity = 0;
//            selArea = 0;
//            [pickView selectRow:0 inComponent:1 animated:YES];
//            [pickView selectRow:0 inComponent:2 animated:YES];
//            [pickView reloadAllComponents];
        }
            break;
            
        default:
            break;
    }
}


@end
