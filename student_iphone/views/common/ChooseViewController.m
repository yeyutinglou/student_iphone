//
//  ChooseViewController.m
//  teacher_iphone
//
//  Created by jyd on 16/6/2.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "ChooseViewController.h"
#import "DictBuilding.h"
@interface ChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChooseViewController
- (void)load {
     [super load];
}
-(NSArray *)buildingArray{
    if (_buildingArray==nil) {
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_building_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"type",@"1");
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        [self handleRequest:request];
    }
    return _buildingArray;
}
- (void)unload {
    
}
ON_CREATE_VIEWS( signal )
{
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

-(void)loadContent{
    tableBuildingView = [[UITableView alloc] init];
    tableBuildingView.dataSource = self;
    tableBuildingView.delegate = self;
    tableBuildingView.frame = self.bounds;
    tableBuildingView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableBuildingView];
}


- (void)handleRequest:(BeeRequest *)request
{
    if(request.failed)
    {
        [[BeeUITipsCenter sharedInstance] dismissTips];
        NETWORK_ERROR
        
    }
    else if (request.succeed){
        [[BeeUITipsCenter sharedInstance] dismissTips];
        id json = [request.responseString mutableObjectFromJSONString];
        NSMutableArray *arry = [NSMutableArray array];
        switch ([json[@"STATUS"] intValue]) {
            case 0:
            {
                {
                    for (NSDictionary *dict in json[@"result"]) {
                        DictBuilding *dictBuilding = [DictBuilding buildingWithDict:dict];
                            [arry addObject:dictBuilding];
                        }
                        self.buildingArray = [arry copy];
                        [tableBuildingView reloadData];
                    }
                        break;
                        
                    default:
                        break;
                }
                
        }
                
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.buildingArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"building";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    DictBuilding *dictBu = self.buildingArray[indexPath.row];
    
    cell.textLabel.text = dictBu.name;
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DictBuilding *dictBuilding = self.buildingArray[indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:dictBuilding.ID forKey:@"buldingId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.deledate respondsToSelector:@selector(didSelectRowWithDict:)]) {
        [self.deledate didSelectRowWithDict:dictBuilding];
    }
}
@end
