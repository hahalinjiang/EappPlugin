//
//  PDCameraScanViewController.m
//  DiErZhouKaoShi
//
//  Created by 裴铎 on 2018/7/16.
//  Copyright © 2018年 裴铎. All rights reserved.
//

#import "PDCameraScanViewController.h"

#import "PDCameraScanView.h"//扫描界面头文件
#import <AVFoundation/AVFoundation.h>  //引用AVFoundation框架

@interface PDCameraScanViewController ()<
AVCaptureMetadataOutputObjectsDelegate> //遵守AVCaptureMetadataOutputObjectsDelegate协议
@property ( strong , nonatomic ) AVCaptureDevice * device; //捕获设备，默认后置摄像头
@property ( strong , nonatomic ) AVCaptureDeviceInput * input; //输入设备
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;//输出设备，需要指定他的输出类型及扫描范围
@property ( strong , nonatomic ) AVCaptureSession * session; //AVFoundation框架捕获类的中心枢纽，协调输入输出设备以获得数据
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * previewLayer;//展示捕获图像的图层，是CALayer的子类
@property (nonatomic,strong)UIView *scanView;//定位扫描框在哪个位置

@end

@implementation PDCameraScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //屏幕的宽度
    CGFloat kScreen_Width = [UIScreen mainScreen].bounds.size.width;
    
    //定位扫描框在屏幕正中央，并且宽高为200的正方形
    self.scanView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width-200)/2, (self.view.frame.size.height-200)/2, 200, 200)];
    [self.view addSubview:self.scanView];
    
    //设置扫描界面（包括扫描界面之外的部分置灰，扫描边框等的设置）,后面设置
    PDCameraScanView *clearView = [[PDCameraScanView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:clearView];
    
    //初始化并启动扫描
    [self startScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 开始扫描
 */
- (void)startScan
{
    // 1.判断输入能否添加到会话中
    if (![self.session canAddInput:self.input]) return;
    [self.session addInput:self.input];
    
    
    // 2.判断输出能够添加到会话中
    if (![self.session canAddOutput:self.output]) return;
    [self.session addOutput:self.output];
    
    // 4.设置输出能够解析的数据类型
    // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
    //设置availableMetadataObjectTypes为二维码、条形码等均可扫描，如果想只扫描二维码可设置为
    // [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    
    // 5.设置监听监听输出解析到的数据
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 6.添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.frame = self.view.bounds;
    
    // 8.开始扫描
    [self.session startRunning];
    
    [self initButton];
    
}

-(void) initButton{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIView* g_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, 80)];
    g_view.backgroundColor = [UIColor colorWithRed:40.0/255 green:40.0/255 blue:40.0/255 alpha:1];
    g_view.alpha = 0.5;
    [self.view addSubview:g_view];
    
    UILabel* g_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, size.width, 40)];
    g_label.backgroundColor = [UIColor clearColor];
    g_label.textColor = [UIColor whiteColor];
    g_label.text = @"扫一扫";
    g_label.textAlignment = NSTextAlignmentCenter;
    g_label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:g_label];
    
    UIButton* g_button = [[UIButton alloc]initWithFrame:CGRectMake(10, 20+5, 30, 30)];
    g_button.backgroundColor = [UIColor clearColor];
    [g_button setImage:[UIImage imageNamed:@"scanback"] forState:UIControlStateNormal];
    [g_button addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:g_button];
    
  
    
    
    g_view = [[UIView alloc]initWithFrame:CGRectMake(0, size.height-80, size.width, 80)];
    g_view.backgroundColor = [UIColor colorWithRed:40.0/255 green:40.0/255 blue:40.0/255 alpha:1];
    g_view.alpha = 0.5;
    [self.view addSubview:g_view];
    
    g_button = [[UIButton alloc]initWithFrame:CGRectMake(10, size.height-60+5, 30, 30)];
    g_button.backgroundColor = [UIColor clearColor];
     [g_button setImage:[UIImage imageNamed:@"sacnlightOff"] forState:UIControlStateNormal];
    [g_button addTarget:self action:@selector(taplLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:g_button];
    
    g_button = [[UIButton alloc]initWithFrame:CGRectMake(size.width-40, size.height-60+5, 30, 30)];
    g_button.backgroundColor = [UIColor clearColor];
    [g_button setImage:[UIImage imageNamed:@"sacnImage"] forState:UIControlStateNormal];
    [g_button addTarget:self action:@selector(choicePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:g_button];
    
}

-(void)tapBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)taplLight:(UIButton*)sender
{
     Class captureDeviceClass =NSClassFromString(@"AVCaptureDevice");
    if(captureDeviceClass !=nil) {
        AVCaptureDevice*device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if(sender.tag==0) {
                sender.tag=1;
                [device setTorchMode:AVCaptureTorchModeOn];//手电筒开
                 [sender setImage:[UIImage imageNamed:@"scanlightOn"] forState:UIControlStateNormal];
            }else{
                sender.tag=0;
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
                 [sender setImage:[UIImage imageNamed:@"sacnlightOff"] forState:UIControlStateNormal];
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
     }
}


/**
 扫描结束回调
 下面是接收扫描结果的代理AVCaptureMetadataOutputObjectsDelegate:
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning];   //停止扫描
    //我们捕获的对象可能不是AVMetadataMachineReadableCodeObject类，所以要先判断，不然会崩溃
    if (![[metadataObjects lastObject] isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        [self.session startRunning];
        return;
    }
    // id 类型不能点语法,所以要先去取出数组中对象
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
    if ( object.stringValue == nil ){
        [self.session startRunning];
    }
     self.complete(object.stringValue);
//    UIAlertController* g_alert = [UIAlertController alertControllerWithTitle:@"结果" message:object.stringValue preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//
//    }];
//    [g_alert addAction:okaction];
//
//    [self presentViewController:g_alert animated:YES completion:NULL];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"扫描结束了 %@",object);
    
}

/**
 调用相册
 */
- (void)choicePhoto{
    //调用相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //UIImagePickerControllerSourceTypePhotoLibrary为相册
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置代理UIImagePickerControllerDelegate和UINavigationControllerDelegate
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//选中图片的回调
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    [self initImageView:pickImage picker:picker];
    
}

-(void)initImageView:(UIImage*)image picker:(UIImagePickerController*)picker{
       self.m_image = image;
        CGSize size = [UIScreen mainScreen].bounds.size;
        self.m_imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.m_imageView.backgroundColor = [UIColor blackColor];
        self.m_imageView.userInteractionEnabled = YES;
        self.m_imageView.contentMode = UIViewContentModeScaleAspectFit;
        [picker.view addSubview:self.m_imageView];
    
     UIView* g_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, 80)];
     g_view.backgroundColor = [UIColor colorWithRed:40.0/255 green:40.0/255 blue:40.0/255 alpha:1];
     g_view.alpha = 0.5;
     [self.m_imageView addSubview:g_view];
    
     UILabel* g_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, size.width, 40)];
     g_label.backgroundColor = [UIColor clearColor];
      g_label.textColor = [UIColor whiteColor];
     g_label.text = @"图片";
     g_label.textAlignment = NSTextAlignmentCenter;
     g_label.font = [UIFont systemFontOfSize:16];
     [self.m_imageView addSubview:g_label];
    
        UIButton* g_button = [[UIButton alloc]initWithFrame:CGRectMake(10, 20+8, 24, 24)];
        g_button.backgroundColor = [UIColor clearColor];
         [g_button setImage:[UIImage imageNamed:@"scanImageClose"] forState:UIControlStateNormal];
        [g_button addTarget:self action:@selector(tapImageBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.m_imageView addSubview:g_button];
    
    
        
        g_button = [[UIButton alloc]initWithFrame:CGRectMake(size.width-34, 20+8, 24, 24)];
        g_button.backgroundColor = [UIColor clearColor];
        [g_button setImage:[UIImage imageNamed:@"scanImageSure"] forState:UIControlStateNormal];
        [g_button addTarget:self action:@selector(tapsure:) forControlEvents:UIControlEventTouchUpInside];
        [self.m_imageView addSubview:g_button];
        
    
        self.m_imageView.image =image;
    
}

