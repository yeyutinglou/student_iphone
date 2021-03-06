//
//  QuestionBoard.m
//  student_iphone
//
//  Created by jyd on 16/3/4.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "QuestionBoard.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
@interface QuestionBoard ()
@property(nonatomic,strong) NSMutableString *answer;
@property(nonatomic,strong) NSMutableArray *answerArray;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,assign)BOOL isCmd;
@property (nonatomic, copy) NSString *lastQuestionCode;
@end

@implementation QuestionBoard

-(void)viewWillDisappear:(BOOL)animated
{
    [self unobserveNotification:@"PPTquestion"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isQuestion = NO;
    [[NSUserDefaults standardUserDefaults] setObject:self.lastQuestionCode forKey:@"questionCode"];
}

ON_NOTIFICATION(notification){
    if ([notification is:@"PPTquestion"]) {
        self.dicQuestion = notification.object;
        NSLog(@"%@",self.lastQuestionCode);
        if ([self.dicQuestion[@"cmd"] isEqualToString:@"1"] ) {
            if (![self.lastQuestionCode isEqualToString:self.dicQuestion[@"questionCode"] ]) {
                [self.view removeAllSubviews];
                [self creatView];
            }
            
        }else{
            self.isCmd = YES;
            [self didSubmit];
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提问";
     self.lastQuestionCode = self.dicQuestion[@"questionCode"];
    if ([self.dicQuestion[@"cmd"] isEqualToString:@"1"]) {
        [self creatView];
    }else{
       
            [self creatView];
            [self didSubmit];
        
    }
//    [self creatView];

}

-(void)creatView{
    self.answer = [[NSMutableString alloc] init];
    self.answerArray = [[NSMutableArray alloc] init];
    //self.answer = @"";
    [self observeNotification:@"PPTquestion"];
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(35, 80, 100, 40)];
    [label setText:@"选择答案:"];
    [self.view addSubview:label];
    NSArray *arr1 = @[@"btnA",@"btnB",@"btnC",@"btnD",@"btnE",@"btnF"];
    NSArray *arr2 = @[@"btnA_select",@"btnB_select",@"btnC_select",@"btnD_select",@"btnE_select",@"btnF_select"];
    int questionNum = [self.dicQuestion[@"questionNum"] integerValue];
    for (int i = 0; i < questionNum; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(135, 80 + i *(40 +20), 40, 40)];;
        [btn setImage:[UIImage imageNamed:arr1[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:arr2[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i +10;
        [self.view addSubview:btn];
    }
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setFrame:CGRectMake((kWidth-257)/2, kHeight -46 -20, 257, 46)];;
    [btnSubmit setImage:[UIImage imageNamed:@"btnSubmit"] forState:UIControlStateNormal];
    
    [btnSubmit addTarget:self action:@selector(didSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    self.btn = btnSubmit;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"pptx"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//    webView.scalesPageToFit = YES;
//    [self.view addSubview:webView];
//    [webView loadRequest:request];
    
}
///选择答案
-(void)didSelect:(UIButton *)btn{
    btn.selected = !btn.selected;
    UIButton *btn1 = [self.view viewWithTag:10];
    UIButton *btn2 = [self.view viewWithTag:11];
    UIButton *btn3 = [self.view viewWithTag:12];
    UIButton *btn4 = [self.view viewWithTag:13];
    UIButton *btn5 = [self.view viewWithTag:14];
    UIButton *btn6 = [self.view viewWithTag:15];
    NSString * questionType = self.dicQuestion[@"questionType"];
    if ([questionType isEqualToString:@"1"]) {
        if (self.answerArray.count > 0) {
            [self.answerArray removeAllObjects];
        }
        switch (btn.tag) {
            case 10:
                if (btn.selected) {
                    btn2.selected = NO;
                    btn3.selected = NO;
                    btn4.selected = NO;
                    btn5.selected = NO;
                    btn6.selected = NO;
                    [self.answerArray addObject:@"A"];
                }
                break;
            case 11:
                if (btn.selected) {
                    btn1.selected = NO;
                    btn3.selected = NO;
                    btn4.selected = NO;
                    btn5.selected = NO;
                    btn6.selected = NO;
                    [self.answerArray addObject:@"B"];
                }
                break;
            case 12:
                if (btn.selected) {
                    btn1.selected = NO;
                    btn2.selected = NO;
                    btn4.selected = NO;
                    btn5.selected = NO;
                    btn6.selected = NO;
                    [self.answerArray addObject:@"C"];
                }
                break;
            case 13:
                if (btn.selected) {
                    btn1.selected = NO;
                    btn2.selected = NO;
                    btn3.selected = NO;
                    btn5.selected = NO;
                    btn6.selected = NO;
                    [self.answerArray addObject:@"D"];
                }
                break;
            case 14:
                if (btn.selected) {
                    btn1.selected = NO;
                    btn2.selected = NO;
                    btn3.selected = NO;
                    btn4.selected = NO;
                    btn6.selected = NO;
                    [self.answerArray addObject:@"E"];
                }
                break;
            case 15:
                if (btn.selected) {
                    btn1.selected = NO;
                    btn2.selected = NO;
                    btn3.selected = NO;
                    btn4.selected = NO;
                    btn5.selected = NO;
                    [self.answerArray addObject:@"F"];
                }
                break;
                default:
                break;
        }
        

    }else{
        switch (btn.tag) {
            case 10:
            {
                if (btn.selected) {
                    [self.answerArray addObject:@"A"];
                }else{
                    [self.answerArray removeObject:@"A"];
                }
            }
                break;
            case 11:
            {
                if (btn.selected) {
                    [self.answerArray addObject:@"B"];
                }else{
                    [self.answerArray removeObject:@"B"];
                }
            }
                break;
            case 12:
            {
                if (btn.selected) {
                    [self.answerArray addObject:@"C"];
                }else{
                    [self.answerArray removeObject:@"C"];
                }
            }
                break;
            case 13:
            {
                if (btn.selected) {
                    [self.answerArray addObject:@"D"];
                }else{
                    [self.answerArray removeObject:@"D"];
                }
            }
                break;
            case 14:
            {
                if (btn.selected) {
                    [self.answerArray addObject:@"E"];
                }else{
                    [self.answerArray removeObject:@"E"];
                }
            }
                break;
            case 15:
            {
                if (btn.selected) {
                    [self.answerArray addObject:@"F"];
                }else{
                    [self.answerArray removeObject:@"F"];
                }
            }
                break;
            default:
                break;
        }
 
    }
    
    NSLog(@"%@",self.answerArray);
    

}



///排序并转化为字符串
-(void)sort:(NSMutableArray *)arr{
    NSArray *array = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    for (NSString *answer in array) {
        if (self.answer.length > 0) {
        [self.answer appendString:@","];
        }
        [self.answer appendString:answer];
    }
   

}
///提交答案
-(void)didSubmit{
//    if ([self.dicQuestion[@"cmd"] isEqualToString:@"1"]) {
//        if (self.btn.selected) {
//            return;
//        }
//    }
//    self.btn.selected = YES;
//    if (self.isCmd) {
//        if (self.btn.enabled) {
//            if (self.answerArray.count > 0) {
//                [self sort:self.answerArray];
//                [self submitStudentAnswer];
//            }else{
//                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"未作答"];
//            }
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
        if (self.answerArray.count > 0) {
            [self sort:self.answerArray];
            
        }else{
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"未作答"];
            self.btn.selected = NO;
        }
             [self submitStudentAnswer];
        //if ([self.dicQuestion[@"cmd"] isEqualToString:@"2"]) {
             [self.navigationController popViewControllerAnimated:YES];
       // }
 //   }
     NSLog(@"%@",self.answer);
    
}

//
-(void)submitStudentAnswer{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:kUserInfo[@"sessionId"] forHTTPHeaderField:@"sessionId"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/question/stu_save_question_temp_answer.action"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"id"] = kUserId;
    param[@"userName"] = kUserInfo[@"nickName"];
    param[@"questionTempCode"] = self.dicQuestion[@"questionCode"];
    param[@"answer"] =self.answer ;
    [manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
           // [[BeeUITipsCenter sharedInstance] presentMessageTips:responseObject[@"result"]];
            [[BeeUITipsCenter sharedInstance] presentMessageTips:@"提交成功"];
             self.btn.enabled = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[BeeUITipsCenter sharedInstance] presentMessageTips:@"提交失败"];
        self.btn.selected = NO;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
