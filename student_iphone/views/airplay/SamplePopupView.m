//
//  SamplePopupView.m
//  UdpEchoClient
//
//  Created by jyd on 15/1/28.
//
//

#import "SamplePopupView.h"

@implementation SamplePopupView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupSubviews];
        self.backgroundImage = [IMAGESTRING(@"background-p") stretchableImageWithLeftCapWidth:50 topCapHeight:50];
        //[self setBackgroundColor:[UIColor colorWithRed:(78)/255.0 green:(78)/255.0 blue:(78)/255.0 alpha:1.0]];
    }
    
    return self;
}

-(void)setupSubviews
{
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    int PADDING = 15;
    
//    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.image = [[UIImage imageNamed:@"background"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
//    imageView.frame = CGRectMake(0, 0, width, height);
//    
//    [self addSubview:imageView];
    
    UIView *topview = [[UIView alloc]init];
    topview.frame = CGRectMake(0, 0, width, 50);
    self.topView = topview;
    [self addSubview:topview];
    
    UIButton *topCancelButton = [[UIButton alloc]init];
    topCancelButton.frame = CGRectMake(PADDING, 0, 44, 50);
    topCancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [topCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [topCancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [topCancelButton addTarget:self action:@selector(topCancel) forControlEvents:UIControlEventTouchUpInside];
    self.topCancelButton = topCancelButton;
    [self.topView addSubview:topCancelButton];
    
    UIButton *topSureButton = [[UIButton alloc]init];
    topSureButton.frame = CGRectMake(width-PADDING-44, 0, 44, 50);
    topSureButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [topSureButton setTitle:@"确定" forState:UIControlStateNormal];
    [topSureButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [topSureButton addTarget:self action:@selector(topSure) forControlEvents:UIControlEventTouchUpInside];
    self.topSureButton = topSureButton;
    [self.topView addSubview:topSureButton];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:[UIColor grayColor]];
    lineView.alpha = 0.8;
    lineView.frame = CGRectMake(10, CGRectGetMaxY(self.topCancelButton.frame), width-20, 2);
    [self addSubview:lineView];
    
    //底部教室
    UIView *bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), width, height-CGRectGetMaxY(lineView.frame));
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    
    //连接投屏到
    UILabel *labelRoom = [[UILabel alloc]init];
    labelRoom.text = @"连接投屏到";
    labelRoom.font = [UIFont boldSystemFontOfSize:16];
    [labelRoom setTextColor:[UIColor whiteColor]];
    labelRoom.textAlignment = NSTextAlignmentCenter;
    labelRoom.frame = CGRectMake(10, 20, width/3, 50);
    [self.bottomView addSubview:labelRoom];
    
    //教室1
    UIButton *room1 = [[UIButton alloc]init];
    [room1 setTitle:@"教室1" forState:UIControlStateNormal];
    room1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [room1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [room1 setBackgroundImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    [room1 addTarget:self action:@selector(roomSelected:) forControlEvents:UIControlEventTouchUpInside];
    [room1 setBackgroundImage:[UIImage imageNamed:@"screen-"] forState:UIControlStateSelected];
    room1.frame = CGRectMake(CGRectGetMaxX(labelRoom.frame)+5, labelRoom.frame.origin.y, width/3, 44);
    self.roomButton1 = room1;
    [self.bottomView addSubview:room1];
    
    UIImageView *checkImageView1 = [[UIImageView alloc]init];
    checkImageView1.frame = CGRectMake(CGRectGetMaxX(room1.frame)+20, room1.frame.origin.y, 38, 31);
    checkImageView1.image = [UIImage imageNamed:@"check"];
    checkImageView1.hidden = YES;
    self.checkImageView1 = checkImageView1;
    [self.bottomView addSubview:checkImageView1];
    
    //教室2
    UIButton *room2 = [[UIButton alloc]init];
    [room2 setTitle:@"教室2" forState:UIControlStateNormal];
    room2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [room2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [room2 setBackgroundImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    [room2 addTarget:self action:@selector(roomSelected:) forControlEvents:UIControlEventTouchUpInside];
    [room2 setBackgroundImage:[UIImage imageNamed:@"screen-"] forState:UIControlStateSelected];
    room2.frame = CGRectMake(CGRectGetMaxX(labelRoom.frame)+5, CGRectGetMaxY(room1.frame)+10, width/3, 44);
    self.roomButton2 = room2;
    [self.bottomView addSubview:room2];
    
    UIImageView *checkImageView2 = [[UIImageView alloc]init];
    checkImageView2.frame = CGRectMake(CGRectGetMaxX(room2.frame)+20, room2.frame.origin.y, 38, 31);
    checkImageView2.image = [UIImage imageNamed:@"check"];
    checkImageView2.hidden = YES;
    self.checkImageView2 = checkImageView2;
    [self.bottomView addSubview:checkImageView2];
    
    //教室3
    UIButton *room3 = [[UIButton alloc]init];
    [room3 setTitle:@"教室3" forState:UIControlStateNormal];
    room3.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [room3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [room3 setBackgroundImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    [room3 addTarget:self action:@selector(roomSelected:) forControlEvents:UIControlEventTouchUpInside];
    [room3 setBackgroundImage:[UIImage imageNamed:@"screen-"] forState:UIControlStateSelected];
    room3.frame = CGRectMake(CGRectGetMaxX(labelRoom.frame)+5, CGRectGetMaxY(room2.frame)+10, width/3, 44);
    self.roomButton3 = room3;
    [self.bottomView addSubview:room3];
    
    UIImageView *checkImageView3 = [[UIImageView alloc]init];
    checkImageView3.frame = CGRectMake(CGRectGetMaxX(room3.frame)+20, room3.frame.origin.y, 38, 31);
    checkImageView3.image = [UIImage imageNamed:@"check"];
    checkImageView3.hidden = YES;
    self.checkImageView3 = checkImageView3;
    [self.bottomView addSubview:checkImageView3];
    
    //教室4
    UIButton *room4 = [[UIButton alloc]init];
    [room4 setTitle:@"教室4" forState:UIControlStateNormal];
    room4.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [room4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [room4 setBackgroundImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    [room4 addTarget:self action:@selector(roomSelected:) forControlEvents:UIControlEventTouchUpInside];
    [room4 setBackgroundImage:[UIImage imageNamed:@"screen-"] forState:UIControlStateSelected];
    room4.frame = CGRectMake(CGRectGetMaxX(labelRoom.frame)+5, CGRectGetMaxY(room3.frame)+10, width/3, 44);
    self.roomButton4 = room4;
    [self.bottomView addSubview:room4];
    
    UIImageView *checkImageView4 = [[UIImageView alloc]init];
    checkImageView4.frame = CGRectMake(CGRectGetMaxX(room4.frame)+20, room4.frame.origin.y, 38, 31);
    checkImageView4.image = [UIImage imageNamed:@"check"];
    checkImageView4.hidden = YES;
    self.checkImageView4 = checkImageView4;
    [self.bottomView addSubview:checkImageView4];
    
    //添加确认按钮
    UIButton *sureButton = [[UIButton alloc]init];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(bottomSure) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton = sureButton;
    sureButton.frame = CGRectMake(CGRectGetMidX(labelRoom.frame), CGRectGetMaxY(room4.frame) + 20, width - CGRectGetMidX(labelRoom.frame)*2, 50);
    [self.bottomView addSubview:sureButton];
    
    //默认选择第一个
    [self roomSelected:room1];
}

-(void)roomSelected:(UIButton *) button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    if ([button isEqual:self.roomButton1])
    {
        self.checkImageView1.hidden = NO;
    }
    else
    {
        self.checkImageView1.hidden = YES;
    }
    
    if ([button isEqual:self.roomButton2])
    {
        self.checkImageView2.hidden = NO;
    }
    else
    {
        self.checkImageView2.hidden = YES;
    }

    if ([button isEqual:self.roomButton3])
    {
        self.checkImageView3.hidden = NO;
    }
    else
    {
        self.checkImageView3.hidden = YES;
    }
    
    if ([button isEqual:self.roomButton4])
    {
        self.checkImageView4.hidden = NO;
    }
    else
    {
        self.checkImageView4.hidden = YES;
    }
    
    self.roomIP = @"192.168.11.9";
    
    if ([self.selectedButton isEqual:self.roomButton1])
    {
        self.roomIP = @"192.168.11.9";
    }
    
    if ([self.selectedButton isEqual:self.roomButton2])
    {
        self.roomIP = @"192.168.11.6";
    }
    
    if ([self.selectedButton isEqual:self.roomButton3])
    {
        self.roomIP = @"192.168.10.8";
    }
    
    if ([self.selectedButton isEqual:self.roomButton4])
    {
        self.roomIP = @"192.168.10.15";
    }
    
}

-(void)topCancel
{
    self.hidden = YES;
}

-(void)topSure
{
    if ([self.delegete respondsToSelector:@selector(topSure:)])
    {
        [self.delegete topSure:self.roomIP];
    }
    self.hidden = YES;
}

-(void)bottomSure
{
    if ([self.delegete respondsToSelector:@selector(bottomSure:)])
    {
        [self.delegete bottomSure:self.roomIP];
    }
    
    self.hidden = YES;
}

@end
