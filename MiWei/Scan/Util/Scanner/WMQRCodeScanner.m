//
//  WMQRCodeScanner.m
//  SinQRCodeKit
//
//  Created by Sin on 17/1/11.
//  Copyright © 2017年 Sin. All rights reserved.
//

#import "WMQRCodeScanner.h"
#import <AVFoundation/AVFoundation.h>

@interface WMQRCodeScanner ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,strong) UIViewController *scanViewController;
/** 会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation WMQRCodeScanner
+ (instancetype)sharedWMQRCodeScanner {
  static WMQRCodeScanner *scanner = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    scanner = [[self alloc]init];
  });
  return scanner;
}

#pragma mark - scanQRCodeWithCamera
- (void)scanQRCideWithCamera:(UIView *)scanView rectOfInterest:(CGRect)rect {
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    output.rectOfInterest = rect;
    
    // 5、初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 5.1 添加会话输入
    [_session addInput:input];
    
    // 5.2 添加会话输出
    [_session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = scanView.layer.bounds;
    
    // 8、将图层插入当前视图
    [scanView.layer insertSublayer:_previewLayer atIndex:0];
    
    // 9、启动会话
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  // 会频繁的扫描，调用代理方法
  
  // 1、如果扫描完成，停止会话
  [self.session stopRunning];
  
  // 2、删除预览图层
  [self.previewLayer removeFromSuperlayer];
  
  // 3、设置界面显示扫描结果
  NSMutableArray *results = [NSMutableArray array];
  for(int i=0;i<metadataObjects.count;i++){
    AVMetadataMachineReadableCodeObject *obj = metadataObjects[i];
    [results addObject:obj.stringValue];
  }
  [self dealDelegateSuccess:results];
}

#pragma mark - scanQRCodeWithAlbum
- (void)scanQRCodeWithAlbum:(UIViewController *)currentVC {
    if(!currentVC || ![currentVC isKindOfClass:[UIViewController class]]) {//如果数据为空或者是非法数据直接返回
        [self dealDelegateSuccess:[NSArray new]];
        return;
    }
    self.scanViewController = currentVC;

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
    imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
     // 显示相册
    [currentVC presentViewController:imagePicker animated:YES completion:nil];
  
}
#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
  __weak typeof(self) ws = self;
  [self.scanViewController dismissViewControllerAnimated:YES completion:^{
    [ws scanQRCodeFromCurrentImage:image];
  }];
}

/** 识别当前图片中的二维码 */
- (void)scanQRCodeFromCurrentImage:(UIImage *)image {
  // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
  // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
  CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
  
  // 取得识别结果
  NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
  
  //格式化结果，并输出
    NSMutableArray *results = [NSMutableArray array];
    for(int i=0;i<features.count;i++){
        CIQRCodeFeature *feature = [features objectAtIndex:i];
        [results addObject:feature.messageString];
    }
    [self dealDelegateSuccess:results];
}

#pragma mark - deal delegate 

- (void)dealDelegateSuccess:(NSArray<NSString *> *)results {
  WMQRCodeScanner *scanner = [WMQRCodeScanner sharedWMQRCodeScanner];
  if(scanner.delegate && [scanner.delegate respondsToSelector:@selector(scanner:didScanOutResult:)]) {
    [scanner.delegate scanner:scanner didScanOutResult:results];
  }
}

@end
