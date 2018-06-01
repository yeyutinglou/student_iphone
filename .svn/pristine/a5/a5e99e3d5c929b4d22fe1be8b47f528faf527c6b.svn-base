//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  AppTabbar_iPhone.m
//  Walker
//
//  Created by he chao on 3/10/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "AppTabbar_iPhone.h"

#pragma mark -
//DEF_PACKAGE(BeePackage_UI,AppTabbar_iPhone, tabbar)

@implementation AppTabbar_iPhone
//DEF_SINGLETON( AppTabbar_iPhone )

SUPPORT_RESOURCE_LOADING( YES )


- (void)load
{
	[super load];
    
    [self selectTab0];
    
    [self observeNotification:kBadge];
}

- (void)unload
{
	[super unload];
}

ON_NOTIFICATION(notification){
    if ([notification is:kBadge]) {
        [self setBadgeStatus];
    }
}

- (void)setBadgeStatus{
    for (int i = 0; i < 5; i++) {
        $([NSString stringWithFormat:@"#badge-bg%d",i]).HIDE();
        $([NSString stringWithFormat:@"#badge%d",i]).HIDE();
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"roadBadge"] boolValue]) {
        $(@"#badge-bg0").SHOW();
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"messageBadge"] boolValue]) {
        $(@"#badge-bg1").SHOW();
        $(@"#badge1").SHOW();
        $(@"#badge1").TEXT([[NSUserDefaults standardUserDefaults] valueForKey:@"messageBadgeNum"]);
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"publicBadge"] boolValue]) {
        $(@"#badge-bg2").SHOW();
        $(@"#badge2").SHOW();
        $(@"#badge2").TEXT([[NSUserDefaults standardUserDefaults] valueForKey:@"publicBadgeNum"]);
    }
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"friendBadge"] boolValue]) {
//        $(@"#badge-bg3").SHOW();
//        $(@"#badge3").SHOW();
//        //$(@"#badge3").TEXT([[NSUserDefaults standardUserDefaults] valueForKey:@"messageBadgeNum"]);
//    }
    
    if ([self getMessageUnReadCount]>0  && [[[NSUserDefaults standardUserDefaults] valueForKey:@"friendBadge"] boolValue]) {
        $(@"#badge-bg3").SHOW();
        $(@"#badge3").SHOW();
        $(@"#badge3").TEXT([NSString stringWithFormat:@"%d",[self getMessageUnReadCount]]);
        if ([self getMessageUnReadCount]>99) {
            $(@"#badge3").TEXT(@"...");
        }
    }
    
    self.RELAYOUT();
    for (UIView *vi in self.subviews){
        if (vi.top>=40) {
            vi.frame = CGRectMake(vi.left, vi.top-50, vi.width, vi.height);
        }
    }
}

- (int)getMessageUnReadCount{
    NSMutableArray *arrayMessage = [[MessageDB sharedInstance] queryFriendMessage];
    int count = 0;
    for (NSMutableDictionary *dict in arrayMessage) {
        if ([dict[@"unReadCount"] intValue]>0) {
            count += [dict[@"unReadCount"] intValue];
        }
    }
    return count;
}

#pragma mark Signal

- (void)deselectAll{
    for (int i = 0; i < 5; i++) {
        $([NSString stringWithFormat:@"#img_tab%d",i]).HIDE();
        $([NSString stringWithFormat:@"#btn_tab%d",i]).UNSELECT();
    }
    [self setBadgeStatus];
}


- (void)selectTab0{
    [self deselectAll];
    
    $(@"#img_tab0").SHOW();
	$(@"#btn_tab0").SELECT();
    
    
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"roadBadge"];
    $(@"#badge-bg0").HIDE();
    
    self.RELAYOUT();
    
    [self postNotification:kBadge];
}

- (void)selectTab1{
    [self deselectAll];
    
    $(@"#img_tab1").SHOW();
	$(@"#btn_tab1").SELECT();
    
    
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"messageBadge"];
    $(@"#badge-bg1").HIDE();
    
    self.RELAYOUT();
    
    [self postNotification:kBadge];
}

- (void)selectTab2{
    [self deselectAll];
    
    $(@"#img_tab2").SHOW();
	$(@"#btn_tab2").SELECT();
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"publicBadge"] boolValue]) {
        [self postNotification:@"newPublicInfo"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"publicBadge"];
    $(@"#badge-bg2").HIDE();
    
    self.RELAYOUT();
    
    [self postNotification:kBadge];

}

- (void)selectTab3{
    [self deselectAll];
    
    $(@"#img_tab3").SHOW();
	$(@"#btn_tab3").SELECT();
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"friendBadge"] boolValue]) {
        [self postNotification:@"newMessage"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"friendBadge"];
    $(@"#badge-bg3").HIDE();
    
    self.RELAYOUT();
    
    [self postNotification:kBadge];
}

- (void)selectTab4{
    [self deselectAll];
    
    $(@"#img_tab4").SHOW();
    $(@"#btn_tab4").SELECT();
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"friendBadge"] boolValue]) {
        [self postNotification:@"newMessage"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"friendBadge"];
    $(@"#badge-bg4").HIDE();
    
    self.RELAYOUT();
    
    [self postNotification:kBadge];
}


@end
