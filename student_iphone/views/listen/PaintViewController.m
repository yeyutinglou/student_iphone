//
//  PaintViewController.m
//  student_ipad
//
//  Created by nsc on 15/1/18.
//  Copyright (c) 2015年 leon. All rights reserved.
//

#import "PaintViewController.h"
#import "AppDelegate.h"
#import "SocketData.h"
#import "AFNetworking.h"
#import "NSObject+Extension.h"
#import "UIView+Border.h"
#import "UIImageView+WebCache.h"
#import "DataUtils.h"

@interface PaintViewController ()
{
    CGPoint MyBeganpoint;
    CGPoint MyMovepoint;
    int Segment;
    int SegmentWidth;
    UIImageView* pickImage;
    UIView* colorView;
    UIImageView* colorBackImgView;
    UIView* widthView;
    UIImageView* widthBackImgView;
    
    UISegmentedControl* WidthButton;
    UISegmentedControl* ColorButton;
    UISegmentedControl* earseSegControl;
    
    NSMutableArray* pointArray;
    
    UIImage *tempImage;
    
    //add by zhaojian
    UIImageView *stuTempImgView;
}

@end

@implementation PaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.openBt.hidden = YES;
   
    self.view.clipsToBounds = YES;
    //self.paintBt.layer.cornerRadius = 4.0;
    self.backView.hidden = NO;
    SegmentWidth = 2;
    pointArray = [[NSMutableArray alloc] init];
    
    PaintView* aPaintView = [[PaintView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    aPaintView.backgroundColor = [UIColor whiteColor];
    self.paintView = aPaintView;
    [self.view insertSubview:aPaintView atIndex:0];
    
    _paintView.backgroundColor = [UIColor clearColor];
//    [self observeNotification:@"whiteBoard"];
//    [self showWhiteBoardDetail];
}


- (void)initPaitBoard{
    self.view.clipsToBounds = YES;
    //self.paintBt.layer.cornerRadius = 4.0;
    self.backView.hidden = YES;
    SegmentWidth = 2;
    pointArray = [[NSMutableArray alloc] init];
    _paintView.backgroundColor = [UIColor clearColor];
    self.openBt.hidden = NO;
}

- (void)showToolBar:(BOOL)status{
    _openBt.selected = !status;
    [self paintClick:_openBt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 图片处理

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"z");
    }
}


//- (void)dealloc
//{
//    [self unobserveNotification:@"whiteBoard"];
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.isWhiteBoardMode = NO;
//}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self unobserveNotification:@"whiteBoard"];
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.isWhiteBoardMode = NO;
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self observeNotification:@"whiteBoard"];
//    [self showWhiteBoardDetail];
//}

//ON_NOTIFICATION(notification){
//    if ([notification is:@"whiteBoard"]) {
//        NSMutableDictionary *dict = notification.object;
//        _infoDic = dict[@"info"];
//        _subDic = dict[@"subject"];
//        //_infoDic = notification.object;
//        [self showWhiteBoardDetail];
//    }
//}

- (void)clearBg{
    _paintView.backgroundColor = [UIColor clearColor];
}


