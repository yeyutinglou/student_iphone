//
//  RankingViewController.m
//  student_iphone
//
//  Created by jyd on 15/8/19.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "RankingViewController.h"
#import "RankingCell.h"
#import "RankingHeadView.h"
#import "GlodRuleViewController.h"
@interface RankingViewController ()<UITableViewDataSource,UITableViewDelegate,RankingHeadDelegate>
{
    RankingHeadView *headView;
    UITableView *rankingTableView;
    NSMutableArray *dataArray;
}
@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"排行榜";
    [self showNaviBar];
    [self loadTableView];
    [self loadHeadView];
    [self loadIntegralRanking];
}
- (void)showNaviBar{
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
    headView = [[[NSBundle mainBundle] loadNibNamed:@"RankingHeadView" owner:nil options:nil] lastObject];
    headView.delegate = self;
    rankingTableView.tableHeaderView = headView;
    headView.goldLabel.text = self.integralInfo[@"totalScore"];
    headView.nowSortLabel.text = self.integralInfo[@"nowSort"];
    headView.hisSortLabel.text = self.integralInfo[@"hisSort"];
}

-(void)loadTableView{
    rankingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64 ) style:UITableViewStylePlain];
    rankingTableView.dataSource = self;
    rankingTableView.delegate = self;
    [self.view addSubview:rankingTableView];
    dataArray = [[NSMutableArray alloc] init];
}

-(void)loadIntegralRanking{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (self.isMyGold) {
         parms[@"userType"] = @"1";
    }else{
         parms[@"userType"] = @"0";
        headView.nameGoldLabel.text = @"社团金币:";
    }
   
    NSString *urlString = [NSString stringWithFormat:@"%@app/integral/get_integral_list.action",kSchoolUrl];
    [manager GET:urlString parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"STATUS"] isEqualToString:STATUS_SUCCESS]) {
            dataArray = [responseObject[@"result"] mutableCopy];
            NSArray *arr = responseObject[@"result"];
            NSMutableDictionary *userDic;
            for(int i = 0; i < arr.count; i++){
                NSDictionary *dic = arr[i];
                if([dic[@"userId"] isEqualToString:kUserId]){
                    userDic = dic;
                }
            }
            for(int i = 0; i < arr.count; i++){
                NSDictionary *dic = arr[i];
                NSString *sort;
                NSMutableDictionary *oneDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *sencodDic = [[NSMutableDictionary alloc] init];
                if([userDic[@"integralCount"] isEqualToString:dic[@"integralCount"]] && ![dic[@"userId"] isEqualToString:kUserId]){
                    sort = dic[@"sort"];
                    if([sort integerValue] < [userDic[@"sort"] integerValue]){
                        [oneDic setObject:dic[@"integralCount"] forKey:@"integralCount"];
                        [oneDic setObject:dic[@"userId"] forKey:@"userId"];
                        [oneDic setObject:dic[@"name"] forKey:@"name"];
                        [oneDic setObject:userDic[@"sort"] forKey:@"sort"];
                        [sencodDic setObject:userDic[@"integralCount"] forKey:@"integralCount"];
                        [sencodDic setObject:userDic[@"userId"] forKey:@"userId"];
                        [sencodDic setObject:userDic[@"name"] forKey:@"name"];
                        [sencodDic setObject:sort forKey:@"sort"];
                        [dataArray replaceObjectAtIndex:[userDic[@"sort"] integerValue] -1 withObject:oneDic];
                        [dataArray replaceObjectAtIndex:[sort integerValue] -1 withObject:sencodDic];
                    }
                    
                    
                    break;
                }
                
            }

            [rankingTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadCellWithDic:dataArray[indexPath.row]];
    return cell;
}

-(void)howAcquireMoreGlod{
    GlodRuleViewController *glodRule = [[GlodRuleViewController alloc] init];
    glodRule.hasPub = self.integralInfo[@"hasPub"];
    glodRule.isGlodRule = NO;
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