-(void)tapImageBack:(id)sender{
 
    [self.m_imageView removeFromSuperview];
    
}

-(void)tapsure:(id)sender{
    NSData *imageData = UIImagePNGRepresentation(self.m_image);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //创建探测器
    //CIDetectorTypeQRCode表示二维码，这里选择CIDetectorAccuracyLow识别速度快
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray *feature = [detector featuresInImage:ciImage];
    
    //取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        NSString *content = result.messageString;// 这个就是我们想要的值
        self.complete(content);
        
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 懒加载

//下面初始化AVCaptureSession和AVCaptureVideoPreviewLayer:
- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (_previewLayer == nil) {
        //负责图像渲染出来
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

/**
 这里设置输出设备要注意rectOfInterest属性的设置，一般默认是CGRect(x: 0, y: 0, width: 1, height: 1),
 全屏都能读取的，但是读取速度较慢。
 注意rectOfInterest属性的传人的是比例。
 比例是根据扫描容器的尺寸比上屏幕尺寸（注意要计算的时候要计算导航栏高度，有的话需减去）。
 参照的是横屏左上角的比例，而不是竖屏。
 所以我们再设置的时候要调整方向如下面所示。
 */
- (AVCaptureMetadataOutput *)output{
    if (_output == nil) {
        //初始化输出设备
        _output = [[AVCaptureMetadataOutput alloc] init];
        
        // 1.获取屏幕的frame
        CGRect viewRect = self.view.frame;
        // 2.获取扫描容器的frame
        CGRect containerRect = self.scanView.frame;
        
        CGFloat x = containerRect.origin.y / viewRect.size.height;
        CGFloat y = containerRect.origin.x / viewRect.size.width;
        CGFloat width = containerRect.size.height / viewRect.size.height;
        CGFloat height = containerRect.size.width / viewRect.size.width;
        //rectOfInterest属性设置设备的扫描范围
        _output.rectOfInterest = CGRectMake(x, y, width, height);
    }
    return _output;
    
    /**网上还有一种是根据AVCaptureInputPortFormatDescriptionDidChangeNotification通知设置的，也是可行的，自选一种即可
     __weak typeof(self) weakSelf = self;
     [[NSNotificationCenter defaultCenter]addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification * _Nonnull note) {
     if (weakSelf){
     //调整扫描区域
     AVCaptureMetadataOutput *output = weakSelf.session.outputs.firstObject;
     output.rectOfInterest = [weakSelf.previewLayer metadataOutputRectOfInterestForRect:weakSelf.scanView.frame];
     }
     }];*/
}


- (AVCaptureDevice *)device{
    if (_device == nil) {
        // 设置AVCaptureDevice的类型为Video类型
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input{
    if (_input == nil) {
        //输入设备初始化
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

@end