- (void)showWhiteBoardDetail:(PaintViewController *) paintVc{
    if (!self.paintView)
    {
        SegmentWidth = 2;
        
        //comment by zhaojian 2015-12-28
        //float boardWidth   =  ((NSNumber*)_subDic[@"viewWidth"]).floatValue;
        //float boardHeight  =  ((NSNumber*)_subDic[@"viewHeight"]).floatValue;
        //PaintView* aPaintView = [[PaintView alloc] initWithFrame:CGRectMake((1024 - boardWidth)/2.0, (768 - boardHeight)/2.0, boardWidth, boardHeight)];
        
        //add by zhaojian 2015-12-28
        PaintView* aPaintView = [[PaintView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
        aPaintView.backgroundColor = [UIColor whiteColor];
        self.paintView = aPaintView;
        [self.view insertSubview:aPaintView atIndex:0];
    }
    if (!_infoDic || [_infoDic isKindOfClass:[NSString class]] || _infoDic.count==0) {
        return;
    }
    
    NSNumber* actNum = _infoDic[@"action"];
    JYDLog(@"infoDic = %@",_infoDic);
    
    /**
     *  白板的操作 1:上一步; 2:下一步;3:删除整个屏幕; 4:插入图片
     */
    if (actNum.integerValue == 1) {
        [self.paintView myLineFinallyRemove];
    }
    if (actNum.integerValue == 2) {
        [self.paintView recoveryFinallyLine];
    }
    if (actNum.integerValue == 3) {
         [self.paintView myalllineclear];
        //add by zhaojian
        [paintVc clearBg];
        [paintVc.paintView myalllineclear];
        for (UIImageView *imageView in paintVc.paintView.subviews) {
            [imageView removeFromSuperview];
        }
    }
    if (actNum.integerValue == 4) {
        NSDictionary* imgDic = _infoDic[@"serBitmap"];
        float x      = ((NSNumber* )imgDic[@"startX"]).floatValue;
        float y      = ((NSNumber* )imgDic[@"startY"]).floatValue;
        float width  = ((NSNumber* )imgDic[@"bitmapWidth"]).floatValue;
        float height = ((NSNumber* )imgDic[@"bitmapHeight"]).floatValue;
        NSString* imgStr = imgDic[@"bitmapBase64"];
        NSData *decodedImageData   = [[NSData alloc] initWithBase64EncodedString:imgStr options:1];
        UIImage *decodedImage      = [UIImage imageWithData:decodedImageData];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        imageView.image = decodedImage;
        stuTempImgView = imageView;
        //comment by zhaojian
        //[self.paintView insertSubview:imageView atIndex:2];
        
        //add by zhaojian
        decodedImage.userInfo= [NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromCGRect(CGRectMake(x, y, width, height)),@"frame", nil];
        [self.paintView addImage:decodedImage];

        //imageView.alpha = 0.8;
    }
    if (actNum.intValue == 5) {
        NSMutableDictionary* traDic = _infoDic[@"trajectory"];
        int viewWidthTea  = ((NSNumber* )_infoDic[@"viewWidth"]).intValue;
        int viewHeightTea = ((NSNumber* )_infoDic[@"viewHeight"]).intValue+70;
        if (viewWidthTea == 0 || viewHeightTea == 0)
        {
            viewWidthTea  = 1024;
            viewHeightTea = 700;
        }

        JYDLog(@"===================%@",traDic);
        if (traDic) {
            Segment = ((NSNumber* )traDic[@"colorHex"]).intValue;
            
            //add by zhaojian 2015-12-28
           
            
            
            NSString* lineMode = traDic[@"lineMode"];
            if ([lineMode isEqualToString:@"default_line"]) {
                //Segment = 1;
            }else if ([lineMode isEqualToString:@"erase_line"]){
                Segment = 6;
            }
            SegmentWidth = ((NSNumber* )traDic[@"trajectoryWidth"]).intValue;
            [self.paintView Introductionpoint4:Segment];
            [self.paintView Introductionpoint5:SegmentWidth];
            [self.paintView Introductionpoint1];
            NSMutableArray* pointArray2 = traDic[@"serPointFs"];
            for(NSString* pointStr in pointArray2){
                CGPoint point = CGPointFromString(pointStr);
                
                 //add by zhaojian 2015-12-28
                point.x = point.x * (kWidth/viewWidthTea);
                point.y = point.y * ((kHeight -64)/viewHeightTea);
                
                [self.paintView Introductionpoint3:point];
            }
            [self.paintView Introductionpoint2];
            [self.paintView setNeedsDisplay];
        }
    }
}
- (IBAction)paintClick:(UIButton* )btn;
{
    if (btn.selected) {
        self.backView.hidden = YES;
    }else{
        self.backView.hidden = NO;
    }
    btn.selected = !btn.selected;
    [colorView removeFromSuperview];
    colorView = nil;
    [widthView removeFromSuperview];
    widthView = nil;
    self.colorBt.selected = NO;
    self.widthBt.selected = NO;
    self.deleteBt.selected = NO;
    self.eraseBt.selected = NO;
}

//撤销
-(IBAction)LineFinallyRemove
{
    [self.paintView myLineFinallyRemove];
    
    /*
     *socket发送轨迹
     *action==1
     */
    if ([_teamLabel isEqualToString:@""]) {
        return;
    }
    NSDictionary* subDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"cmd",_teamLabel,@"teamLabel",_stuId,@"stuId",nil];
    NSMutableDictionary* infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"action",nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"STATUS",@"6",@"FLAG",subDic,@"SUBJECT",infoDic,@"INFO",nil];
    [[SocketData sharedInstance] sendSocketData:dict];
//    if (_dictResource) {
//        [_dictResource setObject:infoDic forKey:@"INFO"];
//        [[SocketData sharedInstance] sendSocketData:_dictResource];
//    }
//    else
//        [[SocketData sharedInstance] sendSocketData:dict];
}
//回退
- (IBAction)recoveryFinallyLine:(id)sender
{
    [self.paintView recoveryFinallyLine];
    if ([_teamLabel isEqualToString:@""]) {
        return;
    }
    NSDictionary* subDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"cmd",_teamLabel,@"teamLabel",_stuId,@"stuId",nil];
    NSMutableDictionary* infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"action",nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"STATUS",@"6",@"FLAG",subDic,@"SUBJECT",infoDic,@"INFO",nil];
    [[SocketData sharedInstance] sendSocketData:dict];
