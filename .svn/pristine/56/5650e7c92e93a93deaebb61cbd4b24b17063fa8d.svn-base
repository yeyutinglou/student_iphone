//
//  GlodRuleViewController.m
//  student_iphone
//
//  Created by jyd on 15/8/25.
//  Copyright (c) 2015年 he chao. All rights reserved.
//

#import "GlodRuleViewController.h"

@interface GlodRuleViewController ()
{
    UIWebView *glodWebView;
}

@end

@implementation GlodRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"金币规则";
    [self showNaviBar];
    [self loadWebView];
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

-(void)loadWebView{
    glodWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    NSString *urlString = [NSString stringWithFormat:@"%@app/integral/integral_rules.action?userType=1&hasPub=%@",kSchoolUrl,self.hasPub];
//    if (self.isGlodRule) {
//        urlString = [NSString stringWithFormat:@"http://192.168.4.248:8080/app/integral/integral_rules.action?userType=1&hasPub=%@",self.hasPub];
//    }else{
//        
//    }
//   
    [glodWebView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
   
    [self.view addSubview:glodWebView];
    
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
