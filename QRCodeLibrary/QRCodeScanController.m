//
//  QRCodeController.m
//  QRCodeTest
//
//  Created by HeT on 17/5/11.
//  Copyright © 2017年 chengsl. All rights reserved.
//

#import "QRCodeScanController.h"
#import "QRCodeScanView.h"
#import "QRCodeScanHandle.h"

@interface QRCodeScanController ()
@property (nonatomic,strong)QRCodeScanView *codeView;
@property (nonatomic,strong)QRCodeScanHandle *codeHandle;
@end

@implementation QRCodeScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navTitle.length > 0?self.navTitle:@"扫描登录";
    self.view.userInteractionEnabled = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor clearColor];
    self.codeView = [QRCodeScanView initWithTargetView:self.view configView:self.configView];
    [self.codeView startAnimation];
    self.codeHandle = [[QRCodeScanHandle alloc]init];
    [self.codeHandle setupFromView:self.view];
    __weak QRCodeScanController *weakSelf = self;
    self.codeHandle.scanResultBlock = ^(NSArray <AVMetadataObject *>*metadataObjects) {
        __strong QRCodeScanController *strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(scanResult:)]) {
            [strongSelf.delegate scanResult:metadataObjects];
        }
    };
    self.codeHandle.scanFailBlock = ^(NSError *error){
        __strong QRCodeScanController *strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(scanFail:)]) {
            [strongSelf.delegate scanFail:error];
        }
    };
    // Do any additional setup after loading the view.
}
- (void)scanCompletion{
    [self.codeView stopAnimation];
    NSArray <UIViewController *>*vcs = self.navigationController.viewControllers;
    if ([vcs containsObject:self]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
