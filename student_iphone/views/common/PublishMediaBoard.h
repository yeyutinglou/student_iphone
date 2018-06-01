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
//  PublishMediaBoard.h
//  ClassRoom
//
//  Created by he chao on 7/1/14.
//  Copyright (c) 2014 he chao. All rights reserved.
//

#import "Bee.h"
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import "PostImage.h"

#pragma mark -

@interface PublishMediaBoard : BaseBoard<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BeeUIButton *btnDone,*btnChange,*btnDeleteVoice,*imgVoiceBg;
    UIButton *btnRecording;
    BeeUIImageView *vi;
    //添加笔记图片的滚动容器
    UIScrollView *scrollVPhoto;
    /**
     *  图片数组
     */
    NSMutableArray *arrayImages;
    
    /**
     *  文本输入框
     */
    BeeUITextField *field;
    
    /**
     *  是否正在语音输入
     */
    BOOL isVoice;
    
    /**
     *  开始时间
     */
    long long startTime;
    
    /**
     *  表示正在语音状态的GIF动画
     */
    UIImageView *imgGif;
    
    /**
     *  显示说话时间的Lael
     */
    BaseLabel *time_recording;
    
    /**
     *  上传图片需要
     */
    PostImage *postImage;
    
    /**
     *  声音秒数
     */
    int recordSeconds;
    
    BOOL isAllowRecord,haseVoice;
    
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    
    /**
     *  声音记录类型
     */
    int recordEncoding;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
    float Pitch;
    NSTimer *timerForPitch;
    
}
@property (nonatomic, strong) NSMutableDictionary *dictCourse;

AS_SIGNAL(DONE)
AS_SIGNAL(ADD)
AS_SIGNAL(DEL)
AS_SIGNAL(DEL_VOICE)
AS_SIGNAL(CAMERA)
AS_SIGNAL(LIBRARY)
AS_SIGNAL(CHANGE)
AS_SIGNAL(PLAY)
@end
