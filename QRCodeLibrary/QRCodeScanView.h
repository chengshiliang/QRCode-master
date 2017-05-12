//
//  QRCodeScanView.h
//  Pods
//
//  Created by HeT on 17/5/12.
//
//

#import <UIKit/UIKit.h>
#import "QRCodeViewConfigProtocol.h"
@interface QRCodeScanView : UIView
+ (instancetype)initWithTargetView:(UIView *)view configView:(UIView<QRCodeViewConfigProtocol> *)configView;
-(void)startAnimation;
-(void)stopAnimation;
@end