//    if (_dictResource) {
//        [_dictResource setObject:infoDic forKey:@"INFO"];
//        [[SocketData sharedInstance] sendSocketData:_dictResource];
//    }
//    else
//        [[SocketData sharedInstance] sendSocketData:dict];
}
//颜色
-(IBAction)myAllColor:(UIButton* )btn
{
    self.widthBt.selected = NO;
    self.eraseBt.selected = NO;
    self.deleteBt.selected = NO;
    if (btn.selected) {
        [colorView removeFromSuperview];
        colorView = nil;
    }else{
        [widthView removeFromSuperview];
        widthView = nil;
        NSArray* colorArray=[[NSArray alloc] initWithObjects:@"colour_yellow",@"colour_pink",@"colour_blue",@"colour_black",@"colour_green",@"colour_red",nil];
        NSArray* colorSelectArray=[[NSArray alloc] initWithObjects:@"colour_yellow_select",@"colour_pink_select",@"colour_blue_select",@"colour_black_select",@"colour_green_select",@"colour_red_select",nil];

        if (!colorView) {
            colorView = [[UIView alloc] initWithFrame:CGRectMake(683, 510, 198/2.0, 282/2.0)];
            [self.paintView addSubview:colorView];
            
            colorBackImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_color.png"]];
            colorBackImgView.frame = CGRectMake(0, 0, 198/2.0, 282/2.0);
            [colorView addSubview:colorBackImgView];
            
            for(int i=0;i < 3;i++){
                for(int j=0;j < 2;j++){
                    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
                    [bt addTarget:self action:@selector(ColorButton:) forControlEvents:UIControlEventTouchUpInside];
                    bt.tag = i*2+j;
                    NSString* colorStr = [colorArray objectAtIndex:i*2+j];
                    NSString* colorSelectedStr = [colorSelectArray objectAtIndex:i*2+j];
                    [bt setBackgroundImage:[UIImage imageNamed:colorStr] forState:UIControlStateNormal];
                    [bt setBackgroundImage:[UIImage imageNamed:colorSelectedStr] forState:UIControlStateSelected];
                    bt.frame = CGRectMake(10+j*198/4.0, i*282/6.0, 70./2., 70./2.);
                    [colorView addSubview:bt];
                }
            }
        }
        [self.paintView addSubview:colorView];
    }
    btn.selected = !btn.selected;
}
//宽度
-(IBAction)myAllWidth:(UIButton* )btn
{
    self.colorBt.selected = NO;
    self.eraseBt.selected = NO;
    self.deleteBt.selected = NO;
    if (btn.selected) {
        [widthView removeFromSuperview];
        widthView = nil;
    }else{
        [colorView removeFromSuperview];
        colorView = nil;
        NSArray* widthArray = [[NSArray alloc] initWithObjects:@"big-pen",@"normal_pen",@"small-pen",nil];
        NSArray* widthSelectArray =[[NSArray alloc] initWithObjects:@"big-pen-selected",@"normal-pen-selected",@"small-pen-selected",nil];
        if (!widthView) {
            widthView = [[UIView alloc] initWithFrame:CGRectMake(750, 510, 198/2.0, 282/2.0)];
            [self.paintView addSubview:widthView];
            
            widthBackImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_color.png"]];
            widthBackImgView.frame = CGRectMake(0, 0, 198/2.0, 282/2.0);
            [widthView addSubview:widthBackImgView];
            
            for(int i=0;i < 3;i++){
                UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
                [bt addTarget:self action:@selector(widthButton:) forControlEvents:UIControlEventTouchUpInside];
                bt.tag = 8 - i*3;
                NSString* colorStr = [widthArray objectAtIndex:i];
                NSString* colorSelectStr = [widthSelectArray objectAtIndex:i];
                [bt setBackgroundImage:[UIImage imageNamed:colorStr] forState:UIControlStateNormal];
                [bt setBackgroundImage:[UIImage imageNamed:colorSelectStr] forState:UIControlStateSelected];
                bt.frame = CGRectMake(38, 10+i*282/6.0, 52./2., 52./2.);
                [widthView addSubview:bt];
            }
        }
        [self.paintView addSubview:WidthButton];
     }
     btn.selected = !btn.selected;
}
//橡皮
-(IBAction)myRubberSeraser:(UIButton* )btn
{
    [colorView removeFromSuperview];
    colorView = nil;
    [widthView removeFromSuperview];
    widthView = nil;
    self.colorBt.selected = NO;
    self.widthBt.selected = NO;
    self.deleteBt.selected = NO;
    Segment=6;
    SegmentWidth = 20;
     btn.selected = !btn.selected;
}
//清屏
-(IBAction)myPalttealllineclear:(UIButton* )btn
{
    [colorView removeFromSuperview];
    colorView = nil;
    [widthView removeFromSuperview];
    widthView = nil;
    self.colorBt.selected = NO;
    self.widthBt.selected = NO;
    self.eraseBt.selected = NO;
    [self.paintView myalllineclear];
     btn.selected = !btn.selected;
    if ([_teamLabel isEqualToString:@""]) {
        return;
    }
    NSDictionary* subDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"cmd",_teamLabel,@"teamLabel",_stuId,@"stuId",nil];
    NSMutableDictionary* infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"action",nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"STATUS",@"6",@"FLAG",subDic,@"SUBJECT",infoDic,@"INFO",nil];
    [[SocketData sharedInstance] sendSocketData:dict];
