//
//  QRCodeScanView.m
//  Pods
//
//  Created by HeT on 17/5/12.
//
//

#import "QRCodeScanView.h"
#import <Masonry.h>
@interface QRCodeScanView ()
@property (nonatomic, strong) UIView <QRCodeViewConfigProtocol> *configView;
@end
@implementation QRCodeScanView

+ (instancetype)initWithTargetView:(UIView *)view configView:(UIView<QRCodeViewConfigProtocol> *)configView{
    return [[self alloc]initWithTargetView:view configView:configView];
}
- (instancetype)initWithTargetView:(UIView *)view configView:(UIView<QRCodeViewConfigProtocol> *)configView{
    if (self == [super init]) {
        self.frame = CGRectZero;
        self.configView = configView;
        [view addSubview:self];
        view.backgroundColor = [UIColor clearColor];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [configView configView];
        [self addSubview:configView];
        [configView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    return self;
}
-(void)startAnimation{
    [self.configView startAnimation];
}
-(void)stopAnimation{
    [self.configView stopAnimation];
}

@end
