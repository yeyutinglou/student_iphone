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
//  FindPasswordSuccessBoard.m
//  Walker
//
//  Created by he chao on 3/12/14.
//    Copyright (c) 2014 leon. All rights reserved.
//

#import "FindPasswordSuccessBoard.h"

#pragma mark -

@implementation FindPasswordSuccessBoard
DEF_SIGNAL(RESEND)

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.view.backgroundColor = RGB(242, 242, 242);
        self.title = @"找回密码";
        
        [self loadContent];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( FindPasswordSuccessBoard, signal )
{
    if ([signal is:FindPasswordSuccessBoard.RESEND]) {
        
    }
}

- (void)loadContent{
    BaseLabel *lb1 = [BaseLabel initLabel:@"短信已发送" font:BOLDFONT(30) color:RGB(110, 197, 48) textAlignment:NSTextAlignmentCenter];
    lb1.frame = CGRectMake(0, 64+30, self.viewWidth, 30);
    [self.view addSubview:lb1];
    
    BaseLabel *lb2 = [BaseLabel initLabel:@"请您按照短信中的相关说明进行操作。" font:FONT(15) color:RGB(30, 30, 30) textAlignment:NSTextAlignmentCenter];
    lb2.frame = CGRectMake(0, lb1.bottom+20, self.viewWidth, 20);
    [self.view addSubview:lb2];
    
    BeeUIImageView *imgLine = [BeeUIImageView spawn];
    imgLine.frame = CGRectMake(15, lb2.bottom+30, self.viewWidth-30, 1);
    imgLine.backgroundColor = lb1.textColor;
    [self.view addSubview:imgLine];
    
    BaseLabel *lb3 = [BaseLabel initLabel:@"没有收到短信？\n\n1.请再次确认您的收件箱中是否有;\n\n2.如果您仍找不到短信，请点击" font:FONT(12) color:RGB(114, 114, 114) textAlignment:NSTextAlignmentLeft];
    lb3.numberOfLines = 0;
    lb3.frame = CGRectMake(37, imgLine.bottom+15, 185, 80);
    [self.view addSubview:lb3];
    
    BaseLabel *lb4 = [BaseLabel initLabel:@"重新发送" font:BOLDFONT(12) color:RGB(52, 212, 246) textAlignment:NSTextAlignmentLeft];
    [lb4 makeTappable:FindPasswordSuccessBoard.RESEND];
    lb4.frame = CGRectMake(lb3.right-15, lb3.bottom-23, self.viewWidth, 20);
    [self.view addSubview:lb4];
}

@end