//    if (_dictResource) {
//        [_dictResource setObject:infoDic forKey:@"INFO"];
//        [[SocketData sharedInstance] sendSocketData:_dictResource];
//    }
//    else
//        [[SocketData sharedInstance] sendSocketData:dict];
}
-(void)ColorButton:(UIButton* )btn
{
    for(UIView* aView in colorView.subviews){
        if ([aView isKindOfClass:[UIButton class]]) {
            UIButton* bt = (UIButton* )aView;
            bt.selected = NO;
        }
    }
    btn.selected = !btn.selected;
    Segment = (int)btn.tag;
    NSLog(@"seg = %d",Segment);
}
-(void)widthButton:(UIButton* )btn
{
    for(UIView* aView in widthView.subviews){
        if ([aView isKindOfClass:[UIButton class]]) {
            UIButton* bt = (UIButton* )aView;
            bt.selected = NO;
        }
    }
    btn.selected = !btn.selected;
    SegmentWidth = (int)btn.tag;
}
-(IBAction)callCame
{
    //指定图片来源
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    //判断如果摄像机不能用图片来源与图片库
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    //前后摄像机
    //picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
    picker.allowsEditing=NO;
    picker.sourceType=sourceType;
    [self.parentViewController presentViewController:picker animated:YES completion:^(void){
    
    }];

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //返回原来界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    //
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    if(image.size.width > 960)
    {
        image = [DataUtils scaleImage:image toScale:960/image.size.width];
    }
    //延时
    tempImage = image;
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
    
}
//按取消键时
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//保存图片
-(void)saveImage:(UIImage *)image
{
    _backView.backgroundColor = [UIColor clearColor];
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 700)];
    backView.tag = 528;
    [self.paintView addSubview:backView];
    if (pickImage!=nil)
    {
        [pickImage removeFromSuperview];
        pickImage.image = image;
        //[pickImage initWithImage:image];
        pickImage.userInteractionEnabled = YES;
        pickImage.frame=CGRectMake(40, 200, 400, 400*image.size.height/image.size.width);
        
        [self.view insertSubview:pickImage belowSubview:_backView];
        
        //[self.paintView sendSubviewToBack:pickImage];//添加到最后一层
        //self.paintView.backgroundColor=[UIColor clearColor];
        //self.paintView.alpha=0;
        //[self.paintView addSubview:pickImage];
    }
    else
    {
        pickImage=[[UIImageView alloc] initWithImage:image];
        pickImage.frame=CGRectMake(40, 200, 400, 400*image.size.height/image.size.width);
        pickImage.userInteractionEnabled = YES;
        [self.view insertSubview:pickImage belowSubview:_backView];
        //[self.paintView sendSubviewToBack:pickImage];//添加到最后一层
        //self.paintView.backgroundColor=[UIColor clearColor];
        //self.paintView.alpha=0;
        ///[self.paintView addSubview:pickImage];
    }
    
    for(UIView* aview in self.view.subviews){
        if ([aview isKindOfClass:[UIImageView class]]) {
            // 缩放手势
            UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
            [aview addGestureRecognizer:pinchGestureRecognizer];
            
            // 移动手势
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
            [aview addGestureRecognizer:panGestureRecognizer];
        }
    }
    
