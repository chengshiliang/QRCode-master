//
//  QRCodeGenetorHandle.m
//  Pods
//
//  Created by HeT on 17/5/12.
//
//

#import "QRCodeGenetorHandle.h"

@implementation QRCodeGenetorHandle

/**
 *根据描述文字生成二维码
 *contentString:描述文字
 */
- (void)qrcodeGenetorWithContentString:(NSString *)contentString completionHandle:(void (^)(UIImage *image, NSError *error))completeHandle{
    [self qrcodeGenetorWithContentString:contentString size:CGSizeMake(100, 100) completionHandle:completeHandle];
}
/**
 *根据描述文字和大小生成二维码
 *contentString:描述文字
 *size:二维码大小
 */
- (void)qrcodeGenetorWithContentString:(NSString *)contentString size:(CGSize)size completionHandle:(void(^) (UIImage *image,NSError *error))completeHandle{
    [self qrcodeGenetorCIImageWithContentString:contentString completionHandle:^(CIImage *ciimage, NSError *error) {
        [self qrcodeGenetorWithCIImage:ciimage size:size completionHandle:completeHandle];//默认100*100尺寸大小图片
    }];
}
/**
 *根据描述文字和大小生成二维码,并渲染颜色
 *contentString:描述文字
 *size:二维码大小
 *color:二维码颜色
 */
- (void)qrcodeGenetorWithContentString:(NSString *)contentString size:(CGSize)size color:(CIColor *)color completionHandle:(void(^) (UIImage *image,NSError *error))completeHandle{
    [self qrcodeGenetorCIImageWithContentString:contentString completionHandle:^(CIImage *ciimage, NSError *error) {
        if (error) {
            completeHandle(nil,error);
        } else {
            CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
            [filter setValue:ciimage forKey:@"inputImage"];
            [filter setValue:color forKey:@"inputColor0"];
            [filter setDefaults];
            CIImage *outputImage = filter.outputImage;
            if (outputImage == nil) {
                completeHandle(nil, [self errorWithDescription:@"无法生成二维码"]);
                return ;
            }
            [self qrcodeGenetorWithCIImage:outputImage size:size completionHandle:completeHandle];
        }
    }];
}
/**
 *根据描述文字和大小生成二维码,并渲染颜色和添加logo
 *contentString:描述文字
 *size:二维码大小
 *color:二维码颜色
 *logoImage:logo图片
 */
- (void)qrcodeGenetorWithContentString:(NSString *)contentString size:(CGSize)size color:(CIColor *)color logo:(NSString *)logoImageString completionHandle:(void(^) (UIImage *image,NSError *error))completeHandle{
    [self qrcodeGenetorWithContentString:contentString size:size color:color completionHandle:^(UIImage *image, NSError *error) {
        if (logoImageString.length == 0) {
            completeHandle(nil, [self errorWithDescription:@"无logo图片名"]);
            return ;
        }
        UIImage *logoImage = [UIImage imageNamed:logoImageString];
        CGRect imageBounds = CGRectMake(0, 0, image.size.width, image.size.height);
        CGSize logoSize = CGSizeMake(image.size.width*0.25, image.size.height*0.25);
        CGFloat x = (imageBounds.size.width - logoSize.width) * 0.5;
        CGFloat y = (imageBounds.size.height - logoSize.height) * 0.5;
        
        UIGraphicsBeginImageContext(imageBounds.size);
        [image drawInRect:imageBounds];
        [logoImage drawInRect:CGRectMake(x, y, logoSize.width, logoSize.height)];
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (resultImage) {
            completeHandle(resultImage,nil);
        } else {
            completeHandle(nil, [self errorWithDescription:@"无法生成二维码"]);
        }
    }];
}
//根据描述文字生成CIImage，作为后续处理
- (void)qrcodeGenetorCIImageWithContentString:(NSString *)contentString completionHandle:(void (^)(CIImage *ciimage, NSError *error))completeHandle{
    NSData *contentData = [contentString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:self.codeType == QRCode?@"CIQRCodeGenerator":@"CICode128BarcodeGenerator"];
    [filter setValue:contentData forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outputImage = filter.outputImage;
    if (outputImage) {
        completeHandle(outputImage,nil);
    } else {
        completeHandle(nil,[self errorWithDescription:@"描述文字不正确,无法生成二维码"]);
    }
}
//根据CIImage和size，处理图片生成image
- (void)qrcodeGenetorWithCIImage:(CIImage *)ciimage size:(CGSize)size completionHandle:(void (^)(UIImage *image, NSError *error))completeHandle{
    CGFloat width = size.width*[UIScreen mainScreen].scale;
    CGFloat height = size.height*[UIScreen mainScreen].scale;
    // 计算合适的缩放比例
    CGFloat scale = MIN(width, height) / MIN(ciimage.extent.size.width, ciimage.extent.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//创建RGB颜色空间
    CGContextRef cgcontext = CGBitmapContextCreateWithData(nil, width, height, 8, 0, colorSpace, kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder32Little, nil, nil);//创建颜色空间上下文(兼容有无颜色)
    //只针对黑白
//    CGContextRef cgcontext = CGBitmapContextCreateWithData(nil, width, height, 8, 0, colorSpace, kCGImageAlphaNone, nil, nil);
    CGContextSetInterpolationQuality(cgcontext, kCGInterpolationNone);
    CGContextScaleCTM(cgcontext, scale, scale);
    
    CIContext *cicontext = [CIContext contextWithCGContext:cgcontext options:nil];
    CGImageRef cgimage = [cicontext createCGImage:ciimage fromRect:ciimage.extent];
    if (cgimage == nil) {
        completeHandle(nil,[self errorWithDescription:@"无法生成二维码"]);
        return;
    }
    
    CGContextDrawImage(cgcontext, ciimage.extent, cgimage);
    CGImageRef image = CGBitmapContextCreateImage(cgcontext);
    CGImageRelease(cgimage);
    CGContextRelease(cgcontext);
    if (image) {
        completeHandle([UIImage imageWithCGImage:image],nil);
    } else {
        completeHandle(nil,[self errorWithDescription:@"无法生成二维码"]);
    }
}

- (NSError *)errorWithDescription:(NSString *)description{
    return [NSError errorWithDomain:@"QRCodeFailDomain" code:-1 userInfo:@{@"reason":description}];
}
@end
