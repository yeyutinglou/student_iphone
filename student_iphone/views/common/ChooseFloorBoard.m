//
//  ChooseFloorBoard.m
//  teacher_iphone
//
//  Created by jyd on 16/6/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "ChooseFloorBoard.h"
#import "DictFloor.h"

@interface ChooseFloorBoard ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChooseFloorBoard
- (void)load {
    [super load];
    
}
//懒加载
-(NSArray *)floorArray{
    if (_floorArray==nil) {
        self.ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"buldingId"];
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_building_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"type",@"2").PARAM(@"dorm_id",self.ID);
        
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        [self handleRequest:request];
    }
    return _floorArray;
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
    
    tableFloorView = [[UITableView alloc] init];
    tableFloorView.dataSource = self;
    tableFloorView.delegate = self;
    tableFloorView.frame = self.bounds;
    tableFloorView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableFloorView];
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
                        DictFloor *dictFloor = [DictFloor floorWithDict:dict];
                        [arry addObject:dictFloor];
                    }
                    self.floorArray = [arry copy];
                    
                    //什么时候拿到数据什么时候刷新
                    [tableFloorView reloadData];
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
    
    return self.floorArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"floor";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    DictFloor *dictFl = self.floorArray[indexPath.row];
    cell.textLabel.text = dictFl.name;
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DictFloor *dictFl = self.floorArray[indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:dictFl.ID forKey:@"floorId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.deledate respondsToSelector:@selector(didSelectRowWithDictFloor:)]) {
        [self.deledate didSelectRowWithDictFloor:dictFl];
    }
}
@end
