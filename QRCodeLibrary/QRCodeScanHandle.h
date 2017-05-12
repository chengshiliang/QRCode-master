//
//  QRCodeHandle.h
//  QRCodeTest
//
//  Created by HeT on 17/5/11.
//  Copyright © 2017年 chengsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface QRCodeScanHandle : NSObject
- (void)setupFromView:(UIView *)view;
@property (nonatomic, copy) void (^scanResultBlock)(NSArray <AVMetadataObject *>*metadataObjects);
@property (nonatomic, copy) void (^scanFailBlock)(NSError *error);
@end
