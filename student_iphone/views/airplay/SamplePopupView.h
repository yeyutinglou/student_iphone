//
//  SamplePopupView.h
//  UdpEchoClient
//
//  Created by jyd on 15/1/28.
//
//

#import <UIKit/UIKit.h>

@protocol SamplePopupViewDelete <NSObject>

@optional
-(void)topSure:(NSString *)roomIP;
-(void)bottomSure:(NSString *)roomIP;

@end

@interface SamplePopupView : UIView

@property (nonatomic, weak) UIView *topView;

@property (nonatomic, weak) UIButton *topSureButton;

@property (nonatomic, weak) UIButton *topCancelButton;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) UIButton *roomButton1;

@property (nonatomic, weak) UIButton *roomButton2;

@property (nonatomic, weak) UIButton *roomButton3;

@property (nonatomic, weak) UIButton *roomButton4;


@property (nonatomic, weak) UIImageView *checkImageView1;

@property (nonatomic, weak) UIImageView *checkImageView2;

@property (nonatomic, weak) UIImageView *checkImageView3;

@property (nonatomic, weak) UIImageView *checkImageView4;

@property (nonatomic, weak) UIButton *sureButton;

@property (nonatomic, strong) UIButton *selectedButton;

@property (strong, nonatomic) UIImageView *selectedImageView;

@property (nonatomic, weak) id<SamplePopupViewDelete> delegete;

@property (copy, nonatomic) NSString *roomIP;

@end