//    if (pickImage!=nil)
//    {
//        [pickImage removeFromSuperview];
//        [pickImage initWithImage:sender];
//        pickImage.frame=CGRectMake(40, 40, 200, 200);
//        
//        [self.paintView insertSubview:pickImage atIndex:2];
//        //[self.paintView sendSubviewToBack:pickImage];//添加到最后一层
//        //self.paintView.backgroundColor=[UIColor clearColor];
//        //self.paintView.alpha=0;
//        //[self.paintView addSubview:pickImage];
//    }
//    else 
//    {
//        pickImage=[[UIImageView alloc] initWithImage:sender];
//        pickImage.frame=CGRectMake(40, 40, 200, 200);
//        
//        [self.paintView insertSubview:pickImage atIndex:2];
//        //[self.paintView sendSubviewToBack:pickImage];//添加到最后一层
//        //self.paintView.backgroundColor=[UIColor clearColor];
//        //self.paintView.alpha=0;
//        ///[self.paintView addSubview:pickImage];
//    }
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [colorView removeFromSuperview];
//    colorView = nil;
//    [widthView removeFromSuperview];
//    widthView = nil;
//    self.colorBt.selected = NO;
//    self.widthBt.selected = NO;
//    self.deleteBt.selected = NO;
//    UITouch* touch=[touches anyObject];
//    MyBeganpoint=[touch locationInView:self.paintView ];
//    
//    [self.paintView Introductionpoint4:Segment];
//    [self.paintView Introductionpoint5:SegmentWidth];
//    [self.paintView Introductionpoint1];
//    [self.paintView Introductionpoint3:MyBeganpoint];
//    
//    NSLog(@"======================================");
//    NSLog(@"MyPalette Segment=%i",Segment);
//}
////手指移动时候发出
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSArray* MovePointArray=[touches allObjects];
//    MyMovepoint=[[MovePointArray objectAtIndex:0] locationInView:self.paintView];
//    [self.paintView Introductionpoint3:MyMovepoint];
//    [self.paintView setNeedsDisplay];
//}
////当手指离开屏幕时候
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.paintView Introductionpoint2];
//    [self.paintView setNeedsDisplay];
//}
////电话呼入等事件取消时候发出
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //NSLog(@"touches Canelled");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
    if ([self.paintView viewWithTag:528]) {
        CGPoint pt = [touch locationInView:self.view];
        if (CGRectContainsPoint(pickImage.frame,pt)) {
            //NSLog(@"dddddd");
        }
        else{
            //_paintView.userInteractionEnabled = YES;
            
            tempImage.userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromCGRect(pickImage.frame),@"frame", nil];//{@"frame":pickImage.frame};
            //NSLog(@"eeeeee");
            [_paintView addImage:tempImage];
            
            if (![_teamLabel isEqualToString:@""]) {
                NSDictionary* subDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"cmd",_teamLabel,@"teamLabel",_stuId,@"stuId",nil];
                NSData *data = UIImageJPEGRepresentation(tempImage, 0.6f);
                NSString *encodedImageStr = [data base64EncodedStringWithOptions:1];
                NSMutableDictionary* imgDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:encodedImageStr,@"bitmapBase64",[NSNumber numberWithFloat:pickImage.frame.origin.x],@"startX",[NSNumber numberWithFloat:pickImage.frame.origin.y],@"startY",[NSNumber numberWithFloat:pickImage.frame.size.width],@"bitmapWidth",[NSNumber numberWithFloat:pickImage.frame.size.height],@"bitmapHeight", nil];
                NSLog(@"img = %@",imgDic);
                NSMutableDictionary* infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:4],@"action",@"",@"trajectory",imgDic,@"serBitmap",nil];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"STATUS",@"6",@"FLAG",@"1080",@"id",subDic,@"SUBJECT",infoDic,@"INFO",nil];
                [[SocketData sharedInstance] sendSocketData:dict];
            }
           
            //[[SocketData sharedInstance] sendSocketData:dict];
