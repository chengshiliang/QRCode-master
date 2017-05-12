//
//  QRCodeConfigView.m
//  QRCodeTest
//
//  Created by HeT on 17/5/11.
//  Copyright © 2017年 chengsl. All rights reserved.
//

#import "QRCodeConfigView.h"
#define SCANVIEW_EdgeTop (VIEW_HEIGHT-(VIEW_WIDTH-2*SCANVIEW_EdgeLeft))/2.0
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.2 //浅色透明度
#define DARKCOLOR_ALPHA 0.5 //深色透明度
#define VIEW_WIDTH [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT  [UIScreen mainScreen].bounds.size.height
@interface QRCodeConfigView ()
{
    // 扫描上下的图片
    UIImageView     *_QrCodeline;
}
//@property (nonatomic, strong) UIImageView *scanningline;
@end
@implementation QRCodeConfigView
-(void)configView{
    self.frame = CGRectZero;
    self.backgroundColor = [UIColor clearColor];
    //最上部view
    UIView * upView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , SCANVIEW_EdgeTop )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [self addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA ;
    leftView. backgroundColor = [ UIColor blackColor ];
    [self addSubview:leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    scanCropView. backgroundColor =[ UIColor clearColor ];
    [self addSubview:scanCropView];
    //右侧的view
    UIView *rightView = [[ UIView alloc ] initWithFrame : CGRectMake ( VIEW_WIDTH - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA ;
    rightView. backgroundColor = [ UIColor blackColor ];
    [self addSubview:rightView];
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop , VIEW_WIDTH , VIEW_HEIGHT )];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView. backgroundColor = [[ UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA ];
    [self addSubview:downView];
    
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , 5 , VIEW_WIDTH , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = @"将二维码对准方框，即可自动扫描" ;
    [downView addSubview :labIntroudction];
    UIView *darkView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , downView. frame . size . height - 100.0 , VIEW_WIDTH , 100.0 )];
    darkView. backgroundColor = [[ UIColor blackColor ]  colorWithAlphaComponent : DARKCOLOR_ALPHA ];
    [downView addSubview :darkView];
    
    //画中间的基准线
    _QrCodeline = [[UIImageView alloc ] initWithFrame :CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop-VIEW_WIDTH/2+SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft)];
    _QrCodeline.image = [UIImage imageNamed:@"scandown"];
    [self addSubview:_QrCodeline];
    
    UIImageView *scanBackGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    scanBackGroundImageView.image = [UIImage imageNamed:@"scanBackGroundIcon"];
    [self addSubview:scanBackGroundImageView];
}

-(void)startAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0,0,VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft,0)];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0,0,VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft,VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft)];
    animation.duration = 1.5f;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];    //动画速度设置
    _QrCodeline.layer.anchorPoint =CGPointMake(0.5,0);
    
    [_QrCodeline.layer addAnimation:animation forKey:nil];
}

-(void)stopAnimation{
    [_QrCodeline.layer removeAllAnimations];
}
@end
