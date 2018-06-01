//
//  FaceSelectView.m
//  ClassRoom
//
//  Created by he chao on 7/19/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "FaceSelectView.h"
#import "AppDelegate.h"

@implementation FaceSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadContent{
    if (!facePageCtrl) {
        facePageCtrl = [[CVScrollPageViewController alloc] init];
    }
    facePageCtrl.frame = self.bounds;
    facePageCtrl.view.hidden = NO;
    facePageCtrl.view.backgroundColor = RGB(239, 239, 239);
    [facePageCtrl setDelegate:self];
    facePageCtrl.pageCount = 3;
    facePageCtrl.pageControlFrame = CGRectMake(0, 140, self.width, 20);
    [facePageCtrl reloadData];
    
    [self addSubview:facePageCtrl.view];
}

- (void)didScrollToPageAtIndex:(NSUInteger)index {
}

- (UIView *)scrollPageView:(id)scrollPageView viewForPageAtIndex:(NSUInteger)index {
    UIView *pageView;
    pageView = (UIView *)[scrollPageView dequeueReusablePage:index];
    if (nil == pageView) {
        pageView = [[UIView alloc] initWithFrame:facePageCtrl.view.bounds];
    }
    for (id element in pageView.subviews) {
        [element removeFromSuperview];
    }
    
    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 3; j++) {
            BeeUIButton *btnFace = [BeeUIButton spawn];
            btnFace.frame = CGRectMake(i*self.width/7.0, j*40, self.width/7.0, self.width/7.0);
            if (i==6 && j==2) {
                [btnFace setImage:IMAGESTRING(@"face_del_ico_dafeult.png") forState:UIControlStateNormal];
                [btnFace addTarget:self action:@selector(clickDelFace) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                int source = j*7+i+index*20+1;
                btnFace.tag = source;
                NSString *strSource = [NSString stringWithFormat:@"face_%d",source];
                [btnFace setImage:IMAGESTRING(strSource) forState:UIControlStateNormal];
                [btnFace addTarget:self action:@selector(clickFace:) forControlEvents:UIControlEventTouchUpInside];
            }
            [pageView addSubview:btnFace];
        }
    }
    return pageView;
}

- (void)clickFace:(BeeUIButton *)btn{
    NSString *strSource = [NSString stringWithFormat:@"face_%d.png",btn.tag];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *dictFace = delegate.dictFace;
    
    NSString *strKey;
    for (int j = 0; j<=[[dictFace allKeys]count]-1; j++) {
        if ([[dictFace objectForKey:[[dictFace allKeys]objectAtIndex:j]] isEqual:strSource]) {
            strKey = [[dictFace allKeys] objectAtIndex:j];
        }
    }
    NSLog(@"%@",strKey);
    
    [self.mainCtrl performSelector:@selector(chooseFace:) withObject:strKey];
//    field.text = [NSString stringWithFormat:@"%@%@",field.text,strKey];
//    
//    [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btnSend.enabled = YES;
}

- (void)clickDelFace{
    [self.mainCtrl performSelector:@selector(delFace)];
    NSLog(@"del");
}

- (void)chooseFace:(NSString *)strFace{
}

- (void)delFace{
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
