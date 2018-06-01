//
//  ChooseClassroomBoard.m
//  teacher_iphone
//
//  Created by jyd on 16/6/6.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "ChooseClassroomBoard.h"
#import "DictClassroom.h"


@interface ChooseClassroomBoard ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChooseClassroomBoard
- (void)load {
    [super load];
    
}

-(NSArray *)floorArray{
    if (_classroomArray==nil) {
    self.ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"floorId"];
        BeeHTTPRequest *request = [self POST:[NSString stringWithFormat:@"%@%@",kSchoolUrl,@"app/course/get_building_list.action"]].PARAM(@"id",kUserInfo[@"id"]).PARAM(@"type",@"3").PARAM(@"dorm_id",self.ID);
        
        request.HEADER(@"sessionId",kUserInfo[@"sessionId"]);
        [self handleRequest:request];
    }
    return _classroomArray;
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
    
    tableClassroomView = [[UITableView alloc] init];
    tableClassroomView.dataSource = self;
    tableClassroomView.delegate = self;
    tableClassroomView.frame = self.bounds;
    tableClassroomView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableClassroomView];
    
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
                        DictClassroom *dictClass = [DictClassroom classWithDict:dict];
                        [arry addObject:dictClass];
                    }
                    self.classroomArray = [arry copy];
                    [tableClassroomView reloadData];
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
    
    static NSString *ID = @"class";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    DictClassroom *dictCl = self.classroomArray[indexPath.row];
    cell.textLabel.text = dictCl.name;
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DictClassroom *dictCl = self.classroomArray[indexPath.row];
    if ([self.deledate respondsToSelector:@selector(didSelectRowWithDictClass:)]) {
        [self.deledate didSelectRowWithDictClass:dictCl];
    }
}


@end