//            if (_dictResource) {
//                [_dictResource setObject:infoDic forKey:@"INFO"];
//                [[SocketData sharedInstance] sendSocketData:_dictResource];
//            }
//            else
//                [[SocketData sharedInstance] sendSocketData:dict];
            
            //[pickImage removeFromSuperview];
            [[self.paintView viewWithTag:528] removeFromSuperview];
        }
        return;
    }
    //    if (!_paintView.userInteractionEnabled) {
    //        CGPoint pt = [touch locationInView:self.view];
    //        if (CGRectContainsPoint(pickImage.frame,pt)) {
    //            //NSLog(@"dddddd");
    //        }
    //        else{
    //            //_paintView.userInteractionEnabled = YES;
    //
    //            tempImage.userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromCGRect(pickImage.frame),@"frame", nil];//{@"frame":pickImage.frame};
    //            //NSLog(@"eeeeee");
    //            [_paintView addImage:tempImage];
    //            [pickImage removeFromSuperview];
    //            [_paintView performSelector:@selector(setUserInteractionEnabled:) withObject:@YES afterDelay:1];
    //        }
    //        return;
    //    }
    [colorView removeFromSuperview];
    colorView = nil;
    [widthView removeFromSuperview];
    widthView = nil;
    self.colorBt.selected = NO;
    self.widthBt.selected = NO;
    self.deleteBt.selected = NO;
    
    CGPoint point =[touch locationInView:self.paintView ];
    [pointArray addObject:NSStringFromCGPoint(point)];
    
    [self.paintView Introductionpoint4:Segment];
    [self.paintView Introductionpoint5:SegmentWidth];
    [self.paintView Introductionpoint1];
    [self.paintView Introductionpoint3:point];
    
    NSLog(@"======================================");
    NSLog(@"MyPalette Segment=%i",Segment);
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    if (!_paintView.userInteractionEnabled) {
    //        return;
    //    }
    if ([self.paintView viewWithTag:528]) {
        return;
    }
    NSArray* MovePointArray=[touches allObjects];
    CGPoint point =[[MovePointArray objectAtIndex:0] locationInView:self.paintView];
    [pointArray addObject:NSStringFromCGPoint(point)];
    [self.paintView Introductionpoint3:point];
    [self.paintView setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    if (!_paintView.userInteractionEnabled) {
    //        return;
    //    }
    if ([self.paintView viewWithTag:528]) {
        return;
    }
    
    if (!pointArray) {
        pointArray = [[NSMutableArray alloc] init];
    }
    
    NSArray* MovePointArray=[touches allObjects];
    CGPoint point =[[MovePointArray objectAtIndex:0] locationInView:self.paintView];
    [pointArray addObject:NSStringFromCGPoint(point)];
    [self.paintView Introductionpoint3:point];
    [self.paintView Introductionpoint2];
    NSLog(@"pointArray = %@",pointArray);
    /*
     *socket发送轨迹
     *action==5
     */
    if (![_teamLabel isEqualToString:@""]) {
        NSDictionary* subDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"cmd",_teamLabel,@"teamLabel",_stuId,@"stuId",nil];
        NSMutableDictionary* trDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Segment],@"colorHex",Segment==6?@"erase_line":@"default_line",@"lineMode",pointArray,@"serPointFs",[NSNumber numberWithInt:SegmentWidth],@"trajectoryWidth",nil];
        NSMutableDictionary* infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:5],@"action",trDic,@"trajectory",@"",@"serBitmap",nil];
        NSLog(@"%@",[subDic JSONString]);
        NSLog(@"%@",[trDic JSONString]);
        NSLog(@"%@",[infoDic JSONString]);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"STATUS",@"6",@"FLAG",subDic,@"SUBJECT",infoDic,@"INFO",nil];
        [[SocketData sharedInstance] sendSocketData:dict];
    }
//    if (_dictResource) {
//        [_dictResource setObject:infoDic forKey:@"INFO"];
//        [[SocketData sharedInstance] sendSocketData:_dictResource];
//    }
//    else
//        [[SocketData sharedInstance] sendSocketData:dict];
    //[[SocketData sharedInstance] sendSocketData:dict];
    [pointArray removeAllObjects];
    [self.paintView setNeedsDisplay];
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touches Canelled");
}


@end
