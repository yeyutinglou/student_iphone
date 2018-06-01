//
//  DownloadPopupView.m
//  ClassRoom
//
//  Created by he chao on 7/1/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "DownloadPopupView.h"
#import "ClassDetailBoard.h"
#import "CurriculumBoard.h"
#import "MyClassBoard.h"
#import "DownloadPopupCell.h"

@implementation DownloadPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadContent{
    BeeUIImageView *imgPopup = [BeeUIImageView spawn];
    imgPopup.frame = CGRectMake(18, (self.height-250)/2.0, 283, 250);
    imgPopup.contentMode = UIViewContentModeScaleToFill;
    imgPopup.image = [IMAGESTRING(@"student_popup") stretchableImageWithLeftCapWidth:65 topCapHeight:50];
    imgPopup.userInteractionEnabled = NO;
    [self addSubview:imgPopup];
    
    BaseButton *btnClose = [BaseButton initBaseBtn:IMAGESTRING(@"student_close") highlight:nil];
    btnClose.frame = CGRectMake(imgPopup.right-35, 2+imgPopup.top, 35, 35);
    if (_isMyClass) {
        [btnClose addSignal:MyClassBoard.CLOSE forControlEvents:UIControlEventTouchUpInside object:[NSNumber numberWithBool:self.isVideo]];
    }
    else {
        [btnClose addSignal:self.isCurriculum?CurriculumBoard.CLOSE:ClassDetailBoard.CLOSE forControlEvents:UIControlEventTouchUpInside object:[NSNumber numberWithBool:self.isVideo]];
    }
    [self addSubview:btnClose];
    
    BaseLabel *title = [BaseLabel initLabel:self.isVideo?@"播放课件":@"下载讲义" font:FONT(14) color:RGB(83, 83, 83) textAlignment:NSTextAlignmentLeft];
    title.frame = CGRectMake(20+imgPopup.left, 3+imgPopup.top, 200, 35);
    [self addSubview:title];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(2+imgPopup.left, 35+imgPopup.top, 283-4, 249-35)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self addSubview:myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadPopupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[DownloadPopupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        

        [cell initSelf];
    }
    NSMutableDictionary *dict = self.arrayData[indexPath.row];
    cell.dict = dict;
    cell.isMyClass = _isMyClass;
    cell.isCurriculum = self.isCurriculum;
    cell.isVideo = self.isVideo;
    [cell load];
//    BaseLabel *title = (BaseLabel *)[cell.contentView viewWithTag:9527];
//    title.text = [NSString stringWithFormat:@"%@.%@",dict[@"name"],dict[@"resExtName"]];
//    
//    BeeUIImageView *icon = (BeeUIImageView *)[cell.contentView viewWithTag:9528];
//    icon.hidden = YES;
//    
//    BaseLabel *status = (BaseLabel *)[cell.contentView viewWithTag:9529];
//    if (self.isVideo) {
//        status.text = @"播放";
//        status.hidden = NO;
//        [cell makeTappable:ClassDetailBoard.PLAY_VIDEO withObject:self.arrayData[indexPath.row][@"resUrl"]];
//        //[self sendUISignal:ClassDetailBoard.PLAY_VIDEO withObject:self.arrayData[indexPath.row][@"resUrl"]];
//    }
//    else {
//        icon.hidden = NO;
//        status.hidden = YES;
//    }
    //[cell load];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.isVideo) {
//        [self sendUISignal:ClassDetailBoard.PLAY_VIDEO withObject:self.arrayData[indexPath.row][@"resUrl"]];
//    }
}

@end
