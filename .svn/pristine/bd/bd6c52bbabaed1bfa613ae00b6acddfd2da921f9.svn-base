//
//  PersonalCenterViewController.m
//  student_iphone
//
//  Created by jyd on 15/8/19.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterCell.h"
#import "PersonalCenterHeadView.h"
#import "RankingViewController.h"
#import "CreditWebViewController.h"
#import "GlodRuleViewController.h"
@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate,PersonalCenterDelegate>
{
    PersonalCenterHeadView *headView;
    UITableView *personalTableView;
    NSMutableArray *dataArray;
    NSDictionary *dataDic;
    NSString *hasPub;
}

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    
    [self showNaviBar];
    [self loadTableView];
    [self loadHeadView];
    [self loadUserInfoIntegral];
    [self loadPersonalIntergralList];
    
}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//   headView.nameMyGold.frame = CGRectMake(10, 10, 71, 40);
//    
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)showNaviBar
{
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
//    [[UINavigationBar appearance] setBackgroundImage:IMAGESTRING(@"navi_bg") forBarMetrics:UIBarMetricsDefault];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal] ;
   btn.frame = (CGRect){CGPointZero, btn.currentBackgroundImage.size};
    [btn addTarget:self action:@selector(didBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)didBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadHeadView{
    headView = [[[NSBundle mainBundle] loadNibNamed:@"PersonalCenterHeadView" owner:nil options:nil] lastObject];
    headView.delegate = self;
    headView.avatar.layer.masksToBounds = YES;
    headView.avatar.layer.cornerRadius = headView.avatar.frame.size.height/2;
    personalTableView.tableHeaderView = headView;
}

-(void)loadTableView{
    personalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64 ) style:UITableViewStylePlain];
    personalTableView.dataSource = self;
    personalTableView.delegate = self;
    [self.view addSubview:personalTableView];
}
-(void)loadPersonalIntergralList{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"id"] = kUserId;
    parms[@"userType"] = @"1";
    NSString *urlString = [NSString stringWithFormat:@"%@app/integral/get_integral_by_type.action",kSchoolUrl];
    [manager GET:urlString parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
            dataArray = responseObject[@"result"];
            [personalTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)loadUserInfoIntegral{
    NSLog(@"%@",kUserInfo);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"id"] = kUserId;
    parms[@"userType"] = @"1";
    NSString *urlString = [NSString stringWithFormat:@"%@app/integral/get_integral_by_id_and_type.action",kSchoolUrl];
    [manager GET:urlString parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
            [headView.avatar sd_setImageWithURL:[NSURL URLWithString:kUserInfo[@"picUrl"]] placeholderImage:[UIImage imageNamed:@""]];
            headView.name.text = kUserInfo[@"nickName"];
            dataDic = responseObject[@"result"];
            NSDictionary *result = responseObject[@"result"];
            headView.ranking.text = result[@"nowSort"];
            headView.myGold.text = result[@"totalScore"];
            headView.clubGold.text = result[@"pubScore"];
            hasPub = result[@"hasPub"];
            if ([hasPub integerValue] == 0) {
                headView.btnClubGold.hidden = YES;
                headView.clubGold.hidden = YES;
                headView.rightLine.hidden = YES;
                CGRect rect1 = headView.leftLine.frame;
                rect1.origin.x = kWidth/2;
                headView.leftLine.frame = rect1;
                CGRect rect2 =  headView.nameMyGold.frame;
                rect2.origin.x = headView.btnClubGold.frame.origin.x;
                headView.nameMyGold.frame = rect2;
                CGRect rect3 = headView.myGold.frame;
                rect3.origin.x = headView.clubGold.frame.origin.x;
                headView.myGold.frame = rect3;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    PersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalCenterCell" owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadCellWithDic:dataArray[indexPath.row]];
    return cell;
}
/**
 *  查看当前金币排名
 */
-(void)lookRankingHistory:(BOOL)isMine{
    RankingViewController *ranking = [[RankingViewController alloc]init];
    NSLog(@"%@",dataDic);
    ranking.integralInfo = dataDic;
    ranking.isMyGold = isMine;
    [self.navigationController pushViewController:ranking animated:YES];
}
/**
 *  去抽奖
 */
-(void)goLottery{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"uid"] = kUserId;
    parms[@"utype"] = @"1";
    parms[@"businessType"] = @"1";
    NSString *urlString = [NSString stringWithFormat:@"%@app/order/get_duiba_url.action",kSchoolUrl];
    [manager GET:urlString parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
            CreditWebViewController *webView = [[CreditWebViewController alloc] initWithUrl:responseObject[@"result"]];
            [self.navigationController pushViewController:webView animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

/**
 *  去兑换
 */
-(void)goExchange{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"uid"] = kUserId;
    parms[@"utype"] = @"1";
    parms[@"businessType"] = @"0";
    NSString *urlString = [NSString stringWithFormat:@"%@app/order/get_duiba_url.action",kSchoolUrl];
    [manager GET:urlString parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
            CreditWebViewController *webView = [[CreditWebViewController alloc] initWithUrl:responseObject[@"result"]];
            [self.navigationController pushViewController:webView animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/**
 *  查看金币规则
 */
-(void)lookGlodRule{
    GlodRuleViewController *glodRule = [[GlodRuleViewController alloc] init];
    glodRule.hasPub = hasPub;
    glodRule.isGlodRule = YES;
    [self.navigationController pushViewController:glodRule animated:YES];
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
