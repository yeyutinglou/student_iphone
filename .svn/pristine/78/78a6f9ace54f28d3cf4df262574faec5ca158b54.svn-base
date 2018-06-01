//
//  VoiceView.m
//  ClassRoom
//
//  Created by he chao on 8/9/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "VoiceView.h"
#import "amrFileCodec.h"

@implementation VoiceView
DEF_SIGNAL(OPERATE)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self observeNotification:@"stop_voice"];
        isPlay = NO;
        BaseButton *bg = [BaseButton initBaseBtn:IMAGESTRING(@"play_bg") highlight:IMAGESTRING(@"chat_input")];
        [bg addSignal:VoiceView.OPERATE forControlEvents:UIControlEventTouchUpInside];
        bg.frame = CGRectMake(0, 0, 142, 31);
        [self addSubview:bg];
//        UIButton *bg = [UIButton spawn];
//        bg.frame = CGRectMake(0, 0, 142, 31);
//        [bg setImage:IMAGESTRING(@"play_bg") forState:UIControlStateNormal];
//        [bg addTarget:self action:@selector(operate) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:bg];
        
        imgStop = [BeeUIImageView spawn];
        imgStop.frame = CGRectMake(110, 0, 30, 31);
        imgStop.image = IMAGESTRING(@"play2");
        imgStop.hidden = NO;
        [bg addSubview:imgStop];
        
        imgPlay = [BeeUIImageView spawn];
        imgPlay.frame = imgStop.frame;
        NSArray *images = @[IMAGESTRING(@"play0"),IMAGESTRING(@"play1"),IMAGESTRING(@"play2")];
        imgPlay.animationImages = images;
        imgPlay.animationDuration = 1;
        imgPlay.hidden = YES;
        [imgPlay startAnimating];
        [bg addSubview:imgPlay];
        
        time = [BaseLabel initLabel:@"20s" font:FONT(13) color:RGB(137, 137, 137) textAlignment:NSTextAlignmentLeft];
        time.frame = CGRectMake(bg.right+3, 0, 200, bg.height);
        [self addSubview:time];
    }
    return self;
}

- (void)dealloc{
    [self unobserveNotification:@"stop_voice"];
}

ON_SIGNAL2(VoiceView, signal) {
    if ([signal is:VoiceView.OPERATE]) {
        isPlay = !isPlay;
        imgPlay.hidden = !isPlay;
        imgStop.hidden = isPlay;
        
        if (isPlay) {
            [imgPlay startAnimating];
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            //[self postNotification:@"stop_voice"];
            NSString *filename = [[dictData[@"voiceRecordUrl"] componentsSeparatedByString:@"/"] lastObject];
            NSData * audioData;
            audioData = [[BeeFileCache sharedInstance] objectForKey:filename];
            if (audioData) {
                
            }
            else {
                NSURL *url = [NSURL URLWithString:dictData[@"voiceRecordUrl"]];
                audioData = [NSData dataWithContentsOfURL:url];
                [[BeeFileCache sharedInstance] setObject:audioData forKey:filename];
            }
           // [NSThread detachNewThreadSelector:@selector(decode:) toTarget:self withObject:audioData];
            NSData *waveData = DecodeAMRToWAVE(audioData);
            NSError *error;
            audioPlayer = [[AVAudioPlayer alloc] initWithData:waveData?waveData:audioData error:&error];
            audioPlayer.numberOfLoops = 0;
            [audioPlayer play];
            [self performSelector:@selector(stop) withObject:nil afterDelay:[dictData[@"voiceRecordTime"] floatValue]];
        }
        else {
            [imgPlay stopAnimating];
            [audioPlayer stop];
            audioPlayer = nil;
        }
    }
}

- (void)decode:(NSData *)audioData{
    NSData *waveData = DecodeAMRToWAVE(audioData);
    [self performSelectorOnMainThread:@selector(playWave:) withObject:waveData?waveData:audioData waitUntilDone:NO];
}

- (void)playWave:(NSData *)data{
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
}

- (void)stop{
    if (isPlay) {
        isPlay = NO;
        imgPlay.hidden = YES;
        imgStop.hidden = NO;
        [audioPlayer stop];
        audioPlayer = nil;
    }
}

ON_NOTIFICATION(notification){
    if ([notification is:@"stop_voice"]) {
        if (isPlay) {
            isPlay = NO;
            imgPlay.hidden = YES;
            imgStop.hidden = NO;
            [audioPlayer stop];
            audioPlayer = nil;
        }
    }
}

- (void)loadData:(NSMutableDictionary *)dict{
    imgPlay.hidden = !isPlay;
    imgStop.hidden = isPlay;
    if (isPlay) {
        //[imgPlay stopAnimating];
        [imgPlay startAnimating];
    }
    
    dictData = dict;
    time.text = [NSString stringWithFormat:@"%@s",dict[@"voiceRecordTime"]];
}

//- (void)operate{
//    isPlay = !isPlay;
//    imgPlay.hidden = !isPlay;
//    imgStop.hidden = isPlay;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
