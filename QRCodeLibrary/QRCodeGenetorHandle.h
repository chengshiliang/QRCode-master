//
//  QRCodeGenetorHandle.h
//  Pods
//
//  Created by HeT on 17/5/12.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
typedef NS_ENUM(NSInteger, QRCodeType){
    QRCode,
    QR128Barcode
};
@interface QRCodeGenetorHandle : NSObject
@property (nonatomic, assign) QRCodeType *codeType;
/**
 *根据描述文字生成二维码
 *contentString:描述文字
 */
- (void)qrcodeGenetorWithContentString:(NSString *)contentString completionHandle:(void(^) (UIImage *image,NSError *error))completeHandle;
/**
 *根据描述文字和大小生成二维码
 *contentString:描述文字
 *size:二维码大小
 */
- (void)qrcodeGenetorWithContentString:(NSString *)contentString size:(CGSize)size completionHandle:(void(^) (UIImage *image,NSError *error))completeHandle;
/**
 *根据描述文字和大小生成二维码,并渲染颜色
 *contentString:描述文字
 *size:二维码大小
 *color:二维码颜色
 */
- (void)qrcodeGenetorWithContentString:(NSString *)contentString size:(CGSize)size color:(CIColor *)color completionHandle:(void(^) (UIImage *image,NSError *error))completeHandle;
/**
 *根据描述文字和大小生成二维码,并渲染颜色和添加logo
 *contentString:描述文字
 *size:二维码大小
 *color:二维码颜色
 *logoImage:logo图片
 */
- (void)qrcodeGenetorWithContentString:(NSString *)contentString size:(CGSize)size color:(CIColor *)color logo:(NSString *)logoImageString completionHandle:(void(^) (UIImage *image,NSError *error))completeHandle;
@end
