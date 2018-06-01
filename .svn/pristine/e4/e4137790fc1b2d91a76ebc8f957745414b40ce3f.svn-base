//
//  PlayViewController.m
//  ClassRoom
//
//  Created by he chao on 6/28/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"m4v"];
//    //视频URL
//    NSURL *url = [NSURL fileURLWithPath:path];
//    //视频播放对象
//    MPMoviePlayerController *movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    movie.controlStyle = MPMovieControlStyleFullscreen;
//    [movie.view setFrame:self.view.bounds];
//    movie.initialPlaybackTime = -1;
//    [self.view addSubview:movie.view];
//    // 注册一个播放结束的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(myMovieFinishedCallback:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:movie];
//    [movie shouldAutoplay];
//    [movie play];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //return (interfaceOrientation != UIInterfaceOrientationMaskLandscapeLeft);
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)myMovieFinishedCallback:(NSNotification*)notify
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
