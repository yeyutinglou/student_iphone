//
//  MessageView.m
//  ClassRoom
//
//  Created by he chao on 14-6-24.
//  Copyright (c) 2014年 he chao. All rights reserved.
//

#import "MessageView.h"
#import "MessageCell.h"
#import "ChatBoard.h"
#import "StudentHomePageBoard.h"

@implementation MessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)loadContent{
    [self observeNotification:kBadge];
    self.backgroundColor = RGB(242, 242, 242);
    myTableView = [[UITableView alloc] initWithFrame:self.bounds];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:myTableView];
    
    [self loadMessage];
}

ON_NOTIFICATION(notification){
    if ([notification is:kBadge]) {
        [self loadMessage];
    }
}

- (void)loadMessage{
    arrayMessage = [[MessageDB sharedInstance] queryFriendMessage];
    [myTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayMessage.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"cell%d",indexPath.row];
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        [cell initSelf];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *vi = [[UIView alloc] init];
    vi.backgroundColor = RGB(242, 242, 242);
    cell.backgroundView = vi;
    
    BeeUIImageView *viSelected = [BeeUIImageView spawn];
    viSelected.contentMode = UIViewContentModeScaleToFill;
    viSelected.image = [IMAGESTRING(@"frend_cell_selected") stretchableImageWithLeftCapWidth:6 topCapHeight:1];
    //viSelected.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = viSelected;
    
    cell.dictMessage = arrayMessage[indexPath.row];
    
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch ([arrayMessage[indexPath.row][@"msgType"] intValue]) {
        case 3:
        {
            ChatBoard *board = [[ChatBoard alloc] init];
            board.dictFriend = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrayMessage[indexPath.row][@"friendId"],@"id",arrayMessage[indexPath.row][@"friendName"],@"nickName", nil];
            [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        }
            break;
        case -2: //-2和2 忽略和请求
        case 2:
        {
            StudentHomePageBoard *board = [[StudentHomePageBoard alloc] init];
            board.type = 2;
            board.dictMessage = arrayMessage[indexPath.row];
            [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        }
            break;
            
        default:
        {
            ChatBoard *board = [[ChatBoard alloc] init];
            board.dictFriend = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrayMessage[indexPath.row][@"friendId"],@"id",arrayMessage[indexPath.row][@"friendName"],@"nickName", nil];
            [[MainBoard sharedInstance].stack pushBoard:board animated:YES];
        }
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *dictTempMessage = arrayMessage[indexPath.row];
        [[MessageDB sharedInstance] deleteFriendMessage:dictTempMessage];
        [[ChatDB sharedInstance] deleteFriendMessage:dictTempMessage];
        
        [arrayMessage removeObjectAtIndex:indexPath.row];
        [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
