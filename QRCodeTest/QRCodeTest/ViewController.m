//
//  ViewController.m
//  QRCodeTest
//
//  Created by HeT on 17/5/11.
//  Copyright © 2017年 chengsl. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeScanController.h"
#import "QRCodeConfigView.h"
#import "QRCodeGenetorHandle.h"
@interface ViewController ()<QRCodeDelegate>
@property (nonatomic, strong) QRCodeScanController *vc;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 200, 200)];
    [self.view addSubview:self.imageView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    QRCodeScanController *vc= [[QRCodeScanController alloc]init];
    vc.delegate = self;
    QRCodeConfigView *configView = [[QRCodeConfigView alloc]init];
    vc.configView = configView;
    [self presentViewController:vc animated:YES completion:nil];
    self.vc = vc;
}

- (void)scanResult:(NSArray<AVMetadataObject *> *)metadataObjects{
    NSLog(@"metadataObjects-----\n%@",metadataObjects);
    [self.vc scanCompletion];
    AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)metadataObjects.firstObject;
    QRCodeGenetorHandle *handle = [[QRCodeGenetorHandle alloc]init];
    [handle qrcodeGenetorWithContentString:obj.stringValue size:self.imageView.bounds.size color:[CIColor colorWithRed:0.5 green:0.5 blue:0.5] logo:@"scandown" completionHandle:^(UIImage *image, NSError *error) {
        self.imageView.image = image;
    }];
}

- (void)scanFail:(NSError *)error{
    NSLog(@"error----%@",error);
    [self.vc scanCompletion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
