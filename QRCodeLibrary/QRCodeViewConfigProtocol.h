//
//  QRCodeViewConfigProtocol.h
//  QRCodeTest
//
//  Created by HeT on 17/5/11.
//  Copyright © 2017年 chengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QRCodeViewConfigProtocol <NSObject>
- (void)configView;
- (void)startAnimation;
- (void)stopAnimation;
@end
