//
//  QRCodeController.h
//  QRCodeTest
//
//  Created by HeT on 17/5/11.
//  Copyright © 2017年 chengsl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeViewConfigProtocol.h"
#import <AVFoundation/AVFoundation.h>
@protocol QRCodeDelegate <NSObject>
- (void)scanResult:(NSArray <AVMetadataObject *>*)metadataObjects;
- (void)scanFail:(NSError *)error;
@end
@interface QRCodeScanController : UIViewController
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, strong) UIView <QRCodeViewConfigProtocol> *configView;
@property (nonatomic, weak) id<QRCodeDelegate>delegate;
//扫描完成，退出页面
- (void)scanCompletion;
@end
