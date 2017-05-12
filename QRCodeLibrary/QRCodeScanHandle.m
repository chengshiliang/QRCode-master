//
//  QRCodeHandle.m
//  QRCodeTest
//
//  Created by HeT on 17/5/11.
//  Copyright © 2017年 chengsl. All rights reserved.
//

#import "QRCodeScanHandle.h"
@interface QRCodeScanHandle ()<AVCaptureMetadataOutputObjectsDelegate>
/// 会话对象
@property (nonatomic, strong) AVCaptureSession *session;
/// 图层类
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end
@implementation QRCodeScanHandle
- (void)setupFromView:(UIView *)view{
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 5、初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = view.layer.bounds;
    
    // 8、将图层插入当前视图
    [view.layer insertSublayer:_previewLayer atIndex:0];
    
    
    void (^go)() = ^{
        // 2、创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        // 3、创建输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        // 4、设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
        // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
        CGSize size = view.bounds.size;
        CGRect cropRect = CGRectMake(50, 160, 220, 220);
        CGFloat p1 = size.height/size.width;
        CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
        if (p1 < p2) {
            CGFloat fixHeight = view.bounds.size.width * 1920. / 1080.;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                cropRect.origin.x/size.width,
                                                cropRect.size.height/fixHeight,
                                                cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = view.bounds.size.height * 1080. / 1920.;
            CGFloat fixPadding = (fixWidth - size.width)/2;
            output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                                (cropRect.origin.x + fixPadding)/fixWidth,
                                                cropRect.size.height/size.height,
                                                cropRect.size.width/fixWidth);
        
        
        }
        // 5.1 添加会话输入
        [_session addInput:input];
        
        // 5.2 添加会话输出
        [_session addOutput:output];
        
        // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
        // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code];
        
        // 9、启动会话
        [_session startRunning];
    };
    
    
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            go();
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            go();
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            if (self.scanFailBlock) {
                self.scanFailBlock([self errorWithDescription:@"未开启相机权限"]);
            }
        } else if (status == AVAuthorizationStatusRestricted) {
            if (self.scanFailBlock) {
                self.scanFailBlock([self errorWithDescription:@"未开启相机权限"]);
            }
        }
    } else {
        if (self.scanFailBlock) {
            self.scanFailBlock([self errorWithDescription:@"未找到媒体设备"]);
        }
    }
}

- (NSError *)errorWithDescription:(NSString *)description{
    return [NSError errorWithDomain:@"QRCodeFailDomain" code:-1 userInfo:@{@"reason":description}];
}

#pragma mark - - - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // 1、如果扫描完成，停止会话
    [self.session stopRunning];
    // 3、设置界面显示扫描结果
    if (metadataObjects.count) {
        if (self.scanResultBlock) {
            self.scanResultBlock(metadataObjects);
        }
    } else {
        if (self.scanFailBlock) {
            self.scanFailBlock([self errorWithDescription:@"未识别到二维码"]);
        }
    }
}
@end
