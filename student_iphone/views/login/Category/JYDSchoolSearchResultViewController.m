//
//  JYDSchoolSearchResultViewController.m
//  teacher_ipad
//
//  Created by jyd on 15/7/16.
//  Copyright (c) 2015年 leon. All rights reserved.
//

#import "JYDSchoolSearchResultViewController.h"
#import "ChineseString.h"

@interface JYDSchoolSearchResultViewController ()

@end

@implementation JYDSchoolSearchResultViewController

-(NSMutableArray *)resultSchools
{
    if (_resultSchools == nil) {
        _resultSchools = [NSMutableArray array];
    }
    
    return _resultSchools;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    //searchText = searchText.lowercaseString;
    
    //不区分大小写 | 忽略 "-" 符号的比较
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    self.resultSchools = [NSMutableArray array];
    // 根据关键字搜索想要的城市数据
    for (ChineseString *item in self.schoolArray) {

        NSRange hanziRange = [item.hanzi rangeOfString:searchText options:searchOptions range:NSMakeRange(0, item.hanzi.length)];
        
        NSRange pinyinRange = [item.pinYin rangeOfString:searchText options:searchOptions range:NSMakeRange(0, item.pinYin.length)];
        
        //NSRange pinyinAllRange = [item.pinyinAllLetter rangeOfString:searchText options:searchOptions range:NSMakeRange(0, item.pinyinAllLetter.length)];
        
        if (hanziRange.length || pinyinRange.length) {
            [self.resultSchools addObject:item];
        }
        
        //if ([item.hanzi containsString:searchText] || [item.pinyinAllLetter containsString:searchText] || [item.pinYin containsString:searchText]) {
        //    [self.resultSchools addObject:item];
        //}
    }
    
    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hanzi contains %@ or pinyinAllLetter contains %@", searchText, searchText];
    //self.resultSchools = [self.schoolArray filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultSchools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"school";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = ((ChineseString *)self.resultSchools[indexPath.row]).hanzi;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%ld个搜索结果", self.resultSchools.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发出通知
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JYDSchoolDidChangeNotification" object:nil userInfo:@{@"JYDSelectSchool" : self.resultSchools[indexPath.row]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
